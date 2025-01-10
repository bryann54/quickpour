import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/checkout/presentation/pages/delivery_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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

  @override
  void initState() {
    super.initState();
    // Prefill the address field with the address passed from CheckoutScreen
    _searchController.text = widget.address;
    _convertAddressToLatLng(widget.address);
  }

  // Method to convert address to latitude and longitude
  Future<void> _convertAddressToLatLng(String address) async {
    try {
      // Geocode the provided address to get latitude and longitude
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          _selectedLocation =
              LatLng(locations[0].latitude, locations[0].longitude);
          _isLoading = false;
        });
        _getAddressFromLatLng(_selectedLocation!);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error converting address to LatLng: $e');
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
        setState(() {
          _currentAddress =
              '${place.street}, ${place.subLocality}, ${place.locality}';
          _searchController.text = _currentAddress!;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
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
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search location',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Map
          Expanded(
            flex: 2,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _selectedLocation ??
                              const LatLng(
                                  -1.2921, 36.8219), // Default to Nairobi
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

          // Address Details Form
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
