import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:chupachap/features/brands/presentation/pages/brand_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BrandCardWidget extends StatelessWidget {
  final BrandModel brand;
  final bool isVerified;

  const BrandCardWidget({
    super.key,
    required this.brand,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToBrandDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Brand Logo with Verification Badge
              _buildBrandLogo(context),

              const SizedBox(width: 16),

              // Brand Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBrandName(context),
                    const SizedBox(height: 4),
                    _buildBrandLocation(context),
                  ],
                ),
              ),

              // Additional Action/Status Indicator
              _buildActionIndicator(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandLogo(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Hero(
          tag: 'brand_logo_${brand.id}',
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade50,
            child: CachedNetworkImage(
              imageUrl: brand.logoUrl,
              placeholder: (context, url) => _buildPlaceholderLoader(),
              errorWidget: (context, url, error) => _buildErrorIcon(),
              fit: BoxFit.contain,
              width: 60,
              height: 60,
            ),
          ),
        ),
        if (isVerified)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.verified,
                color: Colors.green,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholderLoader() {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        AppColors.accentColor.withOpacity(0.5),
      ),
      strokeWidth: 2,
    );
  }

  Widget _buildErrorIcon() {
    return Icon(
      Icons.error,
      color: Colors.grey.shade500,
      size: 40,
    );
  }

  Widget _buildBrandName(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            brand.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBrandLocation(BuildContext context) {
    return Row(
      children: [
        FaIcon(
          FontAwesomeIcons.locationPin,
          color: Colors.grey.shade600,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            brand.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.chevron_right,
        color: AppColors.accentColor,
        size: 24,
      ),
    );
  }

  void _navigateToBrandDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BrandDetailsScreen(
          brand: brand,
        ),
      ),
    );
  }
}
