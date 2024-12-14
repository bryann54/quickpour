import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/brands/presentation/bloc/brands_bloc.dart';
import 'package:chupachap/features/brands/presentation/pages/brands_screen.dart';
import 'package:chupachap/features/brands/presentation/widgets/horizontal_list_widget.dart';
import 'package:chupachap/features/categories/data/repositories/category_repository.dart';
import 'package:chupachap/features/categories/domain/usecases/fetch_categories.dart';
import 'package:chupachap/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:chupachap/features/categories/presentation/bloc/categories_event.dart';
import 'package:chupachap/features/categories/presentation/bloc/categories_state.dart';
import 'package:chupachap/features/categories/presentation/pages/categories_screen.dart';
import 'package:chupachap/features/categories/presentation/widgets/horizontal_list_widget.dart';
import 'package:chupachap/features/categories/presentation/widgets/shimmer_widget.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_bloc.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_event.dart';
import 'package:chupachap/features/product_search/presentation/widgets/home_screen_search.dart';
import 'package:chupachap/features/merchant/presentation/bloc/merchant_bloc.dart';
import 'package:chupachap/features/merchant/presentation/pages/merchants_screen.dart';
import 'package:chupachap/features/merchant/presentation/widgets/merchant_horizontal_list_widget.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_event.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:chupachap/features/product/presentation/widgets/product_card.dart';
import 'package:chupachap/features/product/presentation/widgets/product_shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  late ScrollController _scrollController;
  late ProductSearchBloc _productSearchBloc;
  final _searchController = TextEditingController();
  final _searchSubject = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _productSearchBloc = ProductSearchBloc(
      productRepository: ProductRepository(),
    );

    // Setup debounce for search
    _searchSubject
        .debounceTime(const Duration(milliseconds: 300))
        .distinct()
        .listen((query) {
      _productSearchBloc.add(SearchProductsEvent(query));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchSubject.close();
    _productSearchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductBloc(
            productRepository: ProductRepository(),
          )..add(FetchProductsEvent()),
        ),
        BlocProvider(
          create: (context) => CategoriesBloc(
            FetchCategories(CategoryRepository()),
          )..add(LoadCategories()),
        ),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(
          showNotification: true,
          showCart: false,
          showProfile: true,
          showGreeting: true,
        ),
        body: Column(
          children: [
              HomeScreenSearch(
              controller: _searchController,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
               
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Verified  Stores',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.verified,
                                color:
                                    isDarkMode ? Colors.teal : AppColors.accentColor,
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MerchantsScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'See All',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: isDarkMode
                                        ? Colors.teal
                                        : AppColors.accentColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<MerchantBloc, MerchantState>(
                      builder: (context, state) {
                        if (state is MerchantLoaded) {
                          return HorizontalMerchantsListWidget(
                              merchant: state.merchants);
                        }
                        if (state is MerchantLoading) {
                          return const Center(child: LoadingHorizontalList());
                        }
                        if (state is MerchantError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Top Brands',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BrandsScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'See All',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: isDarkMode
                                        ? Colors.teal
                                        : AppColors.accentColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<BrandsBloc, BrandsState>(
                      builder: (context, state) {
                        if (state is BrandsLoadedState) {
                          return HorizontalBrandsListWidget(brands: state.brands);
                        }
                        if (state is BrandsLoadingState) {
                          return const Center(child: LoadingHorizontalList());
                        }
                        if (state is BrandsErrorState) {
                          return Center(child: Text(state.errorMessage));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Categories',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CategoriesScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'See All',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: isDarkMode
                                        ? Colors.teal
                                        : AppColors.accentColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<CategoriesBloc, CategoriesState>(
                      builder: (context, state) {
                        if (state is CategoriesLoaded) {
                          return HorizontalCategoriesListWidget(
                              categories: state.categories);
                        }
                        return const Center(child: LoadingHorizontalList());
                      },
                    ),
                    Text(
                      'Recommended for you',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        if (state is ProductLoadingState) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: 6,
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) =>
                                const ProductCardShimmer(),
                          );
                        }
              
                        if (state is ProductErrorState) {
                          return Center(child: Text(state.errorMessage));
                        }
              
                        if (state is ProductLoadedState) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
}
