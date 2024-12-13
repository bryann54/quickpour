import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:chupachap/features/brands/presentation/pages/brand_details_screen.dart';

class BrandCardAvatar extends StatelessWidget {
  final BrandModel brand;
  final bool isFirst;
  final bool isLast;

  const BrandCardAvatar({
    super.key,
    required this.brand,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToBrandDetails(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(
          left: isFirst ? 16 : 8,
          right: isLast ? 16 : 8,
        ),
        width: 80,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAvatarWithBadge(),
            const SizedBox(height: 8),
            _buildBrandName(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWithBadge() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildAvatarImage(),
      ],
    );
  }

  Widget _buildAvatarImage() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.accentColor.withOpacity(0.1),
            AppColors.accentColor.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.accentColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: Icon(
                Icons.image_not_supported,
                size: 40,
                color: Colors.grey[400],
              ),
            ),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandName(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Text(
      brand.name,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: isDarkMode ? Colors.white70 : Colors.black87,
        letterSpacing: 0.5,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  void _navigateToBrandDetails(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BrandDetailsScreen(brand: brand),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeInOut;
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: curve);

          return FadeTransition(
            opacity: curvedAnimation,
            child: ScaleTransition(
              scale: curvedAnimation,
              child: child,
            ),
          );
        },
      ),
    );
  }
}
