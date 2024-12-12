import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';

class MerchantsDetailsSection extends StatelessWidget {
  final ProductModel product;

  const MerchantsDetailsSection({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Store',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Merchants Avatar
                _buildMerchantsAvatar(),
                const SizedBox(width: 12),

                // Merchants Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.merchants.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? AppColors.background.withOpacity(0.8)
                                    : AppColors.primaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildMerchantsRating(context, isDarkMode),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.merchants.location,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDarkMode
                              ? AppColors.background.withOpacity(0.5)
                              : AppColors.primaryColor.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantsAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accentColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: product.merchants.imageUrl.toString(),
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 30,
              backgroundImage: imageProvider,
            ),
            placeholder: (context, url) => CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.accentColor.withOpacity(0.1),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.accentColor.withOpacity(0.1),
              child: const FaIcon(
                FontAwesomeIcons.houseChimneyWindow,
                size: 24,
                color: AppColors.accentColor,
              ),
            ),
          ),
        ),

        // Verified Badge
        if (product.merchants.isVerified)
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
                border: Border.all(
                  color: AppColors.accentColor,
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.verified,
                color: AppColors.accentColor,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMerchantsRating(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : AppColors.accentColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            product.merchants.rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
