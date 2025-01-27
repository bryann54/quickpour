import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/merchant/data/models/merchants_model.dart';
import 'package:chupachap/features/product_search/presentation/widgets/search_bar.dart';
import 'package:flutter/material.dart';
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
    widget.onSearch(query);
  }

  void _onFilterTap() {
    print('Filter button tapped');
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: [
        // Background Image
        Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.accentColor.withOpacity(0.5),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: widget.merchant.imageUrl,
              placeholder: (context, url) => _buildPlaceholderLoader(),
              errorWidget: (context, url, error) => _buildErrorIcon(),
              fit: BoxFit.cover,
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
                  Colors.black.withOpacity(0.6),
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
                  Text(
                    widget.merchant.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (widget.merchant.isVerified)
                    const Padding(
                      padding: EdgeInsets.only(left: 6.0),
                      child: Icon(
                        Icons.verified,
                        color: AppColors.accentColor,
                        size: 20,
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
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.locationDot,
                        size: 16,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.merchant.location,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.merchant.isOpen ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.merchant.isOpen ? 'Open' : 'Closed',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
              )
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
          AppColors.accentColor.withOpacity(0.5),
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
