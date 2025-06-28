import 'package:chupachap/core/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shimmer/shimmer.dart';

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
  bool _isLoading = false;
  List<Map<String, dynamic>> _recentLocations = [];
  List<Map<String, dynamic>> _savedLocations = [];
  Map<String, dynamic>? _currentLocation;

  // Get Google API key from environment variables based on platform
  static String get _googleApiKey {
    if (Platform.isAndroid) {
      return dotenv.env['GOOGLE_MAPS_API_KEY_ANDROID'] ?? '';
    } else if (Platform.isIOS) {
      return dotenv.env['GOOGLE_MAPS_API_KEY_IOS'] ?? '';
    }
    return '';
  }

  // Kenya bounds for better local results
  static const String _kenyaBounds =
      'location=-1.286389,36.817223&radius=500000';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadSavedLocations();
    _loadRecentLocations();
    _fetchCurrentLocation();
  }

  // Helper method to convert IconData to a serializable format
  String _iconDataToString(IconData iconData) {
    return iconData.codePoint.toString();
  }

  // Helper method to convert string back to IconData
  IconData _stringToIconData(String iconString) {
    try {
      int codePoint = int.parse(iconString);
      return IconData(codePoint, fontFamily: 'MaterialIcons');
    } catch (e) {
      return Icons.location_on; // Default fallback
    }
  }

  // Helper method to create a serializable location object
  Map<String, dynamic> _createSerializableLocation(
      Map<String, dynamic> location) {
    Map<String, dynamic> serializable = Map<String, dynamic>.from(location);

    // Convert IconData to string for serialization
    if (serializable['icon'] is IconData) {
      serializable['iconCode'] = _iconDataToString(serializable['icon']);
      serializable.remove('icon'); // Remove the non-serializable icon
    }

    return serializable;
  }

  // Helper method to restore IconData from serialized location
  Map<String, dynamic> _restoreLocationIcon(Map<String, dynamic> location) {
    Map<String, dynamic> restored = Map<String, dynamic>.from(location);

    // Restore IconData from string
    if (restored.containsKey('iconCode')) {
      restored['icon'] = _stringToIconData(restored['iconCode']);
    } else {
      // Set default icon if none exists
      restored['icon'] =
          getIconForPlaceType(List<String>.from(restored['types'] ?? []));
    }

    return restored;
  }

  Future<void> _fetchCurrentLocation() async {
    try {
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

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

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
            'placeType': 'current_location',
            'icon': Icons.my_location,
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
          .map((json) =>
              _restoreLocationIcon(jsonDecode(json) as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> _loadRecentLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final recentLocationsJson = prefs.getStringList('recentLocations') ?? [];

    setState(() {
      _recentLocations = recentLocationsJson
          .map((json) =>
              _restoreLocationIcon(jsonDecode(json) as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> _saveRecentLocation(Map<String, dynamic> location) async {
    // Create serializable version
    _createSerializableLocation(location);

    // Remove if already exists to avoid duplicates
    _recentLocations.removeWhere((loc) =>
        loc['mainText'] == location['mainText'] &&
        loc['secondaryText'] == location['secondaryText']);

    // Add to beginning of list
    _recentLocations.insert(0, location);

    // Keep only last 10 recent locations
    if (_recentLocations.length > 10) {
      _recentLocations = _recentLocations.take(10).toList();
    }

    final prefs = await SharedPreferences.getInstance();
    final recentLocationsJson = _recentLocations
        .map((loc) => jsonEncode(_createSerializableLocation(loc)))
        .toList();
    await prefs.setStringList('recentLocations', recentLocationsJson);
  }

  Future<void> _saveLocation(Map<String, dynamic> location) async {
    if (!_savedLocations.any((loc) =>
        loc['mainText'] == location['mainText'] &&
        loc['secondaryText'] == location['secondaryText'])) {
      _savedLocations.add(location);
      final prefs = await SharedPreferences.getInstance();
      final savedLocationsJson = _savedLocations
          .map((loc) => jsonEncode(_createSerializableLocation(loc)))
          .toList();
      await prefs.setStringList('savedLocations', savedLocationsJson);
      setState(() {});
    }
  }

  Future<void> _removeLocation(Map<String, dynamic> location) async {
    _savedLocations.removeWhere((loc) =>
        loc['mainText'] == location['mainText'] &&
        loc['secondaryText'] == location['secondaryText']);

    final prefs = await SharedPreferences.getInstance();
    final savedLocationsJson = _savedLocations
        .map((loc) => jsonEncode(_createSerializableLocation(loc)))
        .toList();
    await prefs.setStringList('savedLocations', savedLocationsJson);
    setState(() {});
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
        _getGooglePlacePredictions(_searchController.text);
        setState(() {
          _showRecentLocations = false;
        });
      } else {
        setState(() {
          _predictions = [];
          _showRecentLocations = true;
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _getGooglePlacePredictions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
        _showRecentLocations = true;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Google Places Autocomplete API
      final String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=${Uri.encodeComponent(query)}'
          '&key=$_googleApiKey'
          '&components=country:ke'
          '&$_kenyaBounds'
          '&types=establishment|geocode'
          '&language=en';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK') {
          List<Map<String, dynamic>> predictions = [];

          for (var prediction in data['predictions']) {
            // Get place details for better information
            final placeDetails = await _getPlaceDetails(prediction['place_id']);

            if (placeDetails != null) {
              predictions.add(placeDetails);
            } else {
              // Fallback to basic prediction data
              predictions.add(_createPredictionFromBasicData(prediction));
            }
          }

          if (mounted) {
            setState(() {
              _predictions = predictions;
              _isLoading = false;
            });
          }
        } else {
          throw Exception('API Error: ${data['status']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching Google Places: $e');

      // Fallback to geocoding if Google Places fails
      await _getFallbackPredictions(query);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _getPlaceDetails(String placeId) async {
    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/details/json'
          '?place_id=$placeId'
          '&key=$_googleApiKey'
          '&fields=name,formatted_address,geometry,types,business_status';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK') {
          final result = data['result'];
          final location = result['geometry']['location'];
          final types = List<String>.from(result['types'] ?? []);

          return {
            'description': result['formatted_address'] ?? '',
            'mainText':
                result['name'] ?? extractMainText(result['formatted_address']),
            'secondaryText': extractSecondaryText(
                result['formatted_address'], result['name']),
            'location': {
              'lat': location['lat'],
              'lng': location['lng'],
            },
            'city': extractCity(result['formatted_address']),
            'country': 'Kenya',
            'placeType': getPlaceType(types),
            'icon': getIconForPlaceType(types),
            'types': types,
            'place_id': placeId, // Include place_id for reference
          };
        }
      }
    } catch (e) {
      debugPrint('Error getting place details: $e');
    }
    return null;
  }

  Map<String, dynamic> _createPredictionFromBasicData(
      Map<String, dynamic> prediction) {
    final description = prediction['description'] ?? '';
    final structuredFormatting = prediction['structured_formatting'] ?? {};
    final mainText = structuredFormatting['main_text'] ?? '';
    final secondaryText = structuredFormatting['secondary_text'] ?? '';
    final types = List<String>.from(prediction['types'] ?? []);

    return {
      'description': description,
      'mainText': mainText,
      'secondaryText': secondaryText,
      'location': {'lat': 0.0, 'lng': 0.0}, // Will need to geocode separately
      'city': extractCity(description),
      'country': 'Kenya',
      'placeType': getPlaceType(types),
      'icon': getIconForPlaceType(types),
      'types': types,
      'place_id': prediction['place_id'],
    };
  }

  Future<void> _getFallbackPredictions(String query) async {
    try {
      List<Location> locations = await locationFromAddress('$query, Kenya');
      List<Map<String, dynamic>> predictions = [];

      for (var location in locations.take(5)) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );

          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            String mainText = place.street ?? place.name ?? query;
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
              'placeType': 'geocoded',
              'icon': Icons.location_on,
            });
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
      debugPrint('Error with fallback geocoding: $e');
      if (mounted) {
        setState(() {
          _predictions = [];
        });
      }
    }
  }

  // Enhanced selection handler with better error handling
  Future<void> _handleLocationSelection(Map<String, dynamic> location) async {
    try {
      // Ensure location has valid coordinates
      if (location['location'] == null ||
          location['location']['lat'] == null ||
          location['location']['lng'] == null) {
        // Try to geocode if coordinates are missing
        await _geocodeLocation(location);
      }

      // Save to recent locations
      await _saveRecentLocation(location);

      // Return the location to previous screen
      if (mounted) {
        Navigator.pop(context, location);
      }
    } catch (e) {
      debugPrint('Error handling location selection: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting location: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Helper method to geocode location if coordinates are missing
  Future<void> _geocodeLocation(Map<String, dynamic> location) async {
    try {
      final address = location['description'] ??
          '${location['mainText']}, ${location['secondaryText']}';

      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        location['location'] = {
          'lat': locations.first.latitude,
          'lng': locations.first.longitude,
        };
      }
    } catch (e) {
      debugPrint('Error geocoding location: $e');
      // Set default coordinates if geocoding fails
      location['location'] = {'lat': 0.0, 'lng': 0.0};
    }
  }

// In _buildListSection (updated minimal design)
  Widget _buildListSection(String title, List<Map<String, dynamic>> locations) {
    if (locations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: locations.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
          itemBuilder: (context, index) {
            final location = locations[index];
            final isSaved = _savedLocations.any((loc) =>
                loc['mainText'] == location['mainText'] &&
                loc['secondaryText'] == location['secondaryText']);

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  location['icon'] ?? Icons.location_on,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              title: Text(
                location['mainText'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                location['secondaryText'] ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).hintColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSaved
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: .1)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_outline,
                    size: 20,
                    color: isSaved
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context)
                            .iconTheme
                            .color
                            ?.withValues(alpha: 0.4),
                  ),
                ),
                onPressed: () async {
                  if (isSaved) {
                    await _removeLocation(location);
                  } else {
                    await _saveLocation(location);
                  }
                },
                splashRadius: 20,
                padding: EdgeInsets.zero,
              ),
              onTap: () => _handleLocationSelection(location),
            );
          },
        ),
      ],
    );
  }

// Updated search bar for minimal design
  Widget _buildSearchBar(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search apartments, landmarks, addresses...',
          hintStyle: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: Theme.of(context).hintColor,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _predictions = [];
                      _showRecentLocations = true;
                      _isLoading = false;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
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
                if (_showRecentLocations && _recentLocations.isNotEmpty)
                  _buildListSection('Recent Locations', _recentLocations),
                if (_savedLocations.isNotEmpty)
                  _buildListSection('Saved Locations', _savedLocations),
                if (_predictions.isNotEmpty)
                  _buildListSection('Search Results', _predictions),
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(child: _buildShimmerLoading(isDarkMode)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading(bool isDarkMode) {
    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[500]! : Colors.grey[100]!,
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Icon placeholder
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 16),
                // Text content placeholder
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main text placeholder
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Subtitle placeholder
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Type label placeholder
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Trailing icon placeholder
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
