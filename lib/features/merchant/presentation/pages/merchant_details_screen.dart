import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/cart/presentation/pages/cart_page.dart';
import 'package:chupachap/features/merchant/data/models/merchants_model.dart';
import 'package:chupachap/features/merchant/presentation/widgets/merchant_details_header.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_event.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:chupachap/features/product/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:badges/badges.dart' as badges;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MerchantDetailsScreen extends StatefulWidget {
  final Merchants merchant;

  const MerchantDetailsScreen({Key? key, required this.merchant})
      : super(key: key);

  @override
  State<MerchantDetailsScreen> createState() => _MerchantDetailsScreenState();
}

class _MerchantDetailsScreenState extends State<MerchantDetailsScreen> {
  String _searchQuery = '';

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => ProductBloc(
        productRepository: ProductRepository(),
      )..add(FetchProductsEvent()),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              iconTheme:const IconThemeData(
                color: AppColors.background
              ),
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
                            decoration: BoxDecoration(
                              color: AppColors.accentColor,
                              borderRadius: BorderRadius.circular(35),
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
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: MerchantDetailsHeader(
                  merchant: widget.merchant,
                  onSearch: _onSearch,
                ),
                collapseMode: CollapseMode.parallax,
              ),
            ),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoadingState) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  );
                }

                if (state is ProductLoadedState) {
                  final merchantProducts = state.products.where((product) {
                    final matchesMerchant =
                        product.merchantId == widget.merchant.id;
                    final matchesSearch = _searchQuery.isEmpty ||
                        product.productName
                            .toLowerCase()
                            .contains(_searchQuery);
                    return matchesMerchant && matchesSearch;
                  }).toList();

                  if (merchantProducts.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 100.0),
                          child: Text(
                            _searchQuery.isEmpty
                                ? 'No products found for ${widget.merchant.name}'
                                : 'No products match your search',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.only(top: 16, left: 3, right: 3),
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
                          final product = merchantProducts[index];
                          return ProductCard(product: product);
                        },
                        childCount: merchantProducts.length,
                      ),
                    ),
                  );
                }

                if (state is ProductErrorState) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Error loading products for ${widget.merchant.name}',
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: Colors.red),
                      ),
                    ),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}
