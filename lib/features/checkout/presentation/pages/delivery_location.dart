import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/checkout/presentation/pages/delivery_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    _searchController.text = widget.address;
    _convertAddressToLatLng(widget.address);
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
            child: TextField(
              controller: _searchController,
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
