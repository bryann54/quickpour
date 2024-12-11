
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
import 'package:chupachap/features/product/presentation/pages/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final cartBloc = context.read<CartBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardColorDark : AppColors.cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.backgroundDark.withOpacity(.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(
                    product: cartItem.product,
                    initialQuantity: cartItem.quantity,
                    onQuantityChanged: (newQuantity) {},
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Product Image
                  Hero(
                    tag: 'product_image_${cartItem.product.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: cartItem.product.imageUrls.first,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator.adaptive()),
                        errorWidget: (context, url, error) => Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.backgroundDark.withOpacity(.2)
                                  : AppColors.accentColor.withOpacity(.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.error,
                              color: isDarkMode
                                  ? Colors.grey
                                  : AppColors.accentColor,
                            )),
                      ),
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
                            color: isDarkMode ? AppColors.surface.withOpacity(.5) : Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDarkMode
                                      ? Colors.white
                                      : AppColors.accentColor,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.grey[
                                    200], // Set a background color in case the image fails to load
                                child: CachedNetworkImage(
                                  imageUrl: cartItem.product.category.imageUrl,
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    radius: 10,
                                    backgroundImage: imageProvider,
                                  ),
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.error,
                                    color: AppColors.accentColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              cartItem.product.category.name,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDarkMode
                                    ? AppColors.surface.withOpacity(.5)
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'KSh ${cartItem.product.price.toStringAsFixed(2)} ',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quantity Control
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.dividerColor.withOpacity(.2)
                          : AppColors.textSecondary.withOpacity(.3),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline,
                              color: cartItem.quantity > 1
                                  ? (isDarkMode ? Colors.white : Colors.black)
                                  : Colors.grey),
                          onPressed: cartItem.quantity > 1
                              ? () {
                                  cartBloc.add(
                                    UpdateCartQuantityEvent(
                                      product: cartItem.product,
                                      quantity: cartItem.quantity - 1,
                                    ),
                                  );
                                }
                              : () {
                                  cartBloc.add(
                                    RemoveFromCartEvent(
                                        product: cartItem.product),
                                  );
                                },
                        ),
                        Text(
                          '${cartItem.quantity}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline,
                              color: isDarkMode
                                  ? AppColors.accentColor
                                  : AppColors.accentColorDark),
                          onPressed: () {
                            cartBloc.add(
                              UpdateCartQuantityEvent(
                                product: cartItem.product,
                                quantity: cartItem.quantity + 1,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1, end: 0);
  }
}
