import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartInitialState()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateCartQuantityEvent>(_onUpdateCartQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final currentCart = state.cart;

    // Check if product already exists in cart
    final existingItemIndex = currentCart.items
        .indexWhere((item) => item.product.id == event.product.id);

    List<CartItem> updatedItems = List.from(currentCart.items);

    if (existingItemIndex != -1) {
      // Update existing item's quantity
      updatedItems[existingItemIndex] = CartItem(
          product: event.product,
          quantity: updatedItems[existingItemIndex].quantity + event.quantity);
    } else {
      // Add new item to cart
      updatedItems
          .add(CartItem(product: event.product, quantity: event.quantity));
    }

    emit(CartLoadedState(cart: Cart(items: updatedItems)));
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final currentCart = state.cart;
    final updatedItems = currentCart.items
        .where((item) => item.product.id != event.product.id)
        .toList();

    emit(CartLoadedState(cart: Cart(items: updatedItems)));
  }

  void _onUpdateCartQuantity(
      UpdateCartQuantityEvent event, Emitter<CartState> emit) {
    final currentCart = state.cart;
    final updatedItems = currentCart.items.map((item) {
      if (item.product.id == event.product.id) {
        return CartItem(product: event.product, quantity: event.quantity);
      }
      return item;
    }).toList();

    emit(CartLoadedState(cart: Cart(items: updatedItems)));
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartInitialState());
  }
}
