import 'package:chupachap/core/utils/date_formatter.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/features/promotions/data/models/promotion_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PromoDetailsScreen extends StatefulWidget {
  final PromotionModel promotion;
  final List<ProductModel>? prefetchedProducts;

  const PromoDetailsScreen({
    super.key,
    required this.promotion,
    this.prefetchedProducts,
  });

  @override
  State<PromoDetailsScreen> createState() => _PromoDetailsScreenState();
}

class _PromoDetailsScreenState extends State<PromoDetailsScreen> {
  List<ProductModel> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.prefetchedProducts != null
        ? _initializePrefetchedProducts()
        : _loadPromotionProducts();
  }

  void _initializePrefetchedProducts() {
    setState(() {
      _products = widget.prefetchedProducts!;
      _isLoading = false;
    });
  }

  Future<void> _loadPromotionProducts() async {
    setState(() => _isLoading = true);
    try {
      _products = await _fetchPromotionProducts();
    } catch (e) {
      _showErrorDialog('Failed to load products: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<List<ProductModel>> _fetchPromotionProducts() async {
    final firestore = FirebaseFirestore.instance;
    if (widget.promotion.productIds.isNotEmpty) {
      final snapshots = await Future.wait(widget.promotion.productIds
          .map((id) => firestore.collection('products').doc(id).get()));
      return snapshots
          .where((doc) => doc.exists)
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    }
    return [];
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.promotion.campaignTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPromotionHeader(),
                    const SizedBox(height: 16),
                    _buildPromotionDetails(),
                    const SizedBox(height: 24),
                    _buildProductsGrid(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPromotionHeader() {
    return Hero(
      tag: widget.promotion.id,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: widget.promotion.imageUrl ?? '',
          fit: BoxFit.cover,
          width: double.infinity,
          height: 250,
          errorWidget: (context, url, error) =>
              const Icon(Icons.error_outline_outlined),
        ),
      ),
    );
  }

  Widget _buildPromotionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Promotion Details',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 8),
        Text(
          widget.promotion.description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildProductsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Promoted Products',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _products.isEmpty
            ? const Center(child: Text('No products found for this promotion'))
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) =>
                    _buildProductCard(_products[index]),
              ),
      ],
    );
  }

  Widget _buildProductCard(ProductModel product) {
    final discountedPrice =
        product.price * (1 - widget.promotion.discountPercentage / 100);
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: product.imageUrls.isNotEmpty
                    ? product.imageUrls.first
                    : 'assets/product_placeholder.png',
                fit: BoxFit.cover,
                width: double.infinity,
                errorWidget: (context, url, error) => Icon(Icons.error,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(
                          0.5,
                        )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text('Ksh ${formatMoney(discountedPrice)}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
                Text('Ksh ${formatMoney(product.price)}',
                    style: const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
