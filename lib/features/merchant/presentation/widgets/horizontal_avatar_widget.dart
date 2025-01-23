import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/merchant/data/models/merchants_model.dart';
import 'package:chupachap/features/merchant/presentation/pages/merchant_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MerchantDetailsScreen(merchant: merchant),
          ),
        );
      },
      child: Container(
        width: 100,
        height: 150,
        margin: EdgeInsets.only(
          left: isFirst ? 4.0 : 0.0,
          right: isLast ? 4.0 : 8.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isFirst || isLast
                ? Colors.transparent
                : AppColors.accentColor.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            _buildBackgroundImage(),
            _buildMerchantInfo(context),
            _buildStatusBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: merchant.imageUrl,
        width: 100,
        height: 150,
        fit: BoxFit.cover,
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
          child: FaIcon(
            Icons.error,
            size: 35,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildMerchantInfo(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              merchant.name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: isDarkMode ? Colors.white70 : Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (merchant.isVerified) const SizedBox(height: 4),
            if (merchant.isVerified)
              Row(
                children: [
                  const FaIcon(
                    Icons.verified,
                    size: 14,
                    color: AppColors.accentColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Verified',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDarkMode ? Colors.white70 : Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: merchant.isOpen ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          merchant.isOpen ? 'Open' : 'Closed',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
