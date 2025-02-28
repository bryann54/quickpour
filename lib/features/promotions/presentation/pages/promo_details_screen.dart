import 'package:chupachap/features/promotions/presentation/widgets/promo_badge.dart';
import 'package:chupachap/features/promotions/presentation/widgets/promo_details.dart';
import 'package:chupachap/features/promotions/presentation/widgets/promo_header.dart';
import 'package:chupachap/features/promotions/presentation/widgets/promo_products_grid.dart';
import 'package:chupachap/features/promotions/presentation/widgets/promo_validity_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chupachap/features/promotions/data/models/promotion_model.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.promotion.campaignTitle),
              background: PromoHeader(
                imageUrl: widget.promotion.imageUrl,
                promotionId: widget.promotion.id,
              ),
            ),
          ),
        ],
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PromoBadge(
                            discountPercentage:
                                widget.promotion.discountPercentage)
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.0, 1.0),
                            duration: 800.ms,
                            curve: Curves.elasticOut),
                    const SizedBox(height: 16),
                    PromoDetails(
                      campaignTitle: widget.promotion.campaignTitle,
                      description: widget.promotion.description,
                    ).animate().fadeIn(duration: 600.ms).scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.0, 1.0),
                        duration: 800.ms,
                        curve: Curves.elasticOut),
                    const SizedBox(height: 24),
                    PromoValidityInfo(promotion: widget.promotion)
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.0, 1.0),
                            duration: 800.ms,
                            curve: Curves.elasticOut),
                    const SizedBox(height: 24),
                    PromoProductsGrid(products: _products)
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.0, 1.0),
                            duration: 1800.ms,
                            curve: Curves.elasticOut),
                  ],
                ),
              ),
      ),
    );
  }
}
