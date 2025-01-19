import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/features/product/presentation/widgets/cart_footer.dart';
import 'package:chupachap/features/product/presentation/widgets/merchants_details_section.dart';
import 'package:chupachap/features/product/presentation/widgets/product_details_header.dart';
import 'package:chupachap/features/product/presentation/widgets/product_image_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;
  final int initialQuantity;
  final ValueChanged<int> onQuantityChanged;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
    required this.initialQuantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late int quantity;
  int _calculateDiscountPercentage(double originalPrice, double discountPrice) {
    if (originalPrice <= 0 || discountPrice <= 0) {
      return 0; // Handle invalid values gracefully
    }
    final discount = ((originalPrice - discountPrice) / originalPrice) * 100;
    return discount.round(); // Return rounded discount percentage
  }

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity >= 0) {
      // Add validation
      setState(() {
        quantity = newQuantity;
      });
      widget.onQuantityChanged(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        // Update quantity if cart state changes
        if (state is CartLoadedState) {
          final cartItem = state.cart.items.firstWhere(
            (item) => item.product.id == widget.product.id,
            orElse: () => CartItem(product: widget.product, quantity: 0),
          );
          if (cartItem.quantity != quantity) {
            setState(() {
              quantity = cartItem.quantity;
            });
          }
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          showNotification: true,
          showProfile: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.product.imageUrls.isNotEmpty)
                        ProductImageGallery(product: widget.product)
                      else
                        Stack(children: [
                          Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image,
                                  size: 50, color: Colors.grey),
                            ),
                          ),

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
                                  final isFavorite =
                                      state.isFavorite(widget.product);
                                  return IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? FontAwesomeIcons.solidHeart
                                          : FontAwesomeIcons.heart,
                                      color: isFavorite
                                          ? AppColors.accentColor
                                          : Colors.grey,
                                      size: 22,
                                    ),
                                    onPressed: () {
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
                                  );
                                },
                              ),
                            ),
                          ),
                          if (widget.product.discountPrice > 0 &&
                              widget.product.discountPrice <
                                  widget.product.price)
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${_calculateDiscountPercentage(widget.product.price, widget.product.discountPrice)}% OFF',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ),
                          // Price details
                          Positioned(
                            bottom: 10,
                            left: 140,
                            child: Row(
                              children: [
                                Text(
                                  'KSH ${widget.product.discountPrice > 0 && widget.product.discountPrice < widget.product.price ? widget.product.discountPrice.toStringAsFixed(0) : widget.product.price.toStringAsFixed(0)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: widget.product.discountPrice >
                                                    0 &&
                                                widget.product.discountPrice <
                                                    widget.product.price
                                            ? AppColors.accentColor
                                            : Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (widget.product.discountPrice > 0 &&
                                    widget.product.discountPrice <
                                        widget.product.price) ...[
                                  const SizedBox(width: 28),
                                  Expanded(
                                    child: Text(
                                      'KSH ${widget.product.price.toStringAsFixed(0)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ]),
                      const SizedBox(height: 20),
                      ProductDetailsHeader(product: widget.product),
                      const SizedBox(height: 20),
                      MerchantsDetailsSection(product: widget.product),
                    ],
                  ),
                ),
              ),
            ),
            CartFooter(
              product: widget.product,
              currentQuantity: quantity,
              onQuantityChanged: _updateQuantity,
            ),
          ],
        ),
      ),
    );
  }
}
