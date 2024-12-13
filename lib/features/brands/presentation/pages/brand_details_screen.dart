import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:chupachap/features/drink_request/presentation/pages/drink_request_screen.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_event.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:chupachap/features/product/presentation/widgets/product_card.dart';
import 'package:chupachap/features/product/presentation/widgets/product_shimmer_widget.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_bloc.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_state.dart';
import 'package:chupachap/features/product_search/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandDetailsScreen extends StatefulWidget {
  final BrandModel brand;

  const BrandDetailsScreen({
    super.key,
    required this.brand,
  });

  @override
  State<BrandDetailsScreen> createState() => _BrandDetailsScreenState();
}

class _BrandDetailsScreenState extends State<BrandDetailsScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    // Implement search functionality here
    print('Search query: $_searchQuery');
  }

  void _onFilterTap() {
    // Implement filter functionality here
    print('Filter button tapped');
  }

  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brand.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image/logo
            Hero(
              tag: 'brand_logo_${widget.brand.id}',
              child: Center(
                child: Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.brand.logoUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            // Brand Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.brand.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.brand.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomSearchBar(
                controller: _searchController,
                onSearch: _onSearch,
                onFilterTap: _onFilterTap,
              ),
            ),

            // Add search results or filtered items
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Displaying results for: $_searchQuery',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
               BlocBuilder<ProductSearchBloc, ProductSearchState>(
              builder: (context, searchState) {
                // If search is active and has results
                if (searchState is ProductSearchLoadedState &&
                    searchState.searchResults.isNotEmpty) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: searchState.searchResults.length,
                    itemBuilder: (context, index) {
                      final product = searchState.searchResults[index];
                      return ProductCard(product: product);
                    },
                  );
                }

                // If search is active but no results
                if (searchState is ProductSearchLoadedState &&
                    searchState.searchResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Oops!!... didn\'t find "${_searchController.text}"'),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DrinkRequestScreen(),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: isDarkMode
                                    ? AppColors.background.withOpacity(.8)
                                    : AppColors.backgroundDark,
                              ),
                              child: Center(
                                child: Text(
                                  'make drink request',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: isDarkMode
                                            ? AppColors.backgroundDark
                                            : AppColors.background,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }

                // Fallback to original product list
                return BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (searchState is ProductSearchLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }

                    if (state is ProductLoadingState) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: 6,
                        itemBuilder: (context, index) =>
                            const ProductCardShimmer(),
                      );
                    }

                    if (state is ProductErrorState) {
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
                                context
                                    .read<ProductBloc>()
                                    .add(FetchProductsEvent());
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is ProductLoadedState) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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

                    return const SizedBox.shrink();
                  },
                );
              },
            ),
     
          ],
        ),
      ),
    );
  }
}
