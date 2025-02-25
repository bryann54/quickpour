import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/core/utils/date_formatter.dart';
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.product.imageUrls.isNotEmpty)
                      ProductImageGallery(product: widget.product)
                    else
                      Stack(children: [
                        Hero(
                          tag: 'product-image-${widget.product.id}',
                          child: Container(
                            height: 300,
                            color: isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade100,
                            child: const Center(
                              child: Icon(Icons.error,
                                  size: 50, color: Colors.grey),
                            ),
                          ),
                        ),

                        // Favorite Icon
                        Positioned(
                          top: 5,
                          right: 5,
                          child: BlocBuilder<FavoritesBloc, FavoritesState>(
                            builder: (context, state) {
                              final isFavorite =
                                  state.isFavorite(widget.product);
                              return Hero(
                                tag: 'product-favorite-${widget.product.id}',
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Material(
                                    color: isFavorite
                                        ? AppColors.accentColor
                                        : (isDarkMode
                                            ? AppColors.brandPrimary
                                                .withOpacity(.5)
                                            : AppColors.background
                                                .withOpacity(0.9)),
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
                                                      .withOpacity(.3)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        if (widget.product.discountPrice > 0 &&
                            widget.product.discountPrice < widget.product.price)
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Hero(
                              tag: 'product-badge-${widget.product.id}',
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Colors.red, Colors.orange],
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
                        // Price details
                        Positioned(
                          bottom: 10,
                          left: 100,
                          child: Hero(
                            tag: 'product-price-${widget.product.id}',
                            child: Row(
                              children: [
                                Text(
                                  'KSH ${formatMoney((widget.product.discountPrice > 0 && widget.product.discountPrice < widget.product.price) ? widget.product.discountPrice : widget.product.price)}',
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
                                  Text(
                                    'KSH ${formatMoney(widget.product.price)}',
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
                                ],
                              ],
                            ),
                          ),
                        ),
                      ]),
                    const SizedBox(height: 5),
                    ProductDetailsHeader(product: widget.product),
                    const SizedBox(height: 5),
                    MerchantsDetailsSection(product: widget.product),
                  ],
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
