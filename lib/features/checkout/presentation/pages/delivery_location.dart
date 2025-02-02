import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/checkout/presentation/pages/delivery_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart'; // Add this import

class DeliveryLocationScreen extends StatefulWidget {
  final double totalAmount;
  final String address;
  final String phoneNumber;

  const DeliveryLocationScreen({
    Key? key,
    required this.totalAmount,
    required this.address,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<DeliveryLocationScreen> createState() => _DeliveryLocationScreenState();
}

class _DeliveryLocationScreenState extends State<DeliveryLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _addressDetailsController =
      TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String? _currentAddress;
  bool _isLoading = true;
  List<String> _addressPredictions = [];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.address;
    _getUserCurrentLocation(); // Fetch user's current location
  }

  // Fetch user's current location
  Future<void> _getUserCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Handle case where location services are disabled
        debugPrint('Location services are disabled.');
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Handle case where permissions are denied
          debugPrint('Location permissions are denied.');
          return;
        }
      }

      // Fetch current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Set the default location to the user's current location
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });

      // Convert coordinates to address
      _getAddressFromLatLng(_selectedLocation!);

      // Update the map camera to the user's current location
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_selectedLocation!),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching current location: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _convertAddressToLatLng(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          _selectedLocation =
              LatLng(locations[0].latitude, locations[0].longitude);
        });
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(_selectedLocation!),
        );
        _getAddressFromLatLng(_selectedLocation!);
      }
    } catch (e) {
      debugPrint('Error converting address to LatLng: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              '${place.street}, ${place.subLocality}, ${place.locality}';
          _searchController.text = _currentAddress!;
        });
      }
    } catch (e) {
      debugPrint('Error getting address from LatLng: $e');
    }
  }

  Future<void> _getAddressPredictions(String query) async {
    if (query.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(query);
        List<Placemark> placemarks = await placemarkFromCoordinates(
          locations.first.latitude,
          locations.first.longitude,
        );
        setState(() {
          _addressPredictions = placemarks
              .map((placemark) =>
                  '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}')
              .toList();
        });
      } catch (e) {
        setState(() {
          _addressPredictions = [];
        });
      }
    } else {
      setState(() {
        _addressPredictions = [];
      });
    }
  }

  void _searchLocation() {
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      _convertAddressToLatLng(_searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Location'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) => _getAddressPredictions(value),
                  onSubmitted: (_) => _searchLocation(),
                  decoration: InputDecoration(
                    hintText: 'Search location',
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _searchLocation,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (_addressPredictions.isNotEmpty)
                  Container(
                    height: 100,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      itemCount: _addressPredictions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_addressPredictions[index]),
                          onTap: () {
                            _searchController.text = _addressPredictions[index];
                            setState(() {
                              _addressPredictions = [];
                            });
                            _searchLocation();
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _selectedLocation ??
                              const LatLng(-1.2921, 36.8219),
                          zoom: 15,
                        ),
                        onMapCreated: (controller) =>
                            _mapController = controller,
                        onCameraMove: (position) {
                          setState(() {
                            _selectedLocation = position.target;
                          });
                        },
                        onCameraIdle: () {
                          if (_selectedLocation != null) {
                            _getAddressFromLatLng(_selectedLocation!);
                          }
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                      ),
                      Center(
                        child: Icon(
                          Icons.location_pin,
                          color: Theme.of(context).primaryColor,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Delivery Address Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _addressDetailsController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Apartment, Floor, Landmark etc.',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedLocation != null) {
                        // Update the checkout bloc with address
                        context
                            .read<CheckoutBloc>()
                            .add(UpdateDeliveryInfoEvent(
                              address:
                                  '${_currentAddress ?? ''}\n${_addressDetailsController.text}',
                              phoneNumber: widget.phoneNumber,
                            ));

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DeliveryDetailsScreen(
                              address: _currentAddress ?? '',
                              addressDetails: _addressDetailsController.text,
                              location: _selectedLocation!,
                              totalAmount: widget.totalAmount,
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Confirm Location'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
