import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/bloc/product_bloc.dart';
import 'package:chupachap/features/product/presentation/bloc/product_event.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:chupachap/features/product/presentation/widgets/product_card.dart';
import 'package:chupachap/features/product_search/presentation/widgets/search_bar.dart';

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
  }

  void _onFilterTap() {
    // Implement filter functionality
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductBloc(productRepository: ProductRepository())
        ..add(FetchProductsEvent()),
      child: Scaffold(
        appBar: CustomAppBar(
          showNotification: false,
          showProfile: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            _buildSearchBar(),
            if (_searchQuery.isNotEmpty) _buildSearchQueryText(),
            _buildProductList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        Hero(
          tag: 'category_image_${widget.brand.id}',
          child: Container(
            width: double.infinity,
            height: 100,
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
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 100,
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
                Text(
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
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    widget.brand.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
      child: CustomSearchBar(
        controller: _searchController,
        onSearch: _onSearch,
        onFilterTap: _onFilterTap,
      ),
    );
  }

  Widget _buildSearchQueryText() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        'Displaying results for: $_searchQuery',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildProductList() {
    return Expanded(
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state is ProductLoadedState) {
            final brandProducts = state.products
                .where((product) => product.brandName == widget.brand.id)
                .toList();

            if (brandProducts.isEmpty) {
              return Center(
                child: Text(
                  'No products found for ${widget.brand.name}.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(6.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: brandProducts.length,
              itemBuilder: (context, index) {
                final product = brandProducts[index];
                return ProductCard(product: product);
              },
            );
          }

          if (state is ProductErrorState) {
            return Center(
              child: Text(
                state.errorMessage,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.red,
                    ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
