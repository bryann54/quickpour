// widgets/order_id_date_row.dart
import 'dart:math';

import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/presentation/widgets/order_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderIdDateRow extends StatelessWidget {
  final CompletedOrder order;

  const OrderIdDateRow({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
Color _getStatusColor(OrderStatus status) {
      switch (status) {
        case OrderStatus.canceled:
          return const Color.fromARGB(255, 15, 5, 68);
        case OrderStatus.received:
          return const Color(0xFFF39C12);
        case OrderStatus.processing:
          return const Color(0xFF3498DB);
        case OrderStatus.dispatched:
          return const Color(0xFF9B59B6);
        case OrderStatus.delivered:
          return const Color(0xFF1ABC9C);
        case OrderStatus.completed:
          return const Color(0xFF2ECC71);
        default:
          return Colors.grey;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColors.brandAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '#${order.id.substring(0, min(8, order.id.length))}',
              style: const TextStyle(
                color: AppColors.brandAccent,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          DateFormat('MMM dd, yyyy').format(order.date),
          style: TextStyle(
            color:
                isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  
}
