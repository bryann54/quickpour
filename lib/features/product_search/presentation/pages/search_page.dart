import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/drink_request/presentation/pages/requests_screen.dart';
import 'package:chupachap/features/product_search/presentation/widgets/filter_bottomSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rxdart/rxdart.dart';

import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_event.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:chupachap/features/product/presentation/widgets/product_card.dart';
import 'package:chupachap/features/product/presentation/widgets/product_shimmer_widget.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_bloc.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_event.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_state.dart';

class SearchPage extends StatefulWidget {
  final AuthRepository authRepository;
  final TextEditingController? searchController;

  const SearchPage({
    super.key,
    this.searchController,
    required this.authRepository,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late ScrollController _scrollController;
  late ProductSearchBloc _productSearchBloc;
  late TextEditingController _searchController;
  final _searchSubject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _productSearchBloc = ProductSearchBloc(
      productRepository: ProductRepository(),
    );

    // Use the passed controller or create a new one
    _searchController = widget.searchController ?? TextEditingController();

    // Trigger initial search if controller has text
    if (_searchController.text.isNotEmpty) {
      _searchSubject.add(_searchController.text);
    }

    // Setup debounce for search
    _searchSubject
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .listen((query) {
      _productSearchBloc.add(SearchProductsEvent(query));
    });

    // Add listener to handle text changes
    _searchController.addListener(() {
      _searchSubject.add(_searchController.text);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchSubject.close();
    _productSearchBloc.close();

    // Only dispose if we created the controller
    if (widget.searchController == null) {
      _searchController.dispose();
    }

    super.dispose();
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => FilterBottomSheet(
          onApplyFilters: (filters) {
            _productSearchBloc.add(
              FilterProductsEvent(
                category: filters['category'] as String?,
                store: filters['store'] as String?,
                priceRange: filters['priceRange'] as RangeValues?,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
     
        BlocProvider.value(
          value: _productSearchBloc,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isDarkMode
                    ? AppColors.accentColor.withOpacity(.3)
                    : Colors.grey.shade300,
              ),
              color: isDarkMode ? Colors.grey.shade600 : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search product',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: const FaIcon(Icons.tune),
                  onPressed: _openFilterBottomSheet,
                ),
              ),
            ),
          ),
        ),
        body: BlocBuilder<ProductSearchBloc, ProductSearchState>(
          builder: (context, searchState) {
            // If search is active and has results
            if (searchState is ProductSearchLoadedState &&
                searchState.searchResults.isNotEmpty) {
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    Text('Oops!!... didn\'t find "${_searchController.text}"'),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RequestsScreen(
                                authRepository: widget.authRepository,
                                initialDrinkName: _searchController.text,
                              ),
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
                    itemBuilder: (context, index) => const ProductCardShimmer(),
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
      ),
    );
  }
}
