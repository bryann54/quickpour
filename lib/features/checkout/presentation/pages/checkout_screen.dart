import 'dart:async';

import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:chupachap/features/checkout/data/models/delivery_location.dart';
import 'package:chupachap/features/checkout/presentation/pages/delivery_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isAddressEmpty = true;
  bool _isPhoneEmpty = true;
  List<DeliveryLocation> _locationPredictions = [];
  DeliveryLocation? _selectedLocation;
  Timer? _debounce;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addressController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isAddressEmpty = _addressController.text.isEmpty;
      _isPhoneEmpty = _phoneController.text.isEmpty;
    });
  }

  Future<void> _getLocationPredictions(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          _locationPredictions = [];
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        List<Location> locations = await locationFromAddress(query);
        List<DeliveryLocation> predictions = [];

        for (var location in locations) {
          try {
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
          } catch (e) {
            debugPrint('Error getting place details: $e');
          }
        }

        if (mounted) {
          setState(() {
            _locationPredictions = predictions;
            _isLoading = false;
          });
        }
      } catch (e) {
        debugPrint('Error fetching locations: $e');
        if (mounted) {
          setState(() {
            _locationPredictions = [];
            _isLoading = false;
          });
        }
      }
    });
  }

  Widget _buildPredictionsList() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: _locationPredictions.isEmpty ? 0 : 200,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _locationPredictions.length,
              itemBuilder: (context, index) {
                final prediction = _locationPredictions[index];
                return ListTile(
                  title: Text(
                    prediction.mainText ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    prediction.secondaryText ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    setState(() {
                      _selectedLocation = prediction;
                      _addressController.text = prediction.address;
                      _locationPredictions = [];
                    });
                  },
                );
              },
            ),
    );
  }

  Widget _buildDeliveryForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Information',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        _buildPredictionsList(),
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Delivery Address',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            prefixIcon: const Icon(Icons.location_on),
            suffixIcon: _addressController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _addressController.clear();
                      setState(() {
                        _selectedLocation = null;
                        _locationPredictions = [];
                      });
                    },
                  )
                : null,
          ),
          onChanged: _getLocationPredictions,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            prefixIcon: Icon(Icons.phone),
          ),
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

          final isDarkMode = Theme.of(context).brightness == Brightness.dark;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Items in your cart',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartState.cart.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartState.cart.items[index];
                      return CartItemWidget(cartItem: cartItem);
                    },
                  ),
                ),
                Divider(
                  color: isDarkMode
                      ? Colors.grey[200]
                      : AppColors.accentColor.withOpacity(.3),
                  thickness: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'KSh ${cartState.cart.totalPrice.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.accentColor.withOpacity(.8),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                              
                                phoneNumber: _phoneController.text,
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
