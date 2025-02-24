import 'package:chupachap/core/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

import 'package:chupachap/core/utils/colors.dart';

class PlaceAutocompletePage extends StatefulWidget {
  const PlaceAutocompletePage({super.key});

  @override
  State<PlaceAutocompletePage> createState() => _PlaceAutocompletePageState();
}

class _PlaceAutocompletePageState extends State<PlaceAutocompletePage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<Map<String, dynamic>> _predictions = [];
  bool _showRecentLocations = true;
  List<Map<String, dynamic>> _recentLocations = [];
  List<Map<String, dynamic>> _savedLocations = [];
  Map<String, dynamic>? _currentLocation;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadSavedLocations();
    _loadRecentLocations();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      // Check location permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      // Fetch current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert coordinates to address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String mainText = place.street ?? 'Current Location';
        String secondaryText = [
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        setState(() {
          _currentLocation = {
            'description': '$mainText, $secondaryText',
            'mainText': mainText,
            'secondaryText': secondaryText,
            'location': {
              'lat': position.latitude,
              'lng': position.longitude,
            },
            'city': place.locality ?? '',
            'country': place.country ?? '',
            'isSaved': false,
          };
        });
      }
    } catch (e) {
      debugPrint('Error fetching current location: $e');
    }
  }

  Future<void> _loadSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocationsJson = prefs.getStringList('savedLocations') ?? [];

    setState(() {
      _savedLocations = savedLocationsJson
          .map((json) => jsonDecode(json) as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> _loadRecentLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final recentLocationsJson = prefs.getStringList('recentLocations') ?? [];

    setState(() {
      _recentLocations = recentLocationsJson
          .map((json) => jsonDecode(json) as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> _saveRecentLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final recentLocationsJson =
        _recentLocations.map((loc) => jsonEncode(loc)).toList();
    await prefs.setStringList('recentLocations', recentLocationsJson);
  }

  Future<void> _saveLocation(Map<String, dynamic> location) async {
    if (!_savedLocations.any((loc) =>
        loc['mainText'] == location['mainText'] &&
        loc['secondaryText'] == location['secondaryText'])) {
      _savedLocations.add(location);
      final prefs = await SharedPreferences.getInstance();
      final savedLocationsJson =
          _savedLocations.map((loc) => jsonEncode(loc)).toList();
      await prefs.setStringList('savedLocations', savedLocationsJson);
    }
  }

  Future<void> _removeLocation(Map<String, dynamic> location) async {
    _savedLocations.removeWhere((loc) =>
        loc['mainText'] == location['mainText'] &&
        loc['secondaryText'] == location['secondaryText']);

    final prefs = await SharedPreferences.getInstance();
    final savedLocationsJson =
        _savedLocations.map((loc) => jsonEncode(loc)).toList();
    await prefs.setStringList('savedLocations', savedLocationsJson);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.length > 2) {
        _getLocationPredictions(_searchController.text);
        setState(() {
          _showRecentLocations = false;
        });
      } else {
        setState(() {
          _predictions = [];
          _showRecentLocations = true;
        });
      }
    });
  }

  Future<void> _getLocationPredictions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
        _showRecentLocations = true;
      });
      return;
    }

    setState(() {});

    try {
      List<Location> locations = await locationFromAddress(query);
      List<Map<String, dynamic>> predictions = [];

      for (var location in locations) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );

          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            if (place.country == 'Kenya') {
              String mainText = place.street ?? '';
              String secondaryText = [
                place.subLocality,
                place.locality,
                place.administrativeArea,
                place.country
              ].where((e) => e != null && e.isNotEmpty).join(', ');

              predictions.add({
                'description': '$mainText, $secondaryText',
                'mainText': mainText,
                'secondaryText': secondaryText,
                'location': {
                  'lat': location.latitude,
                  'lng': location.longitude,
                },
                'city': place.locality ?? '',
                'country': place.country ?? '',
              });
            }
          }
        } catch (e) {
          debugPrint('Error getting place details: $e');
        }
      }

      if (mounted) {
        setState(() {
          _predictions = predictions;
        });
      }
    } catch (e) {
      debugPrint('Error fetching locations: $e');

      if (mounted) {
        setState(() {
          _predictions = [];
        });
      }
    }
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search road ,apartmernt...',
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDarkMode ? Colors.grey[500] : Colors.grey[700],
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _predictions = [];
                      _showRecentLocations = true;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildListSection(String title, List<Map<String, dynamic>> locations) {
    if (locations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: locations.length,
          separatorBuilder: (context, index) => Divider(
            height: 2,
            color: Theme.of(
              context,
            ).dividerColor.withOpacity(.1),
          ),
          itemBuilder: (context, index) {
            final location = locations[index];
            bool isSaved = _savedLocations.any((loc) =>
                loc['mainText'] == location['mainText'] &&
                loc['secondaryText'] == location['secondaryText']);

            return ListTile(
              leading:
                  const Icon(Icons.location_on, color: AppColors.accentColor),
              title: Text(location['mainText'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                location['secondaryText'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  color: isSaved ? AppColors.accentColor : Colors.grey,
                ),
                onPressed: () async {
                  if (isSaved) {
                    await _removeLocation(location);
                  } else {
                    await _saveLocation(location);
                  }
                  setState(() {});
                },
              ),
              onTap: () {
                _saveRecentLocations();
                Navigator.pop(context, location);
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'delivery location'.capitalize(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(isDarkMode),
          Expanded(
            child: ListView(
              children: [
                if (_currentLocation != null)
                  _buildListSection('Current Location', [_currentLocation!]),
                if (_showRecentLocations)
                  _buildListSection('Recent Locations', _recentLocations),
                _buildListSection('Predictions', _predictions),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
