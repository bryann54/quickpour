import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:chupachap/core/utils/colors.dart';

class PlaceAutocompletePage extends StatefulWidget {
  const PlaceAutocompletePage({super.key});

  @override
  State<PlaceAutocompletePage> createState() => _PlaceAutocompletePageState();
}

class _PlaceAutocompletePageState extends State<PlaceAutocompletePage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isLoading = false;
  List<Map<String, dynamic>> _predictions = [];
  bool _showRecentLocations = true;
  List<Map<String, dynamic>> _recentLocations = [];
  List<Map<String, dynamic>> _savedLocations = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadSavedLocations();
    _loadRecentLocations();
  }

  Future<void> _loadSavedLocations() async {
    // This would typically come from local storage or your backend
    // For demonstration, we'll use dummy data
    setState(() {
      _savedLocations = [
        {
          'description': 'Home, Westlands, Nairobi, Kenya',
          'mainText': 'Home',
          'secondaryText': 'Westlands, Nairobi, Kenya',
          'location': {'lat': -1.2640, 'lng': 36.8208},
          'city': 'Nairobi',
          'country': 'Kenya',
          'isSaved': true,
        },
        {
          'description': 'Work, CBD, Nairobi, Kenya',
          'mainText': 'Work',
          'secondaryText': 'CBD, Nairobi, Kenya',
          'location': {'lat': -1.2921, 'lng': 36.8219},
          'city': 'Nairobi',
          'country': 'Kenya',
          'isSaved': true,
        },
      ];
    });
  }

  Future<void> _loadRecentLocations() async {
    // This would typically come from local storage
    // For demonstration, we'll use dummy data
    setState(() {
      _recentLocations = [
        {
          'description': 'Junction Mall, Ngong Road, Nairobi, Kenya',
          'mainText': 'Junction Mall',
          'secondaryText': 'Ngong Road, Nairobi, Kenya',
          'location': {'lat': -1.2988, 'lng': 36.7623},
          'city': 'Nairobi',
          'country': 'Kenya',
          'isRecent': true,
        },
        {
          'description': 'Garden City Mall, Thika Road, Nairobi, Kenya',
          'mainText': 'Garden City Mall',
          'secondaryText': 'Thika Road, Nairobi, Kenya',
          'location': {'lat': -1.2302, 'lng': 36.8788},
          'city': 'Nairobi',
          'country': 'Kenya',
          'isRecent': true,
        },
      ];
    });
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
        _isLoading = false;
        _showRecentLocations = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

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
              // Filter results to Kenya
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

      // Additionally, you might want to add predictions from a custom API
      if (query.toLowerCase().contains('mall') ||
          query.toLowerCase().contains('center')) {
        predictions.add({
          'description': 'Two Rivers Mall, Limuru Road, Nairobi, Kenya',
          'mainText': 'Two Rivers Mall',
          'secondaryText': 'Limuru Road, Nairobi, Kenya',
          'location': {'lat': -1.2143, 'lng': 36.8053},
          'city': 'Nairobi',
          'country': 'Kenya',
          'isAlternative': true,
        });
      }

      if (mounted) {
        setState(() {
          _predictions = predictions;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching locations: $e');

      // Fallback to nearby suggestions if geocoding fails
      List<Map<String, dynamic>> fallbackPredictions = [
        {
          'description': 'Near ${_searchController.text}, Nairobi, Kenya',
          'mainText': 'Near ${_searchController.text}',
          'secondaryText': 'Possible nearby location',
          'location': {'lat': -1.2864, 'lng': 36.8172},
          'city': 'Nairobi',
          'country': 'Kenya',
          'isFallback': true,
        },
      ];

      if (mounted) {
        setState(() {
          _predictions = fallbackPredictions;
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildLocationList(
      List<Map<String, dynamic>> locations, String emptyMessage) {
    if (locations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          emptyMessage,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: locations.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final location = locations[index];
        return ListTile(
          leading: Icon(
            location['isSaved'] == true
                ? Icons.home
                : location['isRecent'] == true
                    ? Icons.history
                    : location['isAlternative'] == true
                        ? Icons.explore
                        : location['isFallback'] == true
                            ? Icons.near_me
                            : Icons.location_on,
            color: location['isSaved'] == true
                ? Colors.green
                : location['isRecent'] == true
                    ? Colors.blue
                    : AppColors.accentColor,
          ),
          title: Text(
            location['mainText'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            location['secondaryText'] ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: location['isSaved'] == true || location['isRecent'] == true
              ? const Icon(Icons.arrow_forward_ios, size: 14)
              : null,
          onTap: () {
            setState(() {
              _recentLocations.insert(0, {
                'description': location['description'],
                'mainText': location['mainText'],
                'secondaryText': location['secondaryText'],
                'location': location['location'],
                'city': location['city'],
                'country': location['country'],
                'isRecent': true,
              });

              if (_recentLocations.length > 5) {
                _recentLocations.removeLast();
              }
            });

            Navigator.pop(context, location);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Location'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search for a location',
                prefixIcon: const Icon(Icons.search),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Center(
                child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ))
          else
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_predictions.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader('Search Results'),
                          _buildLocationList(
                              _predictions, 'No locations found'),
                        ],
                      ),
                    if (_showRecentLocations) ...[
                      if (_savedLocations.isNotEmpty) ...[
                        _buildSectionHeader('Saved Locations'),
                        _buildLocationList(
                            _savedLocations, 'No saved locations'),
                      ],
                      if (_recentLocations.isNotEmpty) ...[
                        _buildSectionHeader('Recent Locations'),
                        _buildLocationList(
                            _recentLocations, 'No recent locations'),
                      ] else ...[
                        _buildSectionHeader('Recent Locations'),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'No recents yet',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Center(child: Text('feature coming soon😎!!'))),
          );
        },
        child: const Icon(Icons.map),
        tooltip: 'Select on map',
      ),
    );
  }
}
