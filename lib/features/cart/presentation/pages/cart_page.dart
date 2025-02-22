import 'dart:async';

import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/strings.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/cart/presentation/widgets/add_item_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/cart/presentation/widgets/cart_header.dart';
import 'package:chupachap/features/cart/presentation/widgets/cart_item_list.dart';
import 'package:chupachap/features/cart/presentation/widgets/cart_total_section.dart';
import 'package:chupachap/features/cart/presentation/widgets/cart_clear_dialog.dart';
import 'package:chupachap/features/cart/presentation/widgets/item_bottomsheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  late AnimationController _clearCartController;
  late AnimationController _animationController;
  final List<AnimationController> _itemControllers = [];
  final cartStreamController = StreamController<Cart>.broadcast();
  final List<CartItem> cartList = [];
  final AuthRepository authRepository = AuthRepository();
  double subtotal = 0;
  bool _isClearing = false;

  @override
  void initState() {
    super.initState();

    _clearCartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animationController.forward();

    if (context.read<CartBloc>().state is CartLoadedState) {
      cartList.addAll(
          (context.read<CartBloc>().state as CartLoadedState).cart.items);
      subtotal =
          (context.read<CartBloc>().state as CartLoadedState).cart.totalPrice;
    } else {
      context.read<CartBloc>().add(const LoadCartEvent());
    }
  }

  void _initializeItemControllers(int itemCount) {
    // Clear existing controllers
    for (var controller in _itemControllers) {
      controller.dispose();
    }
    _itemControllers.clear();

    // Create new controllers for each item
    for (var i = 0; i < itemCount; i++) {
      _itemControllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
        ),
      );
    }
  }

  Future<void> _clearCart() async {
    setState(() => _isClearing = true);

    // Animate items out one by one
    for (var i = _itemControllers.length - 1; i >= 0; i--) {
      await Future.delayed(const Duration(milliseconds: 50));
      _itemControllers[i].forward();
    }

    // Wait for all animations to complete
    await Future.delayed(const Duration(milliseconds: 200));

    // Animate the total section out
    await _clearCartController.forward();

    // Actually clear the cart
    if (mounted) {
      context.read<CartBloc>().add(ClearCartEvent());
    }

    // Reset animations
    _clearCartController.reset();
    for (var controller in _itemControllers) {
      controller.reset();
    }
    setState(() => _isClearing = false);
  }

  void onCartChanged(Cart updatedCart) {
    cartStreamController.add(updatedCart);
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => CartClearDialog(onClear: _clearCart),
    );
  }

  double calculateInitialRemaining() {
    // Implement your logic here
    return 5000 - subtotal;
  }

  void _showItemBottomSheet(double remainingForFreeDelivery) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ItemBottomsheet(
        initialRemainingForFreeDelivery: calculateInitialRemaining(),
        authRepository: authRepository,
        cartStream: cartStreamController.stream,
        freeDeliveryThreshold: 5000,
        onProductSelected: (product) {
          // Handle product selection
        },
      ),
    );
  }

  @override
  void dispose() {
    _clearCartController.dispose();
    for (var controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(showCart: false),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState.cart.items.isEmpty && !_isClearing) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Floating hearts background
                        ...List.generate(20, (index) {
                          final isSmall = index % 2 == 0;
                          final xOffset = (index * 20 - 140).toDouble();
                          final startY = index * 30 - 200.0;

                          return Positioned(
                            left:
                                MediaQuery.of(context).size.width / 2 + xOffset,
                            top: startY,
                            child: Icon(
                              FontAwesomeIcons.bagShopping,
                              color: isDarkMode
                                  ? AppColors.accentColorDark
                                      .withOpacity(0.5 + (index % 5) * 0.1)
                                  : AppColors.accentColor
                                      .withOpacity(0.5 + (index % 5) * 0.1),
                              size: isSmall ? 16.0 : 24.0,
                            )
                                .animate(
                                  onPlay: (controller) => controller.repeat(),
                                )
                                .moveY(
                                  begin: 0,
                                  end: 500,
                                  duration: Duration(
                                      seconds: isSmall
                                          ? 6 + index % 4
                                          : 8 + index % 5),
                                  curve: Curves.easeInOut,
                                )
                                .fadeIn(duration: 600.ms)
                                .then()
                                .fadeOut(
                                  begin: 0.7,
                                  delay: Duration(
                                      seconds: isSmall
                                          ? 5 + index % 3
                                          : 7 + index % 4),
                                ),
                          );
                        }),

                        // Main content
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Animated empty favorites image
                            Image.asset(
                              'assets/cart.png',
                              width: 200,
                              height: 200,
                            ).animate().scale(
                                  begin: const Offset(0.8, 0.8),
                                  end: const Offset(1.0, 1.0),
                                  duration: 800.ms,
                                  curve: Curves.elasticOut,
                                ),

                            // Text message with typing animation
                            Text(
                              empty_cart,
                              style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.titleLarge),
                            ).animate().fadeIn(duration: 600.ms).scale(
                                begin: const Offset(0.8, 0.8),
                                end: const Offset(1.0, 1.0),
                                duration: 800.ms,
                                curve: Curves.elasticOut),
                            const SizedBox(height: 5),
                            Text(
                              looking_for_something,
                              style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge),
                            )
                                .animate()
                                .fadeIn(duration: 800.ms)
                                .slideY(begin: 0.5, duration: 800.ms),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          // Initialize item controllers if needed
          if (_itemControllers.length != cartState.cart.items.length) {
            _initializeItemControllers(cartState.cart.items.length);
          }

          return Column(
            children: [
              CartHeader(
                isDarkMode: isDarkMode,
                isClearing: _isClearing,
                onClearCart: _showClearCartDialog,
              ),
              AddItemSection(
                cart: cartState.cart,
                onAddItemPressed: () {
                  _showItemBottomSheet(5000 - cartState.cart.totalPrice);
                },
                authRepository: AuthRepository(),
              )
                  .animate()
                  .fade(duration: const Duration(seconds: 1))
                  .slideX(curve: Curves.easeInOut),
              Expanded(
                child: CartItemList(
                  items: cartState.cart.items,
                  itemControllers: _itemControllers,
                ),
              ),
              CartTotalSection(
                cart: cartState.cart,
                isDarkMode: isDarkMode,
                isClearing: _isClearing,
                clearCartController: _clearCartController,
              ),
            ],
          );
        },
      ),
    );
  }
}
