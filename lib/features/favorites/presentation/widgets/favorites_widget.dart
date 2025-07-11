import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/favorites/data/models/favorites_model.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:chupachap/features/product/presentation/pages/product_details_screen.dart';
import 'package:chupachap/features/product/presentation/widgets/cart_quantityFAB.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesWidget extends StatelessWidget {
  final FavoriteItem favoriteItem;

  const FavoritesWidget({Key? key, required this.favoriteItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
      child: Container(
        decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.grey[900]!.withValues(alpha: .7)
                : AppColors.cardColor.withValues(alpha: .7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode
                  ? Colors.grey[900]!.withValues(alpha: .7)
                  : AppColors.backgroundDark.withValues(alpha: .15),
            )
            // boxShadow: isDarkMode
            //     ? [
            //         BoxShadow(
            //           color: AppColors.background.withValues(alpha: 0.3),
            //           spreadRadius: 2,
            //           blurRadius: 2,
            //           offset: const Offset(0, 1),
            //         ),
            //       ]
            //     : [
            //         BoxShadow(
            //           color: Colors.black.withValues(alpha: 0.3),
            //           spreadRadius: 1,
            //           blurRadius: .5,
            //           offset: const Offset(0, 3),
            //         ),
            //       ],
            ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                  product: favoriteItem.product,
                  initialQuantity: 0,
                  onQuantityChanged: (newQuantity) {},
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'product-image-${favoriteItem.product.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: favoriteItem.product.imageUrls.isNotEmpty
                              ? favoriteItem.product.imageUrls.first
                              : '',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator.adaptive(),
                          errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppColors.backgroundDark
                                        .withValues(alpha: .5)
                                    : AppColors.background,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.error, size: 20)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Hero(
                                  tag:
                                      'product-name-${favoriteItem.product.id}',
                                  child: Text(
                                    favoriteItem.product.productName,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isDarkMode
                                          ? AppColors.surface
                                              .withValues(alpha: .8)
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            favoriteItem.product.brandName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: isDarkMode
                                  ? AppColors.surface.withValues(alpha: .6)
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (favoriteItem.product.discountPrice > 0 &&
                                  favoriteItem.product.discountPrice <
                                      favoriteItem.product.price)
                                Text(
                                  'Ksh ${formatMoney(favoriteItem.product.discountPrice)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.accentColor,
                                  ),
                                ),
                              if (favoriteItem.product.discountPrice > 0 &&
                                  favoriteItem.product.discountPrice <
                                      favoriteItem.product.price)
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'was ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              if (favoriteItem.product.discountPrice > 0 &&
                                  favoriteItem.product.discountPrice <
                                      favoriteItem.product.price)
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Ksh ${formatMoney(favoriteItem.product.price)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                              if (favoriteItem.product.discountPrice <= 0 ||
                                  favoriteItem.product.discountPrice >=
                                      favoriteItem.product.price)
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Ksh ${formatMoney(favoriteItem.product.price)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.accentColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode
                          ? AppColors.backgroundDark.withValues(alpha: 0.5)
                          : AppColors.backgroundDark.withValues(alpha: 0.4),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.cancel_outlined,
                        size: 20,
                        color: isDarkMode
                            ? Colors.grey.shade300
                            : Colors.grey.shade300,
                      ),
                      onPressed: () {
                        context.read<FavoritesBloc>().add(
                              RemoveFromFavoritesEvent(
                                  product: favoriteItem.product),
                            );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: CartQuantityFAB(
                    product: favoriteItem.product,
                    isDarkMode: isDarkMode,
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
