// lib/features/checkout/presentation/widgets/order_summary_card.dart

import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  final String deliveryTime;
  final String deliveryType;
  final double totalAmount;

  const OrderSummaryCard({
    Key? key,
    required this.deliveryTime,
    required this.deliveryType,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            isDark ? AppColors.background.withOpacity(.1) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_outlined,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Order Summary',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SummaryRow(
            title: 'Delivery Time',
            value: deliveryTime,
          ),
          SummaryRow(
            title: 'Delivery Type',
            value: deliveryType,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              color: theme.dividerColor.withOpacity(.2),
            ),
          ),
          SummaryRow(
            title: 'Total Amount',
            value: 'KSh ${formatMoney(totalAmount)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const SummaryRow({
    Key? key,
    required this.title,
    required this.value,
    this.isTotal = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isTotal
                    ? (isDark
                        ? theme.colorScheme.primary
                        : AppColors.primaryColor)
                    : theme.textTheme.bodyLarge?.color,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
