import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_event.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:chupachap/features/product/presentation/widgets/product_shimmer_widget.dart';
import 'package:chupachap/features/product/presentation/widgets/promo_card.dart';

class ProductListWidget extends StatelessWidget {
  const ProductListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (_isInitialLoading(state)) {
          return _buildShimmerGrid();
        }

        if (state is ProductErrorState) {
          return _buildErrorView(context, state);
        }

        if (state is ProductLoadedState) {
          return _buildProductGrid(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  bool _isInitialLoading(ProductState state) {
    return state is ProductLoadingState && state is! ProductLoadedState;
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const ProductCardShimmer(),
    );
  }

  Widget _buildErrorView(BuildContext context, ProductErrorState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60),
          const SizedBox(height: 16),
          Text(
            state.errorMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ProductBloc>().add(FetchProductsEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, ProductLoadedState state) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (_shouldLoadMore(scrollInfo, state)) {
          context.read<ProductBloc>().add(LoadMoreProductsEvent());
          return true;
        }
        return false;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _calculateItemCount(state),
        itemBuilder: (context, index) => _buildGridItem(state, index),
      ),
    );
  }

  bool _shouldLoadMore(
      ScrollNotification scrollInfo, ProductLoadedState state) {
    return scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent * 0.9 &&
        state.hasMoreData &&
        state is! LoadMoreProductsEvent;
  }

  int _calculateItemCount(ProductLoadedState state) {
    return state.products.length + (state.hasMoreData ? 2 : 0);
  }

  Widget _buildGridItem(ProductLoadedState state, int index) {
    if (index >= state.products.length) {
      return const ProductCardShimmer();
    } else {
      final product = state.products[index];
      return PromotionCard(product: product);
    }
  }
}
