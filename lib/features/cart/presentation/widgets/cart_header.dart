// cart_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:chupachap/core/utils/colors.dart';

class CartHeader extends StatelessWidget {
  final bool isDarkMode;
  final bool isClearing;
  final VoidCallback onClearCart;

  const CartHeader({
    super.key,
    required this.isDarkMode,
    required this.isClearing,
    required this.onClearCart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Your cart',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: isDarkMode
                      ? AppColors.cardColor
                      : AppColors.accentColorDark,
                ),
          ),
          GestureDetector(
            onTap: isClearing ? null : onClearCart,
            child: Text(
              'Clear cart',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isDarkMode ? AppColors.cardColor : Colors.black,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1);
  }
}
