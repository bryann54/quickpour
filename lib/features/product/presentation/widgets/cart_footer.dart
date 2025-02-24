import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/date_formatter.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartFooter extends StatelessWidget {
  final ProductModel product;
  final int currentQuantity;
  final ValueChanged<int> onQuantityChanged;

  const CartFooter({
    Key? key,
    required this.product,
    required this.currentQuantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final cartItem = cartState.cart.items.isNotEmpty
            ? cartState.cart.items.firstWhere(
                (item) => item.product.id == product.id,
                orElse: () => CartItem(product: product, quantity: 0),
              )
            : CartItem(product: product, quantity: 0);

        return cartItem.quantity == 0
            ? _buildAddToCartButton(context)
            : _buildQuantityControls(context, isDarkMode, cartItem.quantity);
      },
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          context.read<CartBloc>().add(
                AddToCartEvent(product: product, quantity: 1),
              );
          onQuantityChanged(1);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text('Add to Cart'),
      ),
    );
  }

  Widget _buildQuantityControls(
      BuildContext context, bool isDarkMode, int quantity) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: _buildQuantitySelector(context, isDarkMode, quantity),
              ),
              Flexible(
                flex: 2,
                child: _buildTotalPrice(context, quantity),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(
      BuildContext context, bool isDarkMode, int quantity) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildQuantityButton(
              context: context,
              icon: Icons.remove,
              isDarkMode: isDarkMode,
              onPressed: () {
                final newQuantity = quantity > 1 ? quantity - 1 : 0;
                _updateQuantity(context, newQuantity);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '$quantity',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 20,
                      color: isDarkMode ? Colors.grey : AppColors.accentColor,
                    ),
              ),
            ),
            _buildQuantityButton(
              context: context,
              icon: Icons.add,
              isDarkMode: isDarkMode,
              isAddButton: true,
              onPressed: () {
                _updateQuantity(context, quantity + 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required BuildContext context,
    required IconData icon,
    required bool isDarkMode,
    required VoidCallback onPressed,
    bool isAddButton = false,
  }) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isAddButton && !isDarkMode
            ? AppColors.accentColor
            : (isDarkMode ? Colors.grey[800] : Colors.transparent),
        border: !isAddButton
            ? Border.all(
                color: isDarkMode ? Colors.grey : AppColors.accentColor,
              )
            : null,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 15,
          color: isAddButton ? Colors.white : null,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildTotalPrice(BuildContext context, int quantity) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Use discounted price if available, else fall back to product price.
    final price =
        product.discountPrice > 0 && product.discountPrice < product.price
            ? product.discountPrice
            : product.price;

    return SizedBox(
      width: screenWidth * 0.5,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'TOTAL',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(width: 10),
              Text(
                'KSh ${formatMoney(price * quantity)}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppColors.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateQuantity(BuildContext context, int newQuantity) {
    context.read<CartBloc>().add(
          UpdateCartQuantityEvent(
            product: product,
            quantity: newQuantity,
          ),
        );
    onQuantityChanged(newQuantity);
  }
}
