// widgets/order_items_section.dart
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/presentation/widgets/order_item_row.dart';
import 'package:chupachap/features/orders/presentation/widgets/quantity_badge_widget.dart';
import 'package:chupachap/features/orders/presentation/widgets/section_widget.dart';
import 'package:flutter/material.dart';

class OrderItemsSection extends StatelessWidget {
  final CompletedOrder order;

  const OrderItemsSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardColorDark : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowColorDark : AppColors.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (order.items.isNotEmpty) ...[
            const SectionTitle(title: 'Items'),
            ...order.items.map((item) => OrderItemRow(item: item)),
            OrderTotalRow(order: order),
          ],
        ],
      ),
    );
  }
}
