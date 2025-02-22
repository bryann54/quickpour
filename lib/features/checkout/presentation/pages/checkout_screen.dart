import 'dart:convert';

import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/checkout/data/models/delivery_details_model.dart';
import 'package:chupachap/features/checkout/presentation/pages/delivery_location.dart';
import 'package:chupachap/features/checkout/presentation/pages/place_auto_complete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isAddressEmpty = true;
  bool _isPhoneEmpty = true;
  DeliveryDetails? _selectedLocation;
  List<DeliveryDetails> _recentLocations = [];

  @override
  void initState() {
    super.initState();
    _addressController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _loadRecentLocations();
  }

  Future<void> _loadRecentLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final locationsJson = prefs.getStringList('recentLocations') ?? [];

    setState(() {
      _recentLocations = locationsJson
          .map((json) => DeliveryDetails.fromJson(jsonDecode(json)))
          .take(2)
          .toList();
    });
  }

  Future<void> _saveRecentLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final locationsJson = _recentLocations
        .map((location) => jsonEncode(location.toJson()))
        .toList();
    await prefs.setStringList('recentLocations', locationsJson);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isAddressEmpty = _addressController.text.isEmpty;
      _isPhoneEmpty = _phoneController.text.length != 12;
    });
  }

  Future<void> _navigateToPlaceAutocomplete() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PlaceAutocompletePage(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final location = DeliveryDetails(
        address: result['description'],
        latitude: result['location']['lat'],
        longitude: result['location']['lng'],
        mainText: result['mainText'] ?? result['description'].split(',')[0],
        secondaryText: result['secondaryText'] ??
            result['description']
                .substring(result['description'].indexOf(',') + 1)
                .trim(),
        phoneNumber: _phoneController.text,
      );

      setState(() {
        _selectedLocation = location;
        _addressController.text = location.address;

        // Add to recent locations
        if (!_recentLocations.any((loc) => loc.address == location.address)) {
          _recentLocations.insert(0, location);
          if (_recentLocations.length > 5) {
            _recentLocations.removeLast();
          }
        }
      });

      // Save to local storage
      await _saveRecentLocations();
    }
  }

  void _selectRecentLocation(DeliveryDetails location) {
    setState(() {
      _selectedLocation = location;
      _addressController.text = location.address;
      _phoneController.text = location.phoneNumber;
    });
  }

  Widget _buildRecentLocationsList() {
    if (_recentLocations.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 12.0, bottom: 8.0),
          child: Text(
            'Recent Locations',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _recentLocations.length + 1, // +1 for "add new" card
            itemBuilder: (context, index) {
              if (index == _recentLocations.length) {
                // "Add new location" card
                return GestureDetector(
                  onTap: _navigateToPlaceAutocomplete,
                  child: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_location_alt,
                            color: AppColors.accentColor),
                        SizedBox(height: 8),
                        Text(
                          'Add New',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final location = _recentLocations[index];
              final isSelected = _selectedLocation?.address == location.address;

              return Stack(
                children: [
                  GestureDetector(
                    onTap: () => _selectRecentLocation(location),
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.accentColor.withOpacity(0.1)
                            : null,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.accentColor
                              : Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: isSelected
                                      ? AppColors.accentColor
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    location.mainText,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: isSelected
                                          ? AppColors.accentColor
                                          : null,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              location.secondaryText,
                              style: const TextStyle(fontSize: 11),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () async {
                        setState(() {
                          _recentLocations.removeAt(index);
                        });
                        await _saveRecentLocations();
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Delivery Information',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        _buildRecentLocationsList(),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _navigateToPlaceAutocomplete,
          child: AbsorbPointer(
            child: TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Delivery Address',
                hintText: 'Search for a location',
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_addressController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _addressController.clear();
                          setState(() {
                            _selectedLocation = null;
                          });
                        },
                      ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: 'Enter your phone number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            prefixIcon: Icon(Icons.phone), // Keep only the icon
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Allows only digits
            LengthLimitingTextInputFormatter(
                12), // Limits total length to 12 characters (including '254')
          ],
          onTap: () {
            if (_phoneController.text.isEmpty) {
              setState(() {
                _phoneController.text = '254';
                _phoneController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _phoneController.text.length),
                );
              });
            }
          },
          onChanged: (value) {
            if (!value.startsWith('254')) {
              setState(() {
                _phoneController.text = '254';
                _phoneController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _phoneController.text.length),
                );
              });
            } else if (value.length > 12) {
              setState(() {
                _phoneController.text = value.substring(0, 12);
                _phoneController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _phoneController.text.length),
                );
              });
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showCart: false),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState.cart.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDeliveryForm(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (_isAddressEmpty ||
                          _isPhoneEmpty ||
                          _selectedLocation == null)
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DeliveryLocationScreen(
                                totalAmount: cartState.cart.totalPrice,
                                location: _selectedLocation!,
                                phoneNumber:
                                    _phoneController.text, // Pass phone number
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Proceed to delivery'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
