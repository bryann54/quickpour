// widgets/customer_details_section.dart
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/presentation/widgets/card_widget.dart';
import 'package:chupachap/features/orders/presentation/widgets/info_widget.dart';
import 'package:chupachap/features/orders/presentation/widgets/section_widget.dart';
import 'package:flutter/material.dart';

class CustomerDetailsSection extends StatelessWidget {
  final CompletedOrder order;

  const CustomerDetailsSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Customer Details'),
          InfoRow(label: 'Name', value: order.userName),
          InfoRow(label: 'Email', value: order.userEmail),
          InfoRow(
            label: 'Phone Number',
            value: order.phoneNumber,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class DeliveryTimeBadge extends StatelessWidget {
  final String deliveryTime;

  const DeliveryTimeBadge({super.key, required this.deliveryTime});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceColorDark : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time,
            size: 16,
            color:
                isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            deliveryTime,
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentMethodBadge extends StatelessWidget {
  final String paymentMethod;

  const PaymentMethodBadge({super.key, required this.paymentMethod});

  IconData _getPaymentIcon(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Icons.money;
      case 'card':
        return Icons.credit_card;
      case 'mpesa':
        return Icons.phone_android;
      default:
        return Icons.payment;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceColorDark : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getPaymentIcon(paymentMethod),
            size: 16,
            color:
                isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            paymentMethod,
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
