import 'package:flutter/material.dart';
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
      elevation: isDarkMode ? 2 : 1,
      shadowColor: isDarkMode
          ? AppColors.accentColor.withOpacity(0.3)
          : AppColors.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDarkMode
              ? AppColors.accentColor.withOpacity(0.1)
              : AppColors.primaryColor.withOpacity(0.05),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isDarkMode
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.cardColor,
                    theme.cardColor.withOpacity(0.95),
                  ],
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [AppColors.accentColor, AppColors.primaryColor]
                        : [AppColors.primaryColor, AppColors.accentColor],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FontAwesomeIcons.store,
                      size: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Store Details',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.accentColor.withOpacity(0.05)
                      : AppColors.primaryColor.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.accentColor.withOpacity(0.1)
                        : AppColors.primaryColor.withOpacity(0.1),
                  ),
                ),
                child: IntrinsicHeight(
                  // Add this to ensure proper height constraints
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align to top
                    children: [
                      _buildMerchantsAvatar(),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    product.merchantId,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? Colors.white
                                          : AppColors.primaryColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                _buildMerchantsRating(context, isDarkMode),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.locationDot,
                                  size: 14,
                                  color: isDarkMode
                                      ? AppColors.accentColor
                                      : AppColors.primaryColor,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    product.merchantId,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMerchantsAvatar() {
    return ClipOval(
      // Wrap with ClipOval to ensure proper clipping
      child: Container(
        width: 60, // Give explicit dimensions
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accentColor,
        ),
        child: const Center(
          // Center the icon
          child: FaIcon(
            FontAwesomeIcons.store,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildMerchantsRating(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [AppColors.accentColor, AppColors.primaryColor]
              : [AppColors.primaryColor, AppColors.accentColor],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentColor.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: Colors.white,
            size: 16,
          ),
          SizedBox(width: 4),
          // Text(
          //   product.merchants.rating.toStringAsFixed(1),
          //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
          //         color: Colors.white,
          //         fontWeight: FontWeight.bold,
          //       ),
          // ),
        ],
      ),
    );
  }
}
