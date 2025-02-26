import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/date_formatter.dart';
import 'package:chupachap/features/promotions/data/models/promotion_model.dart';
import 'package:chupachap/features/promotions/presentation/bloc/promotions_bloc.dart';
import 'package:chupachap/features/promotions/presentation/bloc/promotions_state.dart';
import 'package:chupachap/features/promotions/presentation/pages/promo_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
          return _buildShimmerLoading(isDarkMode);
        } else if (state is PromotionsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is PromotionsLoaded) {
          final promotions = state.promotions;
          if (promotions.isEmpty) {
            return const Center(child: Text('No promotions available.'));
          }
          return _buildCarousel(context, promotions);
        } else {
          return const Center(child: Text('No promotions available.'));
        }
      },
    );
  }

  Widget _buildShimmerLoading(bool isDarkMode) {
    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[600]! : Colors.grey[100]!,
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
    );
  }

  Widget _buildCarousel(BuildContext context, List<PromotionModel> promotions) {
    final theme = Theme.of(context);

    // Sort promotions by discount percentage (highest first)
    promotions
        .sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));

    // Select top 5 promotions (or all if less than 5)
    final displayPromotions =
        promotions.length > 5 ? promotions.take(5).toList() : promotions;

    return CarouselSlider(
      items: displayPromotions.map((promotion) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PromoDetailsScreen(promotion: promotion),
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
                  promotion.imageUrl != null && promotion.imageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: promotion.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator.adaptive()),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child:
                                const Icon(Icons.image_not_supported, size: 40),
                          ),
                        )
                      : Container(
                          color: theme.primaryColor.withOpacity(0.2),
                          child: const Center(
                            child: Icon(Icons.local_offer, size: 40),
                          ),
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
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                        ),
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
                            '${promotion.discountPercentage.toStringAsFixed(0)}% OFF',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Promotion Details
                  Positioned(
                    bottom: 15,
                    left: 15,
                    right: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          promotion.campaignTitle,
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
                              _getPromotionTypeDisplay(promotion),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _getValidityPeriod(promotion),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
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
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  String _getPromotionTypeDisplay(PromotionModel promotion) {
    switch (promotion.promotionTarget) {
      case PromotionTarget.products:
        return 'Product Discount';
      case PromotionTarget.categories:
        return 'Category Discount';
      case PromotionTarget.brands:
        return 'Brand Discount';
      default:
        return promotion.promotionType;
    }
  }

  String _getValidityPeriod(PromotionModel promotion) {
    return 'Valid until ${formatDate(promotion.endDate)}';
  }
}
