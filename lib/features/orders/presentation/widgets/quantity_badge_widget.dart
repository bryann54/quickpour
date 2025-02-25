// widgets/quantity_badge.dart
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/date_formatter.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
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

// widgets/order_total_row.dart
class OrderTotalRow extends StatelessWidget {
  final CompletedOrder order;

  const OrderTotalRow({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceColorDark : Colors.grey[50],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Total Amount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color:
                    isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
          ),
          Hero(
            tag: 'total-amount-${order.id}',
            child: Material(
              color: Colors.transparent,
              child: Text(
                'KSh ${formatMoney(order.total)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.brandAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
