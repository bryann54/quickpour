import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:flutter/material.dart';

class OrderTotalRow extends StatelessWidget {
  final CompletedOrder order;

  const OrderTotalRow({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.cardColorDark.withValues(alpha: 0.8)
            : AppColors.surface.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total'.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Text(
            'Ksh ${formatMoney(order.total)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.accentColorDark : AppColors.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
