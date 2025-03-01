// widgets/order_header.dart
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/presentation/widgets/animated_order_progress.dart';
import 'package:chupachap/features/orders/presentation/widgets/date_widget.dart';
import 'package:flutter/material.dart';

class OrderHeader extends StatelessWidget {
  final CompletedOrder order;

  const OrderHeader({super.key, required this.order});

  OrderStatus _getOrderStatus(String status) {
    return OrderStatus.values.firstWhere(
      (s) => s.toString().split('.').last == status.toLowerCase(),
      orElse: () => OrderStatus.received,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final status = _getOrderStatus(order.status);
   
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDark ? AppColors.cardColorDark : AppColors.surface,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order status:',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AnimatedOrderProgress(
              currentStatus: status,
            ),
            const SizedBox(height: 16),
            Hero(
              tag: 'order-id-${order.id}',
              child: Material(
                color: Colors.transparent,
                child: OrderIdDateRow(order: order),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
