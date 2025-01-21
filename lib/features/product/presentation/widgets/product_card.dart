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
      child: Card(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Hero(
                    tag: 'product-${product.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: product.imageUrls.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: product.imageUrls[0],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product.productName,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Brand Name
                      Text(
                        product.brandName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      // Price Section
                      Row(
                        children: [
                          Text(
                            'KSH ${product.discountPrice > 0 && product.discountPrice < product.price ? product.discountPrice.toStringAsFixed(0) : product.price.toStringAsFixed(0)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: product.discountPrice > 0 &&
                                          product.discountPrice < product.price
                                      ? AppColors.accentColor
                                      : Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.color,
                                  fontWeight: FontWeight.bold,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (product.discountPrice > 0 &&
                              product.discountPrice < product.price) ...[
                            const SizedBox(width: 28),
                            Expanded(
                              child: Text(
                                'KSH ${product.price.toStringAsFixed(0)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                      // Out of Stock Message
                      if (!product.isAvailable)
                        Text(
                          'Out of Stock',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.red),
                        ),
                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: BlocBuilder<CartBloc, CartState>(
                              builder: (context, cartState) {
                                // Check if the product is already in the cart
                                final cartItem =
                                    cartState.cart.items.firstWhere(
                                  (item) => item.product.id == product.id,
                                  orElse: () =>
                                      CartItem(product: product, quantity: 0),
                                );

                                return cartItem.quantity == 0
                                    ? ElevatedButton(
                                        onPressed: () {
                                          context.read<CartBloc>().add(
                                                AddToCartEvent(
                                                    product: product,
                                                    quantity: 1),
                                              );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              const Size(double.infinity, 40),
                                        ),
                                        child: const Text('Add to Cart'),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: isDarkMode
                                                    ? AppColors.background
                                                    : AppColors.accentColor),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(
                                              width: 13,
                                            ),
                                            IconButton(
                                              icon: const FaIcon(
                                                  FontAwesomeIcons.circleMinus),
                                              onPressed: () {
                                                final newQuantity =
                                                    cartItem.quantity > 1
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
                                            // Display Quantity
                                            Text(
                                              '${cartItem.quantity}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                            // Quantity Increase Button
                                            IconButton(
                                              icon: const FaIcon(
                                                FontAwesomeIcons.circlePlus,
                                                color: AppColors.accentColor,
                                              ),
                                              onPressed: () {
                                                context.read<CartBloc>().add(
                                                      UpdateCartQuantityEvent(
                                                        product: product,
                                                        quantity:
                                                            cartItem.quantity +
                                                                1,
                                                      ),
                                                    );
                                              },
                                            ),
                                            const SizedBox(
                                              width: 13,
                                            ),
                                          ],
                                        ),
                                      );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (product.discountPrice > 0 &&
                product.discountPrice < product.price) ...[
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_calculateDiscountPercentage(product.price, product.discountPrice)}% OFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    final isFavorite = state.isFavorite(product);
                    return IconButton(
                      icon: Icon(
                        isFavorite
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        color: isFavorite ? AppColors.accentColor : Colors.grey,
                        size: 22,
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
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
