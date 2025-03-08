import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:flutter/material.dart';

class AddItemSection extends StatelessWidget {
  final Cart cart;
  final VoidCallback onAddItemPressed;
  final double freeDeliveryThreshold;
  final AuthRepository authRepository;

  const AddItemSection({
    super.key,
    required this.cart,
    required this.onAddItemPressed,
    this.freeDeliveryThreshold = 5000,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final currentTotal = cart.totalPrice;
    final remaining = freeDeliveryThreshold - currentTotal > 0
        ? freeDeliveryThreshold - currentTotal
        : 0;

    // Highlight colors
    final highlightColor = isDarkMode ? Colors.white : Colors.black87;

    return Container(
      margin: const EdgeInsets.symmetric(vertical:5, horizontal: 5),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.cardColorDark
            : Colors.cyan.withOpacity(.055),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5,),
        title: remaining > 0
            ? Text(
                'Free Delivery',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: highlightColor,
                ),
              )
            : null,
        subtitle: remaining > 0
            ? RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: isDarkMode
                        ? Colors.blueGrey.shade400
                        : Colors.grey.shade700,
                    fontSize: 12,
                  ),
                  children: [
                    const TextSpan(text: 'Spend an extra '),
                    TextSpan(
                      text: 'KSh ${formatMoney(remaining)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: highlightColor,
                      ),
                    ),
                    const TextSpan(text: ' to get '),
                    TextSpan(
                      text: 'free delivery!!'.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: highlightColor,
                      ),
                    ),
                  ],
                ),
              )
            : 
            Text(
                'You qualify for free delivery!',
                style: TextStyle(
                  color: highlightColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
        trailing: remaining > 0
            ? GestureDetector(
                onTap: onAddItemPressed,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.background.withOpacity(0.7)
                          : Theme.of(context).primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Add drinks',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? AppColors.background.withOpacity(0.9)
                          : Theme.of(context).primaryColor,
                      fontSize: 13,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
