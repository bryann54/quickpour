import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:chupachap/features/product/presentation/widgets/popular_product_card.dart';
import 'package:chupachap/features/product/presentation/widgets/product_shimmer_widget.dart';
import 'package:chupachap/features/product/presentation/widgets/recommended_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductSection extends StatelessWidget {
  const ProductSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recommended Products Section
            Text(
              'Recommended for you',
              style: GoogleFonts.montaga(
                fontSize: 20,
                textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            _buildRecommendedProductsRow(context, state),

            const SizedBox(height: 24),

            // Popular Now Section
            Text(
              'Popular Now',
              style: GoogleFonts.montaga(
                fontSize: 20,
                textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            _buildPopularProductsList(context, state),
          ],
        );
      },
    );
  }

  Widget _buildRecommendedProductsRow(
      BuildContext context, ProductState state) {
    if (state is ProductLoadingState) {
      return Stack(
        children: [
          if (state.cachedProducts != null)
            _buildCachedProductRow(state.cachedProducts!),
          if (state.cachedProducts == null) _buildShimmerRow(),
          if (state.cachedProducts != null)
            const Positioned(
              top: 10,
              right: 10,
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      );
    }

    if (state is ProductErrorState) {
      if (state.cachedProducts != null) {
        return Column(
          children: [
            _buildCachedProductRow(state.cachedProducts!),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                state.errorMessage,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      }
      return _buildErrorWidget(context, state.errorMessage);
    }

    if (state is ProductLoadedState) {
      return SizedBox(
        height: 230, // Adjust height as needed
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            return HorizontalPromotionCard(
              product: state.products[index],
              width: 160, // Adjust width as needed
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildPopularProductsList(BuildContext context, ProductState state) {
    if (state is ProductLoadingState) {
      return _buildPopularProductsShimmer();
    }

    if (state is ProductErrorState) {
      return _buildErrorWidget(context, state.errorMessage);
    }

    if (state is ProductLoadedState) {
      final popularProducts = state.products.take(10).toList();

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: popularProducts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: PopularProductCard(
              product: popularProducts[index],
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildPopularProductsShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: 3,
      itemBuilder: (_, __) => Container(
        height: 90,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Shimmer for image
            Container(
              width: 90,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            // Shimmer for content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 14,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 120,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 14,
                      width: 80,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerRow() {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: 5,
        itemBuilder: (_, __) => Container(
          width: 160,
          margin: const EdgeInsets.only(right: 12),
          child: const ProductCardShimmer(),
        ),
      ),
    );
  }

  Widget _buildCachedProductRow(List<ProductModel> products) {
    return SizedBox(
      height: 230, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Container(
            width: 160, // Adjust width as needed
            margin: const EdgeInsets.only(right: 12),
            child: Stack(
              children: [
                HorizontalPromotionCard(product: products[index]),
                Positioned.fill(
                  child: Container(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }

  Widget _buildErrorWidget(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}