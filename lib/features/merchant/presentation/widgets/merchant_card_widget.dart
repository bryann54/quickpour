// ignore_for_file: deprecated_member_use

import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/merchant/data/models/merchants_model.dart';
import 'package:chupachap/features/merchant/presentation/pages/merchant_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MerchantCardWidget extends StatelessWidget {
  final Merchants merchant;
  final VoidCallback? onTap;

  const MerchantCardWidget({super.key, required this.merchant, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MerchantDetailsScreen(merchant: merchant),
                  ),
                );
              },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDarkMode
                    ? AppColors.accentColor.withValues(alpha: .3)
                    : Colors.grey.withValues(alpha: 0.5),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Profile Image with Grayscale Effect
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                ),
                              ],
                              border: Border.all(
                                color: isDarkMode
                                    ? AppColors.accentColor
                                        .withValues(alpha: .3)
                                    : Colors.grey.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Hero(
                              tag: 'merchant_image_${merchant.id}',
                              child: ColorFiltered(
                                colorFilter: merchant.isOpen
                                    ? const ColorFilter.mode(
                                        Colors.transparent, BlendMode.multiply)
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
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: merchant.imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.accentColor,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      child: Icon(
                                        Icons.error,
                                        size: 40,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (merchant.isVerified)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Hero(
                                tag: 'verified-${merchant.id}',
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.verified,
                                    color: merchant.isOpen
                                        ? AppColors.accentColor
                                        : AppColors.textSecondaryDark,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(width: 16),

                      // Merchant Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Hero(
                                    tag: 'merchant-name-${merchant.id}',
                                    child: Text(
                                      merchant.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: merchant.isOpen
                                                ? null
                                                : Colors.grey[600],
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Hero(
                                  tag: 'merchant-open-${merchant.id}',
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: merchant.isOpen
                                          ? Colors.green.withValues(alpha: 0.1)
                                          : Colors.grey.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      merchant.isOpen ? 'OPEN' : 'CLOSED',
                                      style: TextStyle(
                                        color: merchant.isOpen
                                            ? Colors.green
                                            : Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: merchant.isOpen
                                      ? Colors.grey[600]
                                      : Colors.grey[400],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    merchant.location,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: merchant.isOpen
                                              ? Colors.grey[600]
                                              : Colors.grey[400],
                                          fontSize: 14,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: merchant.isOpen
                                        ? AppColors.accentColor
                                            .withValues(alpha: 0.1)
                                        : Colors.grey.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: merchant.isOpen
                                            ? Colors.amber
                                            : Colors.grey[400],
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        merchant.rating.toStringAsFixed(1),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: merchant.isOpen
                                              ? AppColors.accentColor
                                              : Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Semi-transparent overlay when closed
                if (!merchant.isOpen)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withValues(alpha: 0.03),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
