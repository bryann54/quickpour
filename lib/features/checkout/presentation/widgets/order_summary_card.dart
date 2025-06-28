import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/checkout/presentation/widgets/order_summary_row.dart';
import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  final String deliveryTime;
  final String deliveryType;
  final double totalAmount;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final bool showBreakdown;

  const OrderSummaryCard({
    Key? key,
    required this.deliveryTime,
    required this.deliveryType,
    required this.totalAmount,
    this.subtotal = 0.0,
    this.deliveryFee = 0.0,
    this.discount = 0.0,
    this.showBreakdown = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.shade300,
        ),
      ),
      color: isDark
          ? AppColors.background.withValues(alpha: .05)
          : Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, isDark),
            const SizedBox(height: 16),
            _buildDeliveryInfo(theme),
            if (subtotal > 0)
              if (showBreakdown) ...[
                const SizedBox(height: 16),
                _buildDivider(theme),
                const SizedBox(height: 12),
                _buildPriceBreakdown(theme),
              ],
            const SizedBox(height: 16),
            _buildDivider(theme),
            const SizedBox(height: 12),
            _buildTotalAmount(theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.receipt_long,
            size: 18,
            color: isDark
                ? AppColors.cardColor.withValues(alpha: .4)
                : AppColors.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Order Summary',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          SummaryRow(
            title: 'Delivery Time',
            value: deliveryTime,
            icon: Icons.access_time,
          ),
          const SizedBox(height: 8),
          SummaryRow(
            title: 'Delivery Type',
            value: deliveryType,
            icon: Icons.local_shipping_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      color: theme.dividerColor.withValues(alpha: .2),
      height: 1,
    );
  }

  Widget _buildPriceBreakdown(ThemeData theme) {
    return Column(
      children: [
        if (subtotal > 0)
          SummaryRow(
            title: 'Subtotal',
            value: 'KSh ${formatMoney(subtotal)}',
          ),
        if (deliveryFee > 0) ...[
          const SizedBox(height: 8),
          SummaryRow(
            title: 'Delivery Fee',
            value: 'KSh ${formatMoney(deliveryFee)}',
          ),
        ],
        if (discount > 0) ...[
          const SizedBox(height: 8),
          SummaryRow(
            title: 'Discount',
            value: '- KSh ${formatMoney(discount)}',
            valueColor: Colors.green,
          ),
        ],
      ],
    );
  }

  Widget _buildTotalAmount(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SummaryRow(
        title: 'Total Amount'.toUpperCase(),
        value: 'KSh ${formatMoney(totalAmount)}',
        isTotal: true,
        valueColor: isDark
            ? AppColors.cardColor.withValues(alpha: .4)
            : AppColors.primaryColor,
      ),
    );
  }
}
