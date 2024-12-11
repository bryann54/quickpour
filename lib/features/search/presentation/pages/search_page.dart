import 'package:chupachap/features/search/presentation/widgets/search_bar.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_event.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:chupachap/features/product/presentation/widgets/product_card.dart';
import 'package:chupachap/features/product/presentation/widgets/product_shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        productRepository: ProductRepository(),
      )..add(FetchProductsEvent()),
      child: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Sliver App Bar with Search
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 0,
              expandedHeight: 120.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              // leading: IconButton(
              //   icon: const Icon(Icons.arrow_back),
              //   onPressed: () => Navigator.pop(context),
              // ),
              actions: [
               
              ],
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                titlePadding: EdgeInsets.zero,
                title: Container(
                  width: double.infinity,
                  height: 56.0,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomSearchBar(
                      onSearch: (query) {
                        print('Searching for: $query');
                      },
                      onFilterTap: () {
                        print('Filter tapped');
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Products Grid
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoadingState) {
                  return SliverPadding(
                    padding: const EdgeInsets.all(10),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => const ProductCardShimmer(),
                        childCount: 6,
                      ),
                    ),
                  );
                }

                if (state is ProductErrorState) {
                  return SliverFillRemaining(
                    child: Center(
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
                    ),
                  );
                }

                if (state is ProductLoadedState) {
                  return SliverPadding(
                    padding: const EdgeInsets.all(10),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = state.products[index];
                          return ProductCard(product: product);
                        },
                        childCount: state.products.length,
                      ),
                    ),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),

            // Bottom padding
            const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
          ],
        ),
      ),
    );
  }
}
