import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/product/presentation/pages/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({Key? key, required this.cartItem}) : super(key: key);

  int _calculateDiscountPercentage(double originalPrice, double discountPrice) {
    if (originalPrice <= 0 || discountPrice <= 0) return 0;
    return ((originalPrice - discountPrice) / originalPrice * 100).round();
  }

  void _showQuantitySelector(BuildContext context, CartBloc cartBloc) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor:
          isDarkMode ? AppColors.cardColorDark : AppColors.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Quantity',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  for (int i = 1; i <= 25; i += i < 5 ? 1 : 5)
                    _buildQuantityButton(context, i, cartBloc),
                ],
              ),
              const SizedBox(height: 16),
              _buildCustomQuantityInput(context, cartBloc),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuantityButton(
      BuildContext context, int quantity, CartBloc cartBloc) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        cartBloc.add(UpdateCartQuantityEvent(
          product: cartItem.product,
          quantity: quantity,
        ));
        Navigator.pop(context);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: quantity == cartItem.quantity
              ? AppColors.accentColor
              : (isDarkMode ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$quantity',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: quantity == cartItem.quantity
                  ? Colors.white
                  : (isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomQuantityInput(BuildContext context, CartBloc cartBloc) {
    final theme = Theme.of(context);
    final customQuantityController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: customQuantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Custom Quantity',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            final input = customQuantityController.text;
            if (input.isNotEmpty) {
              final quantity = int.tryParse(input);
              if (quantity != null && quantity > 0) {
                cartBloc.add(UpdateCartQuantityEvent(
                  product: cartItem.product,
                  quantity: quantity,
                ));
                Navigator.pop(context);
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Apply',
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
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
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardColorDark : AppColors.cardColor,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          border: Border.all(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            Hero(
              tag: 'product-image-${cartItem.product.id}',
              child: ClipRRect(
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.grey.shade500.withOpacity(.2)
                            : Colors.grey.shade200.withOpacity(.6),
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: cartItem.product.imageUrls.isNotEmpty
                          ? cartItem.product.imageUrls.first
                          : 'fallback_image_url',
                      width: 120,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator.adaptive()),
                      errorWidget: (context, url, error) => Container(
                        width: 120,
                        height: 100,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error,
                            color: AppColors.backgroundDark),
                      ),
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
            const SizedBox(width: 20),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'product_name_${cartItem.product.id}',
                    child: Text(
                      cartItem.product.productName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
                  ),
                  const SizedBox(height: 5),
                  // New Quantity Control in Row Layout
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: isDarkMode
                              ? AppColors.accentColor.withOpacity(0.3)
                              : Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Decrease button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            onTap: cartItem.quantity > 1
                                ? () {
                                    cartBloc.add(UpdateCartQuantityEvent(
                                      product: cartItem.product,
                                      quantity: cartItem.quantity - 1,
                                    ));
                                  }
                                : () {
                                    cartBloc.add(RemoveFromCartEvent(
                                      product: cartItem.product,
                                    ));
                                  },
                            child: Container(
                              width: 36,
                              height: 40,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.remove,
                                size: 18,
                                color: cartItem.quantity > 1
                                    ? (isDarkMode ? Colors.white : Colors.black)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        // Quantity display
                        Container(
                          constraints: const BoxConstraints(minWidth: 40),
                          alignment: Alignment.center,
                          child: Text(
                            '${cartItem.quantity}',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Increase button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(0),
                            onTap: () {
                              cartBloc.add(UpdateCartQuantityEvent(
                                product: cartItem.product,
                                quantity: cartItem.quantity + 1,
                              ));
                            },
                            child: Container(
                              width: 36,
                              height: 40,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.add,
                                size: 18,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // Dropdown for quick quantity selection
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            onTap: () =>
                                _showQuantitySelector(context, cartBloc),
                            child: Container(
                              width: 36,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.accentColor.withOpacity(0.1),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: isDarkMode
                                    ? AppColors.accentColor
                                    : AppColors.accentColorDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
