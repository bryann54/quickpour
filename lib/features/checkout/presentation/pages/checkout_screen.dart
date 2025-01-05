import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:chupachap/features/checkout/presentation/pages/delivery_location.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          // Check if the cart is empty
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
                            color: AppColors.primaryColor,
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
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Delivery Address',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        )
                    ),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 10),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      )
                    ),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 20),

                // Proceed Button
                ElevatedButton(
                  onPressed: cartState.cart.items.isNotEmpty
                      ? () {
                          // Calculate total amount from cart items
                          double totalAmount = cartState.cart.items.fold(
                              0,
                              (total, item) =>
                                  total + (item.totalPrice * item.quantity));

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DeliveryLocationScreen(
                                      totalAmount: totalAmount)));
                        }
                      : null,
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
