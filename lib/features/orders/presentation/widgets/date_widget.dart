// widgets/order_id_date_row.dart
import 'dart:math';

import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderIdDateRow extends StatelessWidget {
  final CompletedOrder order;

  const OrderIdDateRow({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
