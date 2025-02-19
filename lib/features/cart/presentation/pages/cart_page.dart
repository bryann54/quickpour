import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/cart/presentation/widgets/empty_cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/cart/presentation/widgets/cart_header.dart';
import 'package:chupachap/features/cart/presentation/widgets/cart_item_list.dart';
import 'package:chupachap/features/cart/presentation/widgets/cart_total_section.dart';
import 'package:chupachap/features/cart/presentation/widgets/cart_clear_dialog.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  late AnimationController _clearCartController;
  late AnimationController _animationController;
  final List<AnimationController> _itemControllers = [];
  final List<CartItem> cartList = [];
  double subtotal = 0;
  bool _isClearing = false;

  @override
  void initState() {
    super.initState();
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

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => CartClearDialog(onClear: _clearCart),
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
            return const Center(
              child: EmptyCartWidget(),
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
