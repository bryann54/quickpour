// cart_item_list.dart
import 'package:chupachap/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';

class CartItemList extends StatelessWidget {
  final List<CartItem> items;
  final List<AnimationController> itemControllers;

  const CartItemList({
    super.key,
    required this.items,
    required this.itemControllers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final cartItem = items[index];
        return FadeTransition(
          opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
              parent: itemControllers[index],
              curve: Curves.easeOutCubic,
            ),
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-1, 0),
            ).animate(
              CurvedAnimation(
                parent: itemControllers[index],
                curve: Curves.easeOutCubic,
              ),
            ),
            child: Dismissible(
              key: Key(cartItem.product.id),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (_) {
                context.read<CartBloc>().add(
                      RemoveFromCartEvent(product: cartItem.product),
                    );
              },
              child: CartItemWidget(cartItem: cartItem)
                  .animate()
                  .fadeIn(
                    duration: 400.ms,
                    delay: Duration(milliseconds: index * 50),
                  )
                  .slideX(begin: 0.2),
            ),
          ),
        );
      },
    );
  }
}
