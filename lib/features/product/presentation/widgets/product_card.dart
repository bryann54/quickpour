import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/features/product/presentation/pages/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

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

    return GestureDetector(
      onTap: () {
        Future.microtask(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                product: product,
                initialQuantity: 1,
                onQuantityChanged: (quantity) {},
              ),
            ),
          );
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 14.5 / 9,
                  child: Hero(
                    tag: 'product-${product.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: product.imageUrls.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: product.imageUrls[0],
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator.adaptive()),
                              errorWidget: (context, url, error) =>
                                  const Center(child: Icon(Icons.error)),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.image, color: Colors.grey),
                              ),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        style: theme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.categoryName,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'KSH ${product.discountPrice > 0 && product.discountPrice < product.price ? product.discountPrice.toStringAsFixed(0) : product.price.toStringAsFixed(0)}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: product.discountPrice > 0 &&
                                      product.discountPrice < product.price
                                  ? AppColors.accentColor
                                  : theme.textTheme.titleSmall?.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (product.discountPrice > 0 &&
                              product.discountPrice < product.price) ...[
                            const SizedBox(width: 8),
                            Text(
                              'KSH ${product.price.toStringAsFixed(0)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (!product.isAvailable)
                        Text(
                          'Out of Stock',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (product.discountPrice > 0 &&
                          product.discountPrice < product.price &&product.isAvailable) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.red, Colors.orangeAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            // borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.local_offer_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_calculateDiscountPercentage(product.price, product.discountPrice)}% OFF',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.accentColor.withOpacity(.8),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    final cartItem = state is CartLoadedState
                        ? state.cart.items.firstWhere(
                            (item) => item.product.id == product.id,
                            orElse: () =>
                                CartItem(product: product, quantity: 0),
                          )
                        : CartItem(product: product, quantity: 0);

                    if (cartItem.quantity > 0) {
                      return Container(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.background
                              : Colors.white.withOpacity(.8),
                          border: Border.all(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.background
                                    : AppColors.accentColor.withOpacity(.2),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const FaIcon(FontAwesomeIcons.circleMinus),
                              onPressed: () {
                                final newQuantity = cartItem.quantity > 1
                                    ? cartItem.quantity - 1
                                    : 0;
                                context.read<CartBloc>().add(
                                      UpdateCartQuantityEvent(
                                        product: product,
                                        quantity: newQuantity,
                                      ),
                                    );
                              },
                            ),
                            Text(
                              '${cartItem.quantity}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.circlePlus,
                                color: AppColors.accentColor,
                              ),
                              onPressed: () {
                                context.read<CartBloc>().add(
                                      UpdateCartQuantityEvent(
                                        product: product,
                                        quantity: cartItem.quantity + 1,
                                      ),
                                    );
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return IconButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                                AddToCartEvent(product: product, quantity: 1),
                              );
                        },
                        icon: const Icon(
                          FontAwesomeIcons.cartShopping,
                          color: Colors.white,
                          size: 18,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  final isFavorite = state.isFavorite(product);
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFavorite
                          ? AppColors.accentColor
                          : Colors.transparent,
                      border: Border.all(
                        color: isFavorite
                            ? AppColors.accentColor
                            : AppColors.backgroundDark.withOpacity(0.1),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFavorite
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        color: isFavorite ? Colors.white : Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        if (isFavorite) {
                          context.read<FavoritesBloc>().add(
                                RemoveFromFavoritesEvent(product: product),
                              );
                        } else {
                          context.read<FavoritesBloc>().add(
                                AddToFavoritesEvent(product: product),
                              );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
