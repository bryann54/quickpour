import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/date_formatter.dart';
import 'package:chupachap/features/orders/data/models/merchant_order_item_model.dart';
import 'package:chupachap/features/orders/presentation/widgets/order_item_row.dart';
import 'package:flutter/material.dart';

class MerchantOrderSection extends StatelessWidget {
  final MerchantOrderItem merchantOrder;

  const MerchantOrderSection({super.key, required this.merchantOrder});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Merchant header
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              if (merchantOrder.merchantImageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    merchantOrder.merchantImageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey[300],
                      child: const Icon(Icons.store, color: Colors.grey),
                    ),
                  ),
                )
              else
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.store, color: Colors.grey),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  merchantOrder.merchantName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        // Item list
        ...merchantOrder.items.map((item) => OrderItemRow(item: item)),
        // Merchant subtotal
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Subtotal:',
                style: TextStyle(
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Text(
               'Ksh ${formatMoney(merchantOrder.subtotal)}',
                style: TextStyle(
                  color: isDark
                      ? AppColors.accentColorDark
                      : AppColors.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
