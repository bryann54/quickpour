import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MerchantsDetailsSection extends StatelessWidget {
  final ProductModel product;

  const MerchantsDetailsSection({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'store',
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.accentColor.withOpacity(.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _buildmerchantsAvatar(),
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.merchants.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                     Text(
                      product.merchants.location,
                      style: theme.textTheme.bodyLarge?.copyWith(
                         color: AppColors.primaryColor.withOpacity(.4),
                      ),
                    ),
                  ],
                ),
              ),
              _buildmerchantsRating(context, isDarkMode),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildmerchantsAvatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
      Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 25,
            
            backgroundImage:
                NetworkImage(product.merchants.imageUrl.toString()),
            child: CachedNetworkImage(
              imageUrl: product.merchants.imageUrl.toString(),
              imageBuilder: (context, imageProvider) {
                return CircleAvatar(
                  radius: 25,
                  backgroundImage: imageProvider,
                );
              },
              errorWidget: (context, url, error) {
                return const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(
                      'assets/placeholder_image.png'), 
                  child: FaIcon(
                    FontAwesomeIcons.houseChimneyWindow,
                    size: 20, 
                  ),
                );
              },
            ),
          ),
        ),

        if (product.merchants.isVerified)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
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

  Widget _buildmerchantsRating(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : AppColors.accentColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
