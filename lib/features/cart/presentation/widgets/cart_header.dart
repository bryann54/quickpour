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
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Your cart',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode
                      ? AppColors.cardColor
                      : AppColors.accentColorDark,
                ),
          ),
          GestureDetector(
            onTap: isClearing ? null : onClearCart,
            child: Text(
              'Clear cart',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
