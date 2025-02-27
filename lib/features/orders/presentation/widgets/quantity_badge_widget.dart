// widgets/quantity_badge.dart
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:flutter/material.dart';

class QuantityBadge extends StatelessWidget {
  final int quantity;

  const QuantityBadge({super.key, required this.quantity});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceColorDark : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${quantity}x',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ),
    );
  }
}

// widgets/item_price.dart
class ItemPrice extends StatelessWidget {
  final double price;

  const ItemPrice({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      'KSh ${formatMoney(price)}',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        fontSize: 16,
      ),
    );
  }
}
