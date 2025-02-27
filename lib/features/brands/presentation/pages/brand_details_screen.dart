import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/cart/presentation/pages/cart_page.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_bloc.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_event.dart';
import 'package:chupachap/features/product_search/presentation/widgets/filter_bottomSheet.dart';
import 'package:chupachap/features/product/presentation/widgets/promo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:chupachap/features/product_search/presentation/widgets/search_bar.dart';
import 'package:badges/badges.dart' as badges;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BrandDetailsScreen extends StatefulWidget {
  final BrandModel brand;

  const BrandDetailsScreen({
    Key? key,
    required this.brand,
  }) : super(key: key);

  @override
  State<BrandDetailsScreen> createState() => _BrandDetailsScreenState();
}

class _BrandDetailsScreenState extends State<BrandDetailsScreen> {
  late final TextEditingController _searchController;
  String _searchQuery = '';
  late ProductSearchBloc _productSearchBloc;

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
      _searchQuery = query.toLowerCase();
    });
  }

  void _onFilterTap() {
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            iconTheme: const IconThemeData(color: AppColors.background),
            actions: [
              BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  if (cartState.cart.totalQuantity > 0) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: badges.Badge(
                        badgeContent: Text(
                          '${cartState.cart.totalQuantity}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        showBadge: cartState.cart.totalQuantity > 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.accentColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.cartShopping,
                              size: 20,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CartPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildSection(),
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
            child: CustomSearchBar(
              controller: _searchController,
              onSearch: _onSearch,
              onFilterTap: _onFilterTap,
            ),
          ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.1)),
          if (_searchQuery.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  'Displaying results for: $_searchQuery',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          _buildProductList(),
        ],
      ),
    );
  }

  Widget _buildSection() {
    return Stack(
      children: [
        Hero(
          tag: 'brand-image-${widget.brand.logoUrl}',
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.accentColor.withOpacity(0.4)),
              image: DecorationImage(
                image: CachedNetworkImageProvider(widget.brand.logoUrl),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'brand-name-${widget.brand.name}',
                  child: Text(
                    widget.brand.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    widget.brand.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 3.0,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    return SliverFillRemaining(
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (state is ProductLoadedState) {
            final brandProducts = state.products.where((product) {
              final matchesBrand = product.brandName.toLowerCase() ==
                  widget.brand.name.toLowerCase();
              final matchesSearch = _searchQuery.isEmpty ||
                  product.productName.toLowerCase().contains(_searchQuery);
              return matchesBrand && matchesSearch;
            }).toList();

            if (brandProducts.isEmpty) {
              return Center(
                child: Text(
                  _searchQuery.isEmpty
                      ? 'No products found in ${widget.brand.name}'
                      : 'No products match your search',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.only(top: 16, left: 3, right: 3),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: brandProducts.length,
              itemBuilder: (context, index) {
                final product = brandProducts[index];
                return PromotionCard(product: product);
              },
            );
          }

          if (state is ProductErrorState) {
            return Center(
              child: Text(
                'Error loading products for ${widget.brand.name}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
