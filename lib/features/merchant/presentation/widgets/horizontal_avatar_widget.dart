import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/merchant/data/models/merchants_model.dart';
import 'package:chupachap/features/merchant/presentation/pages/merchant_details_screen.dart';
import 'package:flutter/material.dart';

class MerchantCardAvatar extends StatelessWidget {
  final Merchants merchant;
  final bool isFirst;
  final bool isLast;

  const MerchantCardAvatar({
    super.key,
    required this.merchant,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MerchantDetailsScreen(merchant: merchant),
        ),
      ),
      child: Container(
        width: 110,
        margin: EdgeInsets.only(
          left: isFirst ? 12.0 : 4.0,
          right: isLast ? 12.0 : 4.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            _buildBackgroundImage(),
            if (!merchant.isOpen) _buildClosedOverlay(),
            _buildGlassOverlay(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Hero(
        tag: 'merchant_image_${merchant.id}',
        child: ColorFiltered(
          colorFilter: merchant.isOpen
              ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
              : const ColorFilter.matrix([
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0.2126,
                  0.7152,
                  0.0722,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
          child: CachedNetworkImage(
            imageUrl: merchant.imageUrl,
            width: 110,
            height: 150,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[200],
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[200],
              child: const Icon(Icons.error, size: 35, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClosedOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildGlassOverlay(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          color: Colors.black.withOpacity(merchant.isOpen ? 0.4 : 0.6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'merchant-name-${merchant.id}',
              child: Text(
                merchant.name,
                style: const TextStyle(
                  color: AppColors.background,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (merchant.isVerified)
              const Row(
                children: [
                  Icon(Icons.verified,
                      size: 14, color: AppColors.accentColor),
                  SizedBox(width: 4),
                  Text(
                    'Verified',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
