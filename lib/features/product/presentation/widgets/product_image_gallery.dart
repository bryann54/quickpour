import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            Hero(
              tag:
                  'product-image-${widget.product.id}', // Updated to match ProductCard
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey.withValues(alpha: .1)
                        : AppColors.accentColor.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.grey.withValues(alpha: .1)
                          : AppColors.accentColor.withValues(alpha: .1),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.product.imageUrls[_currentImageIndex],
                    fit: BoxFit
                        .contain, // Changed to contain to match ProductCard
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
            if (widget.product.discountPrice > 0 &&
                widget.product.discountPrice < widget.product.price)
              Positioned(
                top: 0,
                left: 0,
                child: Hero(
                  tag: 'product-badge-${widget.product.id}',
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.red, Colors.orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      // borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.tag,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${calculateDiscountPercentage(widget.product.price, widget.product.discountPrice)}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            // Price details with Hero animation
            Positioned(
              bottom: 10,
              left: 10,
              child: Row(
                children: [
                  if (widget.product.discountPrice > 0 &&
                      widget.product.discountPrice < widget.product.price)
                    Hero(
                      tag:
                          'product-price-${widget.product.id}', // Added Hero animation for price
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          'KSH ${formatMoney(widget.product.discountPrice)}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.accentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  if (widget.product.discountPrice > 0 &&
                      widget.product.discountPrice < widget.product.price) ...[
                    const SizedBox(width: 8),
                    Text(
                      'KSH ${formatMoney(widget.product.price)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.red,
                          ),
                    ),
                  ],
                  if (!(widget.product.discountPrice > 0 &&
                      widget.product.discountPrice < widget.product.price))
                    Hero(
                      tag: 'product-price-${widget.product.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          'KSH ${formatMoney(widget.product.price)}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accentColor,
                                  ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Favorite Icon
            Positioned(
              top: 10,
              right: 5,
              child: BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  final isFavorite = state.isFavorite(widget.product);
                  return Hero(
                    tag: 'product-favorite-${widget.product.id}',
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Material(
                        color: isFavorite
                            ? AppColors.accentColor
                            : (isDarkMode
                                ? AppColors.brandPrimary.withValues(alpha: .5)
                                : AppColors.background.withValues(alpha: 0.9)),
                        shape: const CircleBorder(),
                        elevation: 1,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            if (isFavorite) {
                              context.read<FavoritesBloc>().add(
                                    RemoveFromFavoritesEvent(
                                        product: widget.product),
                                  );
                            } else {
                              context.read<FavoritesBloc>().add(
                                    AddToFavoritesEvent(
                                        product: widget.product),
                                  );
                            }
                          },
                          child: Center(
                            child: FaIcon(
                              isFavorite
                                  ? FontAwesomeIcons.solidHeart
                                  : FontAwesomeIcons.heart,
                              size: 24,
                              color: isFavorite
                                  ? Colors.white
                                  : (isDarkMode
                                      ? AppColors.accentColor
                                      : AppColors.backgroundDark
                                          .withValues(alpha: .3)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
                            : Colors.grey.withValues(alpha: 0.5),
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
