import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:chupachap/features/product_search/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';

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
          ],
        ),
      ),
    );
  }
}
