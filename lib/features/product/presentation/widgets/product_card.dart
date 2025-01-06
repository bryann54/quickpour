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

class ProductCard extends StatefulWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.8, -0.5),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _triggerAddToCartAnimation() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final cartItem = cartState.cart.items.firstWhere(
            (item) => item.product.id == widget.product.id,
            orElse: () => CartItem(product: widget.product, quantity: 0));

        return BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, favoritesState) {
            final isFavorite = favoritesState.isFavorite(widget.product);

            return Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey.withOpacity(.2)
                    : AppColors.cardColor,
                border:
                    Border.all(color: AppColors.accentColor.withOpacity(.5)),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Main Card Content
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            product: widget.product,
                            initialQuantity: cartItem.quantity,
                            onQuantityChanged: (newQuantity) {
                              context.read<CartBloc>().add(
                                  UpdateCartQuantityEvent(
                                      product: widget.product,
                                      quantity: newQuantity));
                            },
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Transform.translate(
                                offset: _slideAnimation.value * 100,
                                child: Opacity(
                                  opacity: 1.0 - _animationController.value,
                                  child: SizedBox(
                                    height: 135,
                                    width: double.infinity,
                                    child: Hero(
                                      tag: widget.product.id,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              widget.product.imageUrls.first,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator
                                                          .adaptive()),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                  height: 135,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: isDarkMode
                                                        ? Colors.grey
                                                            .withOpacity(.1)
                                                        : AppColors.accentColor
                                                            .withOpacity(.1),
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15),
                                                      topRight:
                                                          Radius.circular(15),
                                                    ),
                                                  ),
                                                  child: Icon(
                                                    Icons.error,
                                                    color: isDarkMode
                                                        ? AppColors.accentColor
                                                        : AppColors
                                                            .accentColorDark,
                                                    size: 40,
                                                  )),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        // Product Details
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.productName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
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
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          cartItem.product.merchants.imageUrl,
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        radius: 10,
                                        backgroundImage: imageProvider,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        height: 135,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: isDarkMode
                                              ? Colors.grey.withOpacity(.1)
                                              : AppColors.accentColor
                                                  .withOpacity(.1),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.error,
                                          color: isDarkMode
                                              ? AppColors.accentColor
                                              : AppColors.accentColorDark,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3.0),
                                    child: Text(
                                      cartItem.product.merchants.name,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: isDarkMode
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'KSh ${(widget.product.price).toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.tealAccent
                                        : AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 2),

// Cart Interaction
                              cartItem.quantity > 0
                                  ? Container(
                                      width: double.infinity,
                                      constraints:
                                          const BoxConstraints(maxHeight: 40),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: isDarkMode
                                                ? Colors.grey[700]!
                                                : Colors.grey[300]!),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: FaIcon(
                                              FontAwesomeIcons.circleMinus,
                                              size: 24,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.grey[400],
                                            ),
                                            onPressed: () {
                                              if (cartItem.quantity > 1) {
                                                context.read<CartBloc>().add(
                                                      UpdateCartQuantityEvent(
                                                        product: widget.product,
                                                        quantity:
                                                            cartItem.quantity -
                                                                1,
                                                      ),
                                                    );
                                              } else {
                                                context.read<CartBloc>().add(
                                                      RemoveFromCartEvent(
                                                          product:
                                                              widget.product),
                                                    );
                                              }
                                            },
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                '${cartItem.quantity}',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: FaIcon(
                                              FontAwesomeIcons.circlePlus,
                                              size: 24,
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : AppColors.accentColor,
                                            ),
                                            onPressed: () {
                                              context.read<CartBloc>().add(
                                                    UpdateCartQuantityEvent(
                                                      product: widget.product,
                                                      quantity:
                                                          cartItem.quantity + 1,
                                                    ),
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      height: 40,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                        ),
                                        onPressed: () {
                                          _triggerAddToCartAnimation();
                                          Future.delayed(
                                              const Duration(milliseconds: 300),
                                              () {
                                            context.read<CartBloc>().add(
                                                AddToCartEvent(
                                                    product: widget.product,
                                                    quantity: 1));
                                          });
                                        },
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: const Text(
                                            'Add to Cart',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Favorite Button (Top Right)
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
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color:
                              isFavorite ? AppColors.accentColor : Colors.grey,
                          size: 22,
                        ),
                        onPressed: () {
                          if (isFavorite) {
                            context.read<FavoritesBloc>().add(
                                RemoveFromFavoritesEvent(
                                    product: widget.product));
                          } else {
                            context.read<FavoritesBloc>().add(
                                AddToFavoritesEvent(product: widget.product));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
