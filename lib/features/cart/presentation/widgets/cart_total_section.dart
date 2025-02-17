// cart_total_section.dart
import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/checkout/presentation/pages/checkout_screen.dart';

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
    return FadeTransition(
      opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
          parent: clearCartController,
          curve: Curves.easeOut,
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, 0.5),
        ).animate(
          CurvedAnimation(
            parent: clearCartController,
            curve: Curves.easeOut,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: cart.items.isNotEmpty && !isClearing
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CheckoutScreen(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Proceed to Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
