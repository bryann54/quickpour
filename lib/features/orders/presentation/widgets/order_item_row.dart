import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/date_formatter.dart';
import 'package:chupachap/features/orders/data/models/order_model.dart';
import 'package:chupachap/features/orders/presentation/widgets/quantity_badge_widget.dart';
import 'package:flutter/material.dart';

class OrderItemRow extends StatelessWidget {
  final OrderItem item;

  const OrderItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          if (item.images.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.images.first,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[300],
                  child:
                      const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            )
          else
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          const SizedBox(width: 12),
          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ksh ${formatMoney(item.price)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.accentColorDark
                            : AppColors.accentColor,
                      ),
                    ),
                    QuantityBadge(quantity: item.quantity),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
