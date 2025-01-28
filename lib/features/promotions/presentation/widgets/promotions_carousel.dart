import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/promotions/presentation/bloc/promotions_bloc.dart';
import 'package:chupachap/features/promotions/presentation/bloc/promotions_state.dart';
import 'package:chupachap/features/promotions/presentation/pages/promotion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:shimmer/shimmer.dart';

class PromotionsCarousel extends StatelessWidget {
  const PromotionsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return BlocBuilder<PromotionsBloc, PromotionsState>(
      builder: (context, state) {
        if (state is PromotionsLoading) {
          return  Center(child: Shimmer.fromColors(
             baseColor: isDarkMode ? Colors.grey[400]! : Colors.grey[400]!,
            highlightColor: Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Container(
                height: 190,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[500],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ));
        } else if (state is PromotionsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is PromotionsLoaded) {
          return _buildCarousel(context, state.products);
        } else {
          return const Center(child: Text('No promotions available.'));
        }
      },
    );
  }

  Widget _buildCarousel(BuildContext context, List<ProductModel> products) {
    final theme = Theme.of(context);

    // Filter products with valid discounts
    final discountedProducts = products.where((product) {
      return product.discountPrice > 0 && product.discountPrice < product.price;
    }).toList();

    if (discountedProducts.isEmpty) {
      return const Center(child: Text('No promotions available.'));
    }

    // Sort products by discount percentage
    discountedProducts.sort((a, b) {
      double discountA = ((a.price - a.discountPrice) / a.price);
      double discountB = ((b.price - b.discountPrice) / b.price);
      return discountB.compareTo(discountA);
    });

    // Select top 5 discounted products
    final topDiscountedProducts = discountedProducts.take(5).toList();

    return CarouselSlider(
      items: topDiscountedProducts.map((product) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PromotionScreen(promotions: discountedProducts),
            ),
          ),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  // Background Image
                  CachedNetworkImage(
                    imageUrl: product.imageUrls.isNotEmpty
                        ? product.imageUrls.first
                        : '',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator.adaptive()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),

                  // Gradient Overlay
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Discount Badge
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.red, Colors.orangeAccent],
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
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_offer_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_calculateDiscountPercentage(product.price, product.discountPrice)}% Off',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Product Details
                  Positioned(
                    bottom: 15,
                    left: 15,
                    right: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.productName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Ksh ${product.discountPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accentColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Ksh ${product.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 190.0,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        viewportFraction: 0.8,
      ),
    );
  }
}

int _calculateDiscountPercentage(double originalPrice, double discountPrice) {
  if (originalPrice <= 0 || discountPrice <= 0) {
    return 0; // Handle invalid values gracefully
  }
  final discount = ((originalPrice - discountPrice) / originalPrice) * 100;
  return discount.round(); // Return rounded discount percentage
}
