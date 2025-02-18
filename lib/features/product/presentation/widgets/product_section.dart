import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:chupachap/features/product/presentation/widgets/product_shimmer_widget.dart';
import 'package:chupachap/features/promotions/presentation/widgets/promo_card.dart';
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
            _buildProductGrid(context, state),
          ],
        );
      },
    );
  }

  Widget _buildProductGrid(BuildContext context, ProductState state) {
    // Common grid delegate
    const gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.7,
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
    );

    if (state is ProductLoadingState) {
      return Stack(
        children: [
          if (state.cachedProducts != null)
            _buildCachedProductGrid(state.cachedProducts!, gridDelegate),
          if (state.cachedProducts == null) _buildShimmerGrid(gridDelegate),
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
            _buildCachedProductGrid(state.cachedProducts!, gridDelegate),
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
              state.errorMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state is ProductLoadedState) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        gridDelegate: gridDelegate,
        itemCount: state.products.length,
        itemBuilder: (context, index) => PromotionCard(
          product: state.products[index],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildShimmerGrid(
      SliverGridDelegateWithFixedCrossAxisCount gridDelegate) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: gridDelegate,
      itemCount: 6,
      itemBuilder: (_, __) => const ProductCardShimmer(),
    );
  }

  Widget _buildCachedProductGrid(
    List<ProductModel> products,
    SliverGridDelegateWithFixedCrossAxisCount gridDelegate,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: gridDelegate,
      itemCount: products.length,
      itemBuilder: (context, index) => Stack(
        children: [
          PromotionCard(product: products[index]),
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
