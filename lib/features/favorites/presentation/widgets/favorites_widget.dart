
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
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.cardColorDark.withOpacity(0.2)
              : AppColors.cardColor.withOpacity(.7),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: favoriteItem.product.imageUrls.first,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          title: Column(
            children: [
              Row(
                children: [
                  Text(
                    favoriteItem.product.productName,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isDarkMode ? Colors.white : AppColors.accentColor,
                        )),
                    child: CircleAvatar(
                      radius: 10,
                      backgroundImage: CachedNetworkImageProvider(
                          favoriteItem.product.category.imageUrl),
                    ),
                  ),
                  Text(
                    '  ${favoriteItem.product.category.name}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Text(
            'KSh ${favoriteItem.product.price.toStringAsFixed(2)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
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
          trailing: IconButton(
            icon: Icon(
              Icons.delete_rounded,
              color: isDarkMode
                  ? AppColors.cardColor.withOpacity(0.7)
                  : AppColors.accentColor,
            ),
            onPressed: () {
              context.read<FavoritesBloc>().add(
                    RemoveFromFavoritesEvent(product: favoriteItem.product),
                  );
            },
          ),
        ),
      ),
    );
  }
}
