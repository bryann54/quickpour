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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                ],
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
                child: Row(
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
                                  style: theme.textTheme.titleMedium?.copyWith(
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
                          // RichText(
                          //   text: TextSpan(
                          //     text: 'Store is now ',
                          //     style: const TextStyle(
                          //         color: Colors.black,
                          //         fontSize: 16), // Style for the base text
                          //     children: [
                          //       TextSpan(
                          //         text: product.merchants.isOpen
                          //             ? 'Open'
                          //             : 'Closed',
                          //         style: TextStyle(
                          //           color: product.merchants.isOpen
                          //               ? Colors.green
                          //               : Colors.red, // Color for the status
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMerchantsAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Container(
        //   padding: const EdgeInsets.all(3),
        //   decoration: const BoxDecoration(
        //     shape: BoxShape.circle,
        //     gradient: LinearGradient(
        //       colors: [
        //         AppColors.accentColor,
        //         AppColors.primaryColor,
        //       ],
        //     ),
        //   ),
        //   child: Container(
        //     padding: const EdgeInsets.all(2),
        //     decoration: const BoxDecoration(
        //       shape: BoxShape.circle,
        //       color: Colors.white,
        //     ),
        //     child: CachedNetworkImage(
        //       imageUrl: product.merchants.imageUrl.toString(),
        //       imageBuilder: (context, imageProvider) => CircleAvatar(
        //         radius: 30,
        //         backgroundImage: imageProvider,
        //       ),
        //       placeholder: (context, url) => const CircleAvatar(
        //         radius: 30,
        //         child: CircularProgressIndicator(
        //           strokeWidth: 2,
        //         ),
        //       ),
        //       errorWidget: (context, url, error) => CircleAvatar(
        //         radius: 30,
        //         backgroundColor: AppColors.accentColor.withOpacity(0.1),
        //         child: const FaIcon(
        //           FontAwesomeIcons.store,
        //           size: 24,
        //           color: AppColors.accentColor,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // if (product.merchants.isVerified)
        //   Positioned(
        //     bottom: -4,
        //     right: -4,
        //     child: Container(
        //       padding: const EdgeInsets.all(4),
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         shape: BoxShape.circle,
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.black.withOpacity(0.2),
        //             blurRadius: 4,
        //             offset: const Offset(0, 2),
        //           )
        //         ],
        //       ),
        //       child: Container(
        //         padding: const EdgeInsets.all(2),
        //         decoration: const BoxDecoration(
        //           color: AppColors.accentColor,
        //           shape: BoxShape.circle,
        //         ),
        //         child: const Icon(
        //           Icons.verified,
        //           color: Colors.white,
        //           size: 14,
        //         ),
        //       ),
        //     ),
        //   ),
      
      ],
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
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
