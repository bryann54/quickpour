import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/features/product/presentation/pages/product_details_screen.dart';
import 'package:chupachap/features/product/presentation/widgets/favourite_FAB.dart';
import 'package:chupachap/features/product/presentation/widgets/cart_quantityFAB.dart';
import 'package:flutter/material.dart';

class HorizontalPromotionCard extends StatelessWidget {
  final ProductModel product;
  final double width;

  const HorizontalPromotionCard({
    super.key,
    required this.product,
    this.width = 160, // Default width for horizontal scrolling
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
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 8),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 1,
          shadowColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Full image background
              SizedBox(
                height: width * 1.2,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: product.imageUrls.isNotEmpty
                      ? product.imageUrls.first
                      : '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
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

              // Discount badge
              if (product.discountPrice > 0 &&
                  product.discountPrice < product.price)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Hero(
                    tag: 'product-badge-${product.id}',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.red, Colors.orange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${calculateDiscountPercentage(product.price, product.discountPrice)}% OFF',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

              // Product details overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Hero(
                        tag: 'product-name-${product.id}',
                        child: Text(
                          product.productName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 2),

                      // Category + Measure
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              product.categoryName,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Hero(
                            tag: 'product-measure-${product.id}',
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                product.measure,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Price
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            if (product.discountPrice > 0 &&
                                product.discountPrice < product.price) ...[
                              Text(
                                'Ksh ${formatMoney(product.discountPrice)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Ksh ${formatMoney(product.price)}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.redAccent,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ] else
                              Text(
                                'Ksh ${formatMoney(product.price)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
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

              // Favorite FAB
              Positioned(
                top: 4,
                right: 4,
                child: FavoriteFAB(
                  product: product,
                  isDarkMode: isDarkMode,
                ),
              ),

              // Cart Quantity FAB
              Positioned(
                bottom: 4,
                right: 4,
                child: CartQuantityFAB(
                  product: product,
                  isDarkMode: isDarkMode,
                  smallSize: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
