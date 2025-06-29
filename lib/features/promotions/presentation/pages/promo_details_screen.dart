import 'package:chupachap/features/promotions/presentation/widgets/promo_badge.dart';
import 'package:chupachap/features/promotions/presentation/widgets/promo_header.dart';
import 'package:chupachap/features/promotions/presentation/widgets/promo_products_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chupachap/features/promotions/data/models/promotion_model.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:intl/intl.dart';

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

  String formatDateOnly(DateTime dateTime) {
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 270.0,
            pinned: true,
            stretch: true,
            stretchTriggerOffset: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              title: Text(
                widget.promotion.campaignTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  PromoHeader(
                    imageUrl: widget.promotion.imageUrl,
                    promotionId: widget.promotion.id,
                  ),

                  // Gradient overlay for better text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),

                  // Content overlay
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 80, // Leave space for the title
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Discount badge
                        Align(
                          alignment: Alignment.centerLeft,
                          child: PromoBadge(
                            discountPercentage:
                                widget.promotion.discountPercentage,
                          ).animate().fadeIn(duration: 600.ms).scale(
                                begin: const Offset(0.8, 0.8),
                                end: const Offset(1.0, 1.0),
                                duration: 800.ms,
                                curve: Curves.elasticOut,
                              ),
                        ),

                        const SizedBox(height: 12),

                        // Description
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.promotion.description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ).animate().fadeIn(duration: 700.ms).slideX(
                              begin: -0.3,
                              end: 0.0,
                              duration: 800.ms,
                              curve: Curves.easeOutQuart,
                            ),

                        const SizedBox(height: 12),

                        // Compact validity info
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Valid until ${formatDateOnly(widget.promotion.endDate)}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 1,
                                height: 12,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.category_outlined,
                                size: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                getPromotionTypeDisplay(
                                    widget.promotion.promotionTarget),
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 800.ms).slideY(
                              begin: 0.3,
                              end: 0.0,
                              duration: 900.ms,
                              curve: Curves.easeOutQuart,
                            ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Optional: Compact summary bar (if you want a small detail section)
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey[900]?.withOpacity(0.3)
                          : Colors.grey[100],
                      border: Border(
                        bottom: BorderSide(
                          color: isDarkMode
                              ? Colors.grey[800]!
                              : Colors.grey[300]!,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (widget.promotion.usageLimit != null) ...[
                          _buildCompactStat(
                            context,
                            Icons.people_outline,
                            '${widget.promotion.usageCount}/${widget.promotion.usageLimit}',
                            'Usage',
                          ),
                          Container(
                              width: 1, height: 20, color: Colors.grey[400]),
                        ],
                        _buildCompactStat(
                          context,
                          Icons.shopping_bag_outlined,
                          '${_products.length}',
                          'Products',
                        ),
                        Container(
                            width: 1, height: 20, color: Colors.grey[400]),
                        _buildCompactStat(
                          context,
                          Icons.local_offer_outlined,
                          '${widget.promotion.discountPercentage.toInt()}%',
                          'Discount',
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(
                        begin: -0.2,
                        end: 0.0,
                        duration: 700.ms,
                      ),

                  // Products grid takes up remaining space
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PromoProductsGrid(products: _products)
                          .animate()
                          .fadeIn(duration: 800.ms)
                          .scale(
                            begin: const Offset(0.95, 0.95),
                            end: const Offset(1.0, 1.0),
                            duration: 1000.ms,
                            curve: Curves.easeOutQuart,
                          ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCompactStat(
      BuildContext context, IconData icon, String value, String label) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 18,
          color: isDarkMode ? Colors.white70 : Colors.grey[700],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDarkMode ? Colors.white60 : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
