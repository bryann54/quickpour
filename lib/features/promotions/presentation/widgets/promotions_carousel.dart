import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/promotions/presentation/bloc/promotions_bloc.dart';
import 'package:chupachap/features/promotions/presentation/bloc/promotions_state.dart';
import 'package:chupachap/features/promotions/presentation/pages/promotion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';

class PromotionsCarousel extends StatelessWidget {
  const PromotionsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromotionsBloc, PromotionsState>(
      builder: (context, state) {
        if (state is PromotionsLoading) {
          return const Center(child: CircularProgressIndicator());
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
    if (products.isEmpty) {
      return const Center(child: Text('No promotions available.'));
    }

    // Sort products by highest discount percentage
    final sortedProducts = List<ProductModel>.from(products)
      ..sort((a, b) {
        double discountA = ((a.price - a.discountPrice) / a.price);
        double discountB = ((b.price - b.discountPrice) / b.price);
        return discountB.compareTo(discountA);
      });

    final topDiscountedProducts = sortedProducts.take(5).toList();

    return Column(
      children: [
        CarouselSlider(
          items: topDiscountedProducts.map((product) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PromotionScreen(
                              promotions: sortedProducts,
                            ),
                          ),
                        ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          // Image container with shadow
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // Shadow color
                                  blurRadius: 5, // Spread of the shadow
                                  offset: const Offset(
                                      4, 4), // Position of the shadow
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: product.imageUrls.isNotEmpty
                                    ? product.imageUrls.first
                                    : 'assets/111.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 170,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
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
                                  // borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                  border:
                                      Border.all(color: Colors.white, width: 1),
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
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                          Positioned(
                            bottom: 10,
                            left: 10,
                            right: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product name with shadow effect
                                Text(
                                  product.productName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        blurRadius:1,
                                        color: Colors.black,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                                // Price with shadow effect and discounted price in Ksh
                                Text(
                                  'Ksh ${product.discountPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.accentColor,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.white,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                                // Original price with strike-through
                                Text(
                                  'Was Ksh ${product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red,
                                    decoration: TextDecoration.lineThrough,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0,
                                        color: Colors.white,
                                        offset: Offset(2.0, 2.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            );
          }).toList(),
          options: CarouselOptions(
            height: 170.0,
            autoPlay: true,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
          ),
        ),
        // Optional: Add a "View All" button
    
      ],
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
