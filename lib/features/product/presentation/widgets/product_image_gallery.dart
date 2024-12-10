import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductImageGallery extends StatefulWidget {
  final ProductModel product;
  

  const ProductImageGallery({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Stack(
          children: [
            // Main Image Display
            Hero(
              tag: widget.product.id,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey.withOpacity(.1)
                        : AppColors.accentColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.grey.withOpacity(.1)
                          : AppColors.accentColor.withOpacity(.1),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.product.imageUrls[_currentImageIndex],
                      fit: BoxFit.cover,
                      errorWidget: (context, error, stackTrace) => Icon(
                        Icons.error,
                        size: 64,
                        color: isDarkMode
                            ? AppColors.accentColor
                            : AppColors.accentColorDark,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Favorite Icon
            BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, favoritesState) {
                final isFavorite = favoritesState.isFavorite(widget.product);
                return Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_outline,
                        size: 35,
                      ),
                      color: AppColors.primaryColor,
                      onPressed: () {
                        if (isFavorite) {
                          context.read<FavoritesBloc>().add(
                              RemoveFromFavoritesEvent(
                                  product: widget.product));
                        } else {
                          context.read<FavoritesBloc>().add(
                              AddToFavoritesEvent(product: widget.product));
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Thumbnails Row
        if (widget.product.imageUrls.length > 1)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                widget.product.imageUrls.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _currentImageIndex == index
                            ? AppColors.primaryColor
                            : Colors.grey.withOpacity(0.5),
                        width: 2,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.product.imageUrls[index]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
