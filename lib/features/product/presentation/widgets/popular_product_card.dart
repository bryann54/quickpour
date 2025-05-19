import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/features/product/presentation/pages/product_details_screen.dart';
import 'package:chupachap/features/product/presentation/widgets/favourite_FAB.dart';
import 'package:chupachap/features/product/presentation/widgets/cart_quantityFAB.dart';
import 'package:flutter/material.dart';

class PopularProductCard extends StatelessWidget {
  final ProductModel product;
  final double height;

  const PopularProductCard({
    super.key,
    required this.product,
    this.height = 90,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Extract common styles to avoid repetition
    final errorColor = isDarkMode ? Colors.grey.shade500 : Colors.grey.shade700;
    final errorBgColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;
    final categoryTextColor = isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;
    final measureBgColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100;
    final measureBorderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
    final measureTextColor = isDarkMode ? Colors.white70 : Colors.grey.shade700;
    
    // Prepare product hero tags to ensure consistency
    final imageHeroTag = 'popular-image-${product.id}';
    final nameHeroTag = 'popular-name-${product.id}';
    
    return GestureDetector(
          onTap: () => _navigateToDetails(context),
          child: Container(
            height: height,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    // Product image with hero animation
                    _buildProductImage(imageHeroTag, errorBgColor, errorColor),
                    
                    // Product details section
                    _buildProductDetails(
                      context, 
                      nameHeroTag,
                      categoryTextColor,
                      measureBgColor,
                      measureBorderColor,
                      measureTextColor,
                    ),
                  ],
                ),

                // Discount badge if product is on sale
                if (_isOnSale())
                  _buildDiscountBadge(),

                // Favorite button
                Positioned(
                  top: 0,
                  right: 0,
                  child: FavoriteFAB(
                    product: product,
                    isDarkMode: isDarkMode,
                    smallSize: true, 
                  ),
                ),

                // Add to cart button
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CartQuantityFAB(
                    product: product,
                    isDarkMode: isDarkMode,
                    smallSize: true,
                  ),
                ),
              ],
            ),
          ),
        );
  }

  // Navigate to product details screen
  void _navigateToDetails(BuildContext context) {
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
  }

  // Check if product is on sale
  bool _isOnSale() {
    return product.discountPrice > 0 && product.discountPrice < product.price;
  }

  // Build the product image section
  Widget _buildProductImage(String heroTag, Color errorBgColor, Color errorColor) {
    return Hero(
      tag: heroTag,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
        child: CachedNetworkImage(
          imageUrl: product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
          width: 90,
          height: height,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => Container(
            width: 90,
            height: height,
            color: errorBgColor,
            child: Icon(
              Icons.error_outline,
              size: 24,
              color: errorColor,
            ),
          ),
        ),
      ),
    );
  }

  // Build the product details section
  Widget _buildProductDetails(
    BuildContext context,
    String nameHeroTag,
    Color categoryTextColor,
    Color measureBgColor,
    Color measureBorderColor,
    Color measureTextColor,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Product Name with hero animation
            Hero(
              tag: nameHeroTag,
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  product.productName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            const SizedBox(height: 2),

            // Category and measure
            _buildCategoryAndMeasure(
              categoryTextColor,
              measureBgColor,
              measureBorderColor,
              measureTextColor,
            ),

            const SizedBox(height: 4),

            // Price section
            _buildPriceSection(),
          ],
        ),
      ),
    );
  }

  // Build category and measure row
  Widget _buildCategoryAndMeasure(
    Color categoryTextColor,
    Color measureBgColor,
    Color measureBorderColor,
    Color measureTextColor,
  ) {
    return Row(
      children: [
        Flexible(
          child: Text(
            product.categoryName,
            style: TextStyle(
              fontSize: 12,
              color: categoryTextColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            color: measureBgColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: measureBorderColor,
              width: 0.5,
            ),
          ),
          child: Text(
            product.measure,
            style: TextStyle(
              fontSize: 10,
              color: measureTextColor,
            ),
          ),
        ),
      ],
    );
  }

  // Build price section
  Widget _buildPriceSection() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (_isOnSale()) ...[
            Text(
              'Ksh ${formatMoney(product.discountPrice)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.accentColor,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              'was',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'Ksh ${formatMoney(product.price)}',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.red,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ] else
            Text(
              'Ksh ${formatMoney(product.price)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.accentColor,
              ),
            ),
        ],
      ),
    );
  }

  // Build discount badge
  Widget _buildDiscountBadge() {
    return Positioned(
      top: 0,
      left: 90,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 2,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(8),
          ),
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
    );
  }
}