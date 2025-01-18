import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_state.dart';
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

  int _calculateDiscountPercentage(double originalPrice, double discountPrice) {
    if (originalPrice <= 0 || discountPrice <= 0) {
      return 0; // Handle invalid values gracefully
    }
    final discount = ((originalPrice - discountPrice) / originalPrice) * 100;
    return discount.round(); // Return rounded discount percentage
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Stack(
          children: [
            Hero(
              tag: widget.product.id, // Unique tag for hero animation
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
            // Discount Tag
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_calculateDiscountPercentage(widget.product.price, widget.product.discountPrice)}% OFF',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
              // Price details
            Positioned(
              bottom: 10,
              left: 100,
              child: Row(
                children: [
                  if (widget.product.discountPrice > 0)
                    Text(
                      'KSH ${widget.product.discountPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  if (widget.product.discountPrice > 0) ...[
                    const SizedBox(width: 8),
                    Text(
                      'KSH ${widget.product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                    ),
                  ],
                  if (widget.product.discountPrice <= 0)
                    Text(
                      'KSH ${widget.product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                ],
              ),
            ),
                         
            // Favorite Icon (Similar to the original code)
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
                      color: AppColors.accentColor,
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
        // Thumbnails Row for Image Selection (Similar to the original code)
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
