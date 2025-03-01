import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/presentation/widgets/merchant_order_section.dart';
import 'package:chupachap/features/orders/presentation/widgets/section_widget.dart';
import 'package:chupachap/features/orders/presentation/widgets/widgets/order_total_row.dart';
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
          const SectionTitle(title: 'Items'),
          if (order.merchantOrders.isNotEmpty) ...[
            ...order.merchantOrders.map((merchantOrder) =>
                MerchantOrderSection(merchantOrder: merchantOrder, order: order,)),
          ],
          OrderTotalRow(order: order),
        ],
      ),
    );
  }
}
