import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/merchant/data/models/merchants_model.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_bloc.dart';
import 'package:chupachap/features/product_search/presentation/bloc/product_search_event.dart';
import 'package:chupachap/features/product_search/presentation/widgets/filter_bottomSheet.dart';
import 'package:chupachap/features/product_search/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MerchantDetailsHeader extends StatefulWidget {
  final Merchants merchant;
  final Function(String) onSearch;

  const MerchantDetailsHeader({
    super.key,
    required this.merchant,
    required this.onSearch,
  });

  @override
  State<MerchantDetailsHeader> createState() => _MerchantDetailsHeaderState();
}

class _MerchantDetailsHeaderState extends State<MerchantDetailsHeader> {
  late TextEditingController _searchController;
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
    setState(() {});
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
    final theme = Theme.of(context);
    return Stack(
      children: [
        // Background Image
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.accentColor.withValues(alpha: 0.5),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Hero(
              tag: 'merchant_image_${widget.merchant.id}',
              child: CachedNetworkImage(
                imageUrl: widget.merchant.imageUrl,
                placeholder: (context, url) => _buildPlaceholderLoader(),
                errorWidget: (context, url, error) => _buildErrorIcon(),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Overlay Container for Merchant Details
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),
        // Merchant Details
        Positioned(
          bottom: 12,
          left: 12,
          right: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Merchant Name and Verified Badge
              Row(
                children: [
                  Hero(
                    tag: 'merchant-name-${widget.merchant.id}',
                    child: Text(
                      widget.merchant.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (widget.merchant.isVerified)
                    Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Hero(
                        tag: 'verified-${widget.merchant.id}',
                        child: const Icon(
                          Icons.verified,
                          color: AppColors.accentColor,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Rating
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.merchant.rating.toStringAsFixed(1),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Location and Open/Closed Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.locationDot,
                          size: 16,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            widget.merchant.location,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Hero(
                    tag: 'merchant-open-${widget.merchant.id}',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            widget.merchant.isOpen ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Open',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomSearchBar(
                    controller: _searchController,
                    onSearch: _onSearch,
                    onFilterTap: _onFilterTap),
              ).animate().fadeIn(duration: 500.ms).slideX(begin: 0.1)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderLoader() {
    return Center(
      child: CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.accentColor.withValues(alpha: 0.5),
        ),
        strokeWidth: 2,
      ),
    );
  }

  Widget _buildErrorIcon() {
    return Align(
      alignment: Alignment.center,
      child: FaIcon(
        Icons.error,
        color: Colors.grey.shade500,
        size: 40,
      ),
    );
  }
}
