// cart_total_section.dart
import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/checkout/presentation/pages/checkout_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CartTotalSection extends StatelessWidget {
  final Cart cart;
  final bool isDarkMode;
  final bool isClearing;
  final AnimationController clearCartController;

  const CartTotalSection({
    super.key,
    required this.cart,
    required this.isDarkMode,
    required this.isClearing,
    required this.clearCartController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0,
      horizontal: 10.0),
      child: Column(
        children: [
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Total',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'KSh ${cart.totalPrice.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isDarkMode
                              ? AppColors.surface.withOpacity(.7)
                              : AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ElevatedButton(
                    onPressed: cart.items.isNotEmpty && !isClearing
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CheckoutScreen(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Checkout'),
                  ),
                ),
              ),
            ],
          ),
           const SizedBox(height: 15),
        ],
      )  .animate()
                  .fade(duration: const Duration(seconds: 1))
                  .slideX(curve: Curves.easeInOut),
    );
  }
}
