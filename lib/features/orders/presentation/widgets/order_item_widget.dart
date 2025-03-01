import 'dart:math';
import 'package:chupachap/core/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/presentation/pages/order_details.dart';

class OrderItemWidget extends StatelessWidget {
  final CompletedOrder order;
  const OrderItemWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = OrderStatus.values.firstWhere(
      (s) => s.toString().split('.').last == order.status.toLowerCase(),
      orElse: () => OrderStatus.received,
    );
    final statusColor = OrderStatusUtils.getStatusColor(status);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetails(order: order),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.light
                  ? AppColors.surface
                  : AppColors.cardColorDark,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.brightness == Brightness.light
                      ? AppColors.shadowColor
                      : AppColors.shadowColorDark,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, status, statusColor),
                _buildDeliveryInfo(context),
                _buildTotal(context),
              ],
            ),
          ),
          if (order.status == 'canceled')
            Positioned(
              top: 100,
              right: 115,
              child: Image.asset(
                'assets/ca1.webp',
                fit: BoxFit.cover,
                width: 180,
                height: 180,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, OrderStatus status, Color statusColor) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Hero(
              tag: 'order-id-${order.id}',
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '#${order.id.substring(0, min(8, order.id.length))}',
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Hero(
                tag: 'order-date-${order.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(order.date),
                    style: TextStyle(
                      color: theme.brightness == Brightness.light
                          ? AppColors.textSecondary
                          : AppColors.textSecondaryDark,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      OrderStatusUtils.getStatusLabel(status),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(
        horizontal: 2,
      ),
      color: isDark ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.dividerColorDark : AppColors.dividerColor,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Delivery Type Section
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.background.withOpacity(0.1)
                        : AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    getDeliveryIcon(order.deliveryType),
                    size: 15,
                    color:
                        isDark ? AppColors.background : AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delivery Type',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        getDeliveryText(order.deliveryType),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Divider(
              height: 1,
              thickness: 0.5,
              color:
                  isDark ? AppColors.dividerColorDark : AppColors.dividerColor,
            ),
          ),

          // Delivery Address Section
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.background.withOpacity(0.1)
                        : AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color:
                        isDark ? AppColors.background : AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Delivery Address',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          order.address,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotal(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      color: isDark ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.dividerColorDark : AppColors.dividerColor,
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Hero(
          tag: 'order-total-${order.id}',
          child: Material(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ORDER TOTAL',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.textSecondary.withOpacity(0.6)
                        : AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'KSh ${formatMoney(order.total)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.background.withOpacity(.5)
                          : AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
