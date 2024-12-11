
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/brands/data/models/brands_model.dart';

import 'package:flutter/material.dart';

class brandCardAvatar extends StatelessWidget {
  final BrandModel brand;
  final bool isFirst;
  final bool isLast;

  const brandCardAvatar({
    super.key,
    required this.brand,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Add brand detail navigation
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAvatarWithBadge(),
          const SizedBox(height: 4),
          _buildbrandName(context),
        ],
      ),
    );
  }


  Widget _buildAvatarWithBadge() {
    return Stack(
      children: [
        _buildAvatarImage(),
       
          // Positioned(
          //   top: 0,
          //   right: 0,
          //   child: Container(
          //     padding: const EdgeInsets.all(2),
          //     decoration: const BoxDecoration(
          //       color: Colors.white,
          //       shape: BoxShape.circle,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black12,
          //           blurRadius: 4,
          //           offset: Offset(0, 2),
          //         ),
          //       ],
          //     ),
          //     child: const Icon(
          //       Icons.verified,
          //       size: 16,
          //       color: AppColors.accentColor,
          //     ),
          //   ),
          // ),
      ],
    );
  }

  Widget _buildAvatarImage() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.accentColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Hero(
        tag: 'brand_avatar_${brand.id}',
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: brand.logoUrl,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.grey[400],
              ),
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildbrandName(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        brand.name,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: isDarkMode ? Colors.white70 : Colors.black87,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
