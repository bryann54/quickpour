import 'package:chupachap/features/checkout/data/models/delivery_location.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/checkout/presentation/pages/delivery_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DeliveryLocationScreen extends StatefulWidget {
  final double totalAmount;
  final DeliveryLocation location;
  final String phoneNumber;

  const DeliveryLocationScreen({
    Key? key,
    required this.totalAmount,
    required this.location,
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
  List<DeliveryLocation> _locationPredictions = [];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    // Initialize with the location passed from checkout screen
    setState(() {
      _selectedLocation = LatLng(
        widget.location.latitude,
        widget.location.longitude,
      );
      _currentAddress = widget.location.address;
      _searchController.text = widget.location.address;
      _isLoading = false;
    });
  }

  Future<void> _getUserCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied.');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });

      _getAddressFromLatLng(_selectedLocation!);
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_selectedLocation!),
      );
    } catch (e) {
      debugPrint('Error fetching current location: $e');
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            '${place.street}, ${place.subLocality}, ${place.locality}';
        setState(() {
          _currentAddress = address;
          _searchController.text = address;
        });
      }
    } catch (e) {
      debugPrint('Error getting address from LatLng: $e');
    }
  }

  Future<void> _getLocationPredictions(String query) async {
    if (query.isEmpty) {
      setState(() => _locationPredictions = []);
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(query);
      List<DeliveryLocation> predictions = [];

      for (var location in locations) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String mainText = place.street ?? '';
          String secondaryText = [
            place.subLocality,
            place.locality,
            place.administrativeArea
          ].where((e) => e != null && e.isNotEmpty).join(', ');

          predictions.add(DeliveryLocation(
            address: '$mainText, $secondaryText',
            latitude: location.latitude,
            longitude: location.longitude,
            mainText: mainText,
            secondaryText: secondaryText,
          ));
        }
      }

      setState(() => _locationPredictions = predictions);
    } catch (e) {
      debugPrint('Error fetching locations: $e');
      setState(() => _locationPredictions = []);
    }
  }

  void _selectLocation(DeliveryLocation location) {
    setState(() {
      _selectedLocation = LatLng(location.latitude, location.longitude);
      _searchController.text = location.address;
      _currentAddress = location.address;
      _locationPredictions = [];
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_selectedLocation!),
    );
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
                  onChanged: _getLocationPredictions,
                  decoration: InputDecoration(
                    hintText: 'Search location',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.my_location),
                      onPressed: _getUserCurrentLocation,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                if (_locationPredictions.isNotEmpty)
                  Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
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
                      shrinkWrap: true,
                      itemCount: _locationPredictions.length,
                      itemBuilder: (context, index) {
                        final prediction = _locationPredictions[index];
                        return ListTile(
                          title: Text(prediction.mainText),
                          subtitle: Text(
                            prediction.secondaryText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => _selectLocation(prediction),
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
                          target: _selectedLocation!,
                          zoom: 15,
                        ),
                        onMapCreated: (controller) =>
                            _mapController = controller,
                        onCameraMove: (position) {
                          _selectedLocation = position.target;
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
                        context.read<CheckoutBloc>().add(
                              UpdateDeliveryInfoEvent(
                                address:
                                    '${_currentAddress ?? ''}\n${_addressDetailsController.text}',
                                phoneNumber: widget.phoneNumber,
                              ),
                            );

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
