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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.swipe_left_alt,
                    color: Colors.grey,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Swipe left to remove drink',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .fadeIn(duration: 800.ms)
                  .then(delay: 5.seconds)
                  .fadeOut(),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 4),
            padding: const EdgeInsets.symmetric(horizontal: 4),
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
                      padding: const EdgeInsets.only(right: 10),
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
          ),
        ),
      ],
    );
  }
}
