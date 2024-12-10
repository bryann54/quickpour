
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_event.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:chupachap/features/product/presentation/widgets/product_card.dart';
import 'package:chupachap/features/product/presentation/widgets/product_shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        productRepository: ProductRepository(),
      )..add(FetchProductsEvent()),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: CustomSearchBar(
            //     onSearch: (query) {
            //       print('Searching for: $query');
            //     },
            //     onFilterTap: () {
            //       print('Filter tapped');
            //     },
            //   ),
            // ),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoadingState) {
                    // Show shimmer effect while loading
                    return _buildLoadingGrid();
                  } else if (state is ProductErrorState) {
                    // Show error message
                    return _buildErrorView(state.errorMessage);
                  } else if (state is ProductLoadedState) {
                    // Show product grid when loaded
                    return _buildProductGrid(state);
                  }

                  // Handle any other state gracefully
                  return const Center(
                    child: Text('No products available'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a loading grid with shimmer effects.
  Widget _buildLoadingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }

  /// Builds a grid to display products.
  Widget _buildProductGrid(ProductLoadedState state) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: state.products.length,
      itemBuilder: (context, index) {
        final product = state.products[index];
        return ProductCard(product: product);
      },
    );
  }

  /// Builds a view to display error messages.
  Widget _buildErrorView(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class CustomSearchBar {
}
