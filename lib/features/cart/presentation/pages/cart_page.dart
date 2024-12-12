import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:chupachap/features/checkout/presentation/pages/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _clearCartController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _clearCartController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _clearCartController, curve: Curves.easeInOut));
  }

  // Show a confirmation dialog before clearing the cart
  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text('Clear Cart'),
          content: const Text('Are you sure you want to clear your cart?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearCart();
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _clearCart() {
    _clearCartController.forward().then((_) {
      context.read<CartBloc>().add(ClearCartEvent());
      _clearCartController.reset();
    });
  }

  @override
  void dispose() {
    _clearCartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(
        showCart: false,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState.cart.items.isEmpty) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      screenHeight - (AppBar().preferredSize.height + 50),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/Animation - 1732905747047.gif',
                        width: screenWidth * 0.7,
                        height: screenHeight * 0.3,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDarkMode ? Colors.white70 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your cart',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: isDarkMode
                                ? AppColors.cardColor
                                : AppColors.accentColorDark,
                          ),
                    ),
                    GestureDetector(
                      onTap: _showClearCartDialog,
                      child: Text(
                        'Clear cart',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color:
                                isDarkMode ? AppColors.cardColor : Colors.black,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: ListView.builder(
                        itemCount: cartState.cart.items.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartState.cart.items[index];
                          return Dismissible(
                            key: Key(cartItem.product.id.toString()),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) {
                              context.read<CartBloc>().add(
                                    RemoveFromCartEvent(
                                        product: cartItem.product),
                                  );
                            },
                            child: CartItemWidget(cartItem: cartItem),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              // Total and Checkout Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Divider(
                        color: isDarkMode
                            ? Colors.grey[200]
                            : AppColors.accentColor.withOpacity(.3),
                        thickness: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'KSh ${cartState.cart.totalPrice.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: isDarkMode
                                        ? AppColors.surface.withOpacity(.7)
                                        : AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: cartState.cart.items.isNotEmpty
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CheckoutScreen(),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Proceed to Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
