import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/cart/presentation/widgets/cart_item_widget.dart';
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
  List<String> _addressPredictions = [];

  @override
  void initState() {
    super.initState();
    _addressController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _addressController.removeListener(_validateForm);
    _phoneController.removeListener(_validateForm);
    super.dispose();
  }

  // Validate form fields
  void _validateForm() {
    setState(() {
      _isAddressEmpty = _addressController.text.isEmpty;
      _isPhoneEmpty = _phoneController.text.isEmpty;
    });
  }

  // Fetch address predictions based on the input
  Future<void> _getAddressPredictions(String query) async {
    if (query.isNotEmpty) {
      try {
        // Fetch address predictions using geocoding package
        List<Location> locations = await locationFromAddress(query);
        setState(() {
          _addressPredictions = locations
              .map((location) =>
                  '${location.latitude}, ${location.longitude}') // You can map this to address or relevant details
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showCart: false),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState.cart.items.isEmpty) {
            return const Center(child: Text('You emptied your cart'));
          }

          final isDarkMode = Theme.of(context).brightness == Brightness.dark;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cart Items
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

                // Divider
                Divider(
                  color: isDarkMode
                      ? Colors.grey[200]
                      : AppColors.accentColor.withOpacity(.3),
                  thickness: 3,
                ),

                // Total Price
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

                // Delivery Info Section
                Text(
                  'Delivery Information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Delivery Address',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  onChanged: (value) {
                    // Fetch address predictions as the user types
                    _getAddressPredictions(value);
                  },
                ),
                // Show predictions
                if (_addressPredictions.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 100,
                    child: ListView.builder(
                      itemCount: _addressPredictions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_addressPredictions[index]),
                          onTap: () {
                            _addressController.text =
                                _addressPredictions[index];
                            setState(() {
                              _addressPredictions = [];
                            });
                          },
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 20),

                // Proceed Button
                ElevatedButton(
                  onPressed: (_isAddressEmpty || _isPhoneEmpty)
                      ? null
                      : () {
                          final address = _addressController.text;
                          final phoneNumber = _phoneController.text;

                          final totalAmount = cartState.cart.totalPrice;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DeliveryLocationScreen(
                                totalAmount: totalAmount,
                                address: address,
                                phoneNumber: phoneNumber,
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
