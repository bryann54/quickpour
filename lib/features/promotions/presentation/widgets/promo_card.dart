import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PromotionCard extends StatelessWidget {
  final ProductModel product;

  const PromotionCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: product.imageUrls.isNotEmpty
                    ? product.imageUrls.first
                    : 'assets/111.png',
                fit: BoxFit.contain,
                width: double.infinity,
                height: 200,
                errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: 130,
                    color: isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade100,
                    child: const Icon(Icons.error)),
              ),
              Positioned(
                top: 0,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.withOpacity(.4)
                        : AppColors.accentColor,
                    // borderRadius: BorderRadius.circular(12),
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
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.background
                                    : null,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon:
                                    const FaIcon(FontAwesomeIcons.circleMinus),
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
                                icon: FaIcon(
                                  FontAwesomeIcons.circlePlus,
                                  color: isDarkMode
                                      ? AppColors.accentColor
                                      : AppColors.background,
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
                          icon: Icon(
                            FontAwesomeIcons.cartShopping,
                            color: isDarkMode
                                ? AppColors.accentColorDark
                                : Colors.white,
                            size: 18,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
              if (product.discountPrice < product.price)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
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
                Text(
                  product.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  product.categoryName,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ksh ${product.discountPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentColor,
                      ),
                    ),
                    if (product.discountPrice < product.price)
                      Text(
                        'Ksh ${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateDiscountPercentage(double originalPrice, double discountPrice) {
    if (originalPrice <= 0 || discountPrice <= 0) return 0;
    return ((originalPrice - discountPrice) / originalPrice * 100).round();
  }
}
