import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/favorites/data/models/favorites_model.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:chupachap/features/product/presentation/pages/product_details_screen.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey[900]!.withOpacity(.7)
              : AppColors.cardColor.withOpacity(.7),
          borderRadius: BorderRadius.circular(15),
          boxShadow: isDarkMode
              ? [
                  BoxShadow(
                    color: AppColors.background.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 3),
                  ),
                ],
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
            child: Row(
              children: [
                ClipRRect(
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
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 40),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        favoriteItem.product.productName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDarkMode
                              ? AppColors.surface.withOpacity(.8)
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        favoriteItem.product.brandName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: isDarkMode
                              ? AppColors.surface.withOpacity(.6)
                              : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (favoriteItem.product.discountPrice > 0 &&
                              favoriteItem.product.discountPrice <
                                  favoriteItem.product.price)
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Ksh ${favoriteItem.product.discountPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentColor,
                                ),
                              ),
                            ),
                          if (favoriteItem.product.discountPrice > 0 &&
                              favoriteItem.product.discountPrice <
                                  favoriteItem.product.price)
                            const Text(
                              'was ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          if (favoriteItem.product.discountPrice > 0 &&
                              favoriteItem.product.discountPrice <
                                  favoriteItem.product.price)
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Ksh ${favoriteItem.product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 16,
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
                                'Ksh ${favoriteItem.product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
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
                Container(
                 
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: isDarkMode
                        ? AppColors.surface.withOpacity(.4)
                        : AppColors.backgroundDark.withOpacity(.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel_outlined,
                      size: 30,
                      color: isDarkMode
                          ? AppColors.backgroundDark.withOpacity(0.8)
                          : Colors.grey,
                    ),
                    onPressed: () {
                      context.read<FavoritesBloc>().add(
                            RemoveFromFavoritesEvent(
                                product: favoriteItem.product),
                          );
                    },
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
