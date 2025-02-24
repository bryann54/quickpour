import 'dart:async';

import 'package:chupachap/core/utils/date_formatter.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/widgets/product_shimmer_widget.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_bloc.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_event.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_state.dart';
import 'package:chupachap/features/product_search/presentation/widgets/filter_bottomSheet.dart';
import 'package:chupachap/features/promotions/presentation/widgets/promo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:rxdart/rxdart.dart';

class ItemBottomsheet extends StatefulWidget {
  final double initialRemainingForFreeDelivery;
  final AuthRepository authRepository;
  final TextEditingController? searchController;
  final Function(dynamic)? onProductSelected;
  final Stream<Cart>? cartStream;
  final double freeDeliveryThreshold;

  const ItemBottomsheet({
    Key? key,
    this.searchController,
    required this.authRepository,
    required this.initialRemainingForFreeDelivery,
    this.onProductSelected,
    this.cartStream,
    this.freeDeliveryThreshold = 5000,
  }) : super(key: key);

  @override
  State<ItemBottomsheet> createState() => _ItemBottomsheetState();
}

class _ItemBottomsheetState extends State<ItemBottomsheet> {
  late ScrollController _scrollController;
  late ProductSearchBloc _productSearchBloc;
  late ProductBloc _productBloc;
  late TextEditingController _searchController;
  final _searchSubject = PublishSubject<String>();
  StreamSubscription? _searchSubscription;
  StreamSubscription? _cartSubscription;

  bool _showSearchResults = false;
  double _remainingForFreeDelivery = 0;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupSearchStream();
    _setupCartStream();
    _fetchRecommendedProducts();
    _remainingForFreeDelivery = widget.initialRemainingForFreeDelivery;
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    final productRepository = ProductRepository();
    _productSearchBloc =
        ProductSearchBloc(productRepository: productRepository);
    _productBloc = ProductBloc(productRepository: productRepository);
    _searchController = widget.searchController ?? TextEditingController();
  }

  void _setupSearchStream() {
    _searchController.addListener(_onSearchTextChanged);

    _searchSubscription = _searchSubject
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .listen(_onSearchQuery);
  }

  void _setupCartStream() {
    if (widget.cartStream != null) {
      _cartSubscription = widget.cartStream!.listen((cart) {
        if (mounted) {
          final remaining = widget.freeDeliveryThreshold - cart.totalPrice > 0
              ? widget.freeDeliveryThreshold - cart.totalPrice
              : 0;

          setState(() {
            _remainingForFreeDelivery = remaining.toDouble();
          });
        }
      });
    }
  }

  void _onSearchTextChanged() {
    if (mounted) {
      final query = _searchController.text;
      _searchSubject.add(query);
      setState(() {
        _showSearchResults = query.isNotEmpty;
      });
    }
  }

  void _onSearchQuery(String query) {
    if (mounted && query.isNotEmpty) {
      debugPrint('Searching for: $query');
      _productSearchBloc.add(SearchProductsEvent(query));
    }
  }

  void _fetchRecommendedProducts() {
    _productSearchBloc.add(const FetchRecommendedProductsEvent(limit: 6));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchSubscription?.cancel();
    _cartSubscription?.cancel();
    _searchSubject.close();
    _productSearchBloc.close();
    _productBloc.close();

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
        initialChildSize: 0.9,
        minChildSize: 0.75,
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
        BlocProvider.value(value: _productSearchBloc),
        BlocProvider.value(value: _productBloc),
      ],
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardColorDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar for dragging
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add drinks to Cart',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  if (_remainingForFreeDelivery > 0) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.blue.shade900.withOpacity(0.3)
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            color: theme.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                children: [
                                  const TextSpan(text: 'Add '),
                                  TextSpan(
                                    text:
                                        'KSh ${formatMoney(_remainingForFreeDelivery)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                  const TextSpan(
                                      text: ' more to get FREE DELIVERY'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Search Bar
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDarkMode
                      ? AppColors.accentColor.withOpacity(.3)
                      : Colors.grey.shade300,
                ),
                color: isDarkMode ? Colors.grey.shade700 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade500,
                      ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDarkMode
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _showSearchResults = false;
                            });
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.tune),
                          onPressed: _openFilterBottomSheet,
                        ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

            // Content
            Expanded(
              child: _showSearchResults
                  ? _buildSearchResults()
                  : _buildRecommendedProducts(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<ProductSearchBloc, ProductSearchState>(
      builder: (context, searchState) {
        if (searchState is ProductSearchLoadingState) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (searchState is ProductSearchLoadedState) {
          if (searchState.searchResults.isNotEmpty) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: searchState.searchResults.length,
              itemBuilder: (context, index) {
                final product = searchState.searchResults[index];
                return GestureDetector(
                  onTap: () {
                    if (widget.onProductSelected != null) {
                      widget.onProductSelected!(product);
                    }
                    Navigator.pop(context);
                  },
                  child: PromotionCard(product: product),
                );
              },
            );
          } else {
            return _buildNoResultsFound();
          }
        }

        return const Center(
          child: Text("Type to search products"),
        );
      },
    );
  }

  Widget _buildNoResultsFound() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No results found for "${_searchController.text}"',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or browse recommended products',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Show customer support or product request form
              // This replaces the "make drink request" functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product request feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Request a Product'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedProducts() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category sections
          _buildRecommendedSection("Recommended For You"),
          _buildPopularProductsSection(),
          _buildNewArrivalsSection(),
          _buildFeaturedSection(),
        ],
      ),
    );
  }

  Widget _buildRecommendedSection(String title) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all recommended products
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoadingState) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 4,
                  itemBuilder: (context, index) => Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),
                    child: const ProductCardShimmer(),
                  ),
                );
              }

              if (state is ProductErrorState) {
                return Center(
                  child: Text(
                    'Failed to load recommendations',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.red.shade300,
                    ),
                  ),
                );
              }

              if (state is ProductLoadedState && state.products.isNotEmpty) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.products.length.clamp(0, 6),
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          if (widget.onProductSelected != null) {
                            widget.onProductSelected!(product);
                          }
                          Navigator.pop(context);
                        },
                        child: PromotionCard(product: product),
                      ),
                    );
                  },
                );
              }

              return Center(
                child: Text(
                  'No recommendations available',
                  style: theme.textTheme.bodyMedium,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularProductsSection() {
    return _buildRecommendedSection("Popular Products");
  }

  Widget _buildNewArrivalsSection() {
    return _buildRecommendedSection("New Arrivals");
  }

  Widget _buildFeaturedSection() {
    return _buildRecommendedSection("Featured Products");
  }
}
