import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/product/presentation/pages/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({Key? key, required this.cartItem}) : super(key: key);

  int _calculateDiscountPercentage(double originalPrice, double discountPrice) {
    if (originalPrice <= 0 || discountPrice <= 0) return 0;
    return ((originalPrice - discountPrice) / originalPrice * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cartBloc = context.read<CartBloc>();
    context.read<FavoritesBloc>();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              product: cartItem.product,
              initialQuantity: cartItem.quantity,
              onQuantityChanged: (quantity) {},
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        color: isDarkMode ? AppColors.cardColorDark : AppColors.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product Image
              Hero(
                tag: 'product_image_${cartItem.product.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(children: [
                    CachedNetworkImage(
                      imageUrl: cartItem.product.imageUrls.isNotEmpty
                          ? cartItem.product.imageUrls.first
                          : 'fallback_image_url', // Provide a fallback URL
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator.adaptive()),
                      errorWidget: (context, url, error) => Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error,
                            color: AppColors.backgroundDark),
                      ),
                    ),
                    if (cartItem.product.discountPrice > 0 &&
                        cartItem.product.discountPrice <
                            cartItem.product.price) ...[
                      Positioned(
                          child: Container(
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
                              '${_calculateDiscountPercentage(cartItem.product.price, cartItem.product.discountPrice)}% Off',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ))
                    ]
                  ]),
                ),
              ),
              const SizedBox(width: 12),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.product.productName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cartItem.product.brandName,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (cartItem.product.discountPrice > 0 &&
                            cartItem.product.discountPrice <
                                cartItem.product.price)
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'Ksh ${cartItem.product.discountPrice.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.accentColor,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' was ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'Ksh ${cartItem.product.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (cartItem.product.discountPrice >=
                            cartItem.product.price)
                          Expanded(
                            child: Text(
                              'Ksh ${cartItem.product.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accentColor,
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
              // Quantity Control
              Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: AppColors.accentColor.withOpacity(.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: cartItem.quantity > 1
                            ? (isDarkMode ? Colors.white : Colors.black)
                            : Colors.grey,
                      ),
                      onPressed: cartItem.quantity > 1
                          ? () {
                              cartBloc.add(UpdateCartQuantityEvent(
                                product: cartItem.product,
                                quantity: cartItem.quantity - 1,
                              ));
                            }
                          : () {
                              cartBloc.add(RemoveFromCartEvent(
                                  product: cartItem.product));
                            },
                    ),
                    Text(
                      '${cartItem.quantity}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.circlePlus,
                        color: isDarkMode
                            ? AppColors.accentColor
                            : AppColors.accentColorDark,
                      ),
                      onPressed: () {
                        cartBloc.add(UpdateCartQuantityEvent(
                          product: cartItem.product,
                          quantity: cartItem.quantity + 1,
                        ));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Favorite Icon
              // IconButton(
              //   icon: Icon(
              //     cartItem.product.isFavorite
              //         ? FontAwesomeIcons.solidHeart
              //         : FontAwesomeIcons.heart,
              //     color: cartItem.product.isFavorite
              //         ? Colors.red
              //         : (isDarkMode ? Colors.white : Colors.grey),
              //   ),
              //   onPressed: () {
              //     favoritesBloc.add(
              //       cartItem.product.isFavorite
              //           ? RemoveFromFavoritesEvent(product: cartItem.product)
              //           : AddToFavoritesEvent(product: cartItem.product),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
