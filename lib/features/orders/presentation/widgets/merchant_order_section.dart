import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/merchant/data/models/merchants_model.dart';
import 'package:chupachap/features/merchant/presentation/pages/merchant_details_screen.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/data/models/merchant_order_item_model.dart';
import 'package:chupachap/features/orders/presentation/widgets/order_item_row.dart';
import 'package:flutter/material.dart';

class MerchantOrderSection extends StatelessWidget {
  final MerchantOrderItem merchantOrder;
  final CompletedOrder order;

  const MerchantOrderSection(
      {super.key, required this.merchantOrder, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.cardColorDark.withValues(alpha: 0.5)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Merchant header (now tappable)
              GestureDetector(
                onTap: () {
                  // Navigate to MerchantDetailsScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MerchantDetailsScreen(
                        merchant: Merchants(
                            id: merchantOrder.merchantId,
                            location: merchantOrder.merchantLocation,
                            imageUrl: merchantOrder.merchantImageUrl,
                            isVerified: merchantOrder.isMerchantVerified,
                            name: merchantOrder.merchantName,
                            products: merchantOrder.items
                                .map((e) => e.productName)
                                .toList(),
                            rating: merchantOrder.merchantRating,
                            isOpen: merchantOrder.isMerchantOpen,
                            experience: 0),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.grey[50],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      _buildMerchantImage(context),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              merchantOrder.merchantStoreName.isNotEmpty
                                  ? merchantOrder.merchantStoreName
                                  : 'Unknown Store',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary,
                              ),
                            ),
                            if (merchantOrder.merchantLocation.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                merchantOrder.merchantLocation,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      _buildMerchantStatus(),
                    ],
                  ),
                ),
              ),

              // Items list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: merchantOrder.items.length,
                separatorBuilder: (context, index) => const Divider(height: 16),
                itemBuilder: (context, index) => OrderItemRow(
                  item: merchantOrder.items[index],
                ),
              ),

              // Merchant subtotal
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.grey[50],
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Merchant Subtotal',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Ksh ${formatMoney(merchantOrder.subtotal)}',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.accentColorDark
                            : AppColors.accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (order.status == 'canceled')
          Positioned(
            top: 10,
            right: 20,
            child: Hero(
              tag: 'cancel-button',
              child: Image.asset(
                'assets/ca1.webp',
                fit: BoxFit.cover,
                width: 90,
                height: 90,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMerchantImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MerchantDetailsScreen(
              merchant: Merchants(
                  id: merchantOrder.merchantId,
                  location: merchantOrder.merchantLocation,
                  imageUrl: merchantOrder.merchantImageUrl,
                  isVerified: merchantOrder.isMerchantVerified,
                  name: merchantOrder.merchantName,
                  products:
                      merchantOrder.items.map((e) => e.productName).toList(),
                  rating: merchantOrder.merchantRating,
                  isOpen: merchantOrder.isMerchantOpen,
                  experience: 0),
            ),
          ),
        );
      },
      child: Hero(
        tag: 'merchant_image_${merchantOrder.merchantId}',
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: merchantOrder.merchantImageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: merchantOrder.merchantImageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.store, color: Colors.grey, size: 24),
                  )
                : const Icon(Icons.store, color: Colors.grey, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildMerchantStatus() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (merchantOrder.isMerchantVerified)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.verified, size: 16, color: Colors.green[700]),
                const SizedBox(width: 4),
                Text(
                  'Verified',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
