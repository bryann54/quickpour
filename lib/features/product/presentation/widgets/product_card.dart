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
    if (originalPrice <= 0 || discountPrice <= 0) return 0;
    return ((originalPrice - discountPrice) / originalPrice * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Product Image
                CachedNetworkImage(
                  imageUrl: product.imageUrls.isNotEmpty
                      ? product.imageUrls.first
                      : 'assets/111.png',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 150,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),

                // Cart Controls
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentColor.withOpacity(0.5),
                          blurRadius: 2,
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
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.background
                                  : null,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const FaIcon(
                                      FontAwesomeIcons.circleMinus),
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.backgroundDark
                                      : AppColors.background,
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
                                    AddToCartEvent(
                                        product: product, quantity: 1),
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

                // Favorites Button
                Positioned(
                  top: 0,
                  right: 0,
                  child: BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, state) {
                      final isFavorite = state.isFavorite(product);
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFavorite
                              ? AppColors.accentColor
                              : Colors.white.withOpacity(0.8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.all(8),
                        child: IconButton(
                          icon: Icon(
                            isFavorite
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            color: isFavorite
                                ? Colors.white
                                : AppColors.accentColor,
                            size: 18,
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

                // Discount Tag
                if (product.discountPrice < product.price)
                  Positioned(
                    bottom: 0,
                    right: 60,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.red, Colors.orange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
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
                            '${_calculateDiscountPercentage(product.price, product.discountPrice)}% OFF',
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
              ],
            ),
    Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      product.productName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4), // Add spacing between texts
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      product.categoryName,
                      style: const TextStyle(
                        fontSize: 14,
                        color:
                            Colors.grey, // Added color for better distinction
                      ),
                      maxLines: 1, // Reduced to 1 line to save space
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8), // Add spacing before prices
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Ksh ${product.discountPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentColor,
                          ),
                        ),
                      ),
                      if (product.discountPrice < product.price)
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Ksh ${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ), ],
        ),
      ),
    );
  }
}
