import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/features/product/presentation/pages/product_details_screen.dart';
import 'package:chupachap/features/product/presentation/widgets/favourite_FAB.dart';
import 'package:chupachap/features/product/presentation/widgets/cart_quantityFAB.dart';
import 'package:flutter/material.dart';

class PromotionCard extends StatelessWidget {
  final ProductModel product;

  const PromotionCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              product: product,
              initialQuantity: 1,
              onQuantityChanged: (quantity) {},
            ),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        shadowColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section with Discount Tag
                    SizedBox(
                      height: constraints.maxWidth * 0.8, // Responsive height
                      child: Stack(
                        children: [
                          Hero(
                            tag: 'product-image-${product.id}',
                            child: CachedNetworkImage(
                              imageUrl: product.imageUrls.isNotEmpty
                                  ? product.imageUrls.first
                                  : '',
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                              errorWidget: (context, url, error) => Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade100,
                                child: Icon(
                                  Icons.error,
                                  color: isDarkMode
                                      ? Colors.grey.shade500
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                          if (product.discountPrice > 0 &&
                              product.discountPrice < product.price)
                            Positioned(
                              top: 0,
                              left: 2,
                              child: Hero(
                                tag: 'product-badge-${product.id}',
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.red, Colors.orange],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 4,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 4),
                                      Text(
                                        '${calculateDiscountPercentage(product.price, product.discountPrice)}% OFF',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Product Information Section
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Hero(
                              tag: 'product-name-${product.id}',
                              child: Text(
                                product.productName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    product.categoryName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                                Hero(
                                  tag: 'product-measure-${product.id}',
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isDarkMode
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      product.measure,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode
                                            ? Colors.white54
                                            : Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            // Price Section
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (product.discountPrice > 0 &&
                                      product.discountPrice <
                                          product.price) ...[
                                    Text(
                                      'Ksh ${formatMoney(product.discountPrice)}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.accentColor,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'was',
                                      style: TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Ksh ${formatMoney(product.price)}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.red,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ] else
                                    Text(
                                      'Ksh ${formatMoney(product.price)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.accentColor,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 2,
                  child: FavoriteFAB(
                    product: product,
                    isDarkMode: isDarkMode,
                  ),
                ),
                // Cart FAB
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: CartQuantityFAB(
                    product: product,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
