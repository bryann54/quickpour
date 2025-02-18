import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/cart/data/repositories/cart_repository.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_event.dart';
import 'package:chupachap/features/cart/presentation/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;
  final String userId;

  CartBloc({required this.cartRepository, required this.userId})
      : super(const CartInitialState()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateCartQuantityEvent>(_onUpdateCartQuantity);
    on<ClearCartEvent>(_onClearCart);
    on<LoadCartEvent>(_onLoadCart);

    // Load cart items when bloc is created
    add(const LoadCartEvent());
  }

  void _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    try {
      final cartItems = await cartRepository.getCartItems(userId);
      emit(CartLoadedState(cart: Cart(items: cartItems)));
    } catch (e) {
      emit(CartErrorState(
        cart: state.cart,
        errorMessage: 'Failed to load cart: ${e.toString()}',
      ));
    }
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    // Store the current state to restore in case of error
    final previousState = state;

    try {
      // Optimistically update the UI
      final currentItems = List<CartItem>.from(state.cart.items);
      final existingItemIndex = currentItems
          .indexWhere((item) => item.product.id == event.product.id);

      if (existingItemIndex != -1) {
        // Update quantity if item exists
        currentItems[existingItemIndex] = CartItem(
          product: event.product,
          quantity: currentItems[existingItemIndex].quantity + event.quantity,
        );
      } else {
        // Add new item
        currentItems.add(CartItem(
          product: event.product,
          quantity: event.quantity,
        ));
      }

      emit(CartLoadedState(cart: Cart(items: currentItems)));

      // Perform the actual API call
      await cartRepository.addToCart(
        userId,
        CartItem(product: event.product, quantity: event.quantity),
      );

      // Refresh cart from server to ensure consistency
      final updatedItems = await cartRepository.getCartItems(userId);
      emit(CartLoadedState(cart: Cart(items: updatedItems)));
    } catch (e) {
      // Revert to previous state and show error
      emit(CartErrorState(
        cart: previousState.cart,
        errorMessage: 'Failed to add item to cart',
      ));
    }
  }

  void _onRemoveFromCart(
      RemoveFromCartEvent event, Emitter<CartState> emit) async {
    final previousState = state;

    try {
      // Optimistically update UI
      final currentItems = List<CartItem>.from(state.cart.items);
      currentItems.removeWhere((item) => item.product.id == event.product.id);
      emit(CartLoadedState(cart: Cart(items: currentItems)));

      // Perform the actual API call
      await cartRepository.removeFromCart(userId, event.product.id);

      // No need to refresh from server since removal is simple
    } catch (e) {
      // Revert to previous state and show error
      emit(CartErrorState(
        cart: previousState.cart,
        errorMessage: 'Failed to remove item from cart',
      ));
    }
  }

  void _onUpdateCartQuantity(
      UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
    final previousState = state;

    try {
      // Optimistically update UI
      final currentItems = List<CartItem>.from(state.cart.items);
      final itemIndex = currentItems
          .indexWhere((item) => item.product.id == event.product.id);

      if (itemIndex != -1) {
        if (event.quantity > 0) {
          currentItems[itemIndex] = CartItem(
            product: event.product,
            quantity: event.quantity,
          );
        } else {
          currentItems.removeAt(itemIndex);
        }
        emit(CartLoadedState(cart: Cart(items: currentItems)));

        // Perform the actual API call
        await cartRepository.updateCartQuantity(
          userId,
          event.product.id,
          event.quantity,
        );

        // Refresh cart from server to ensure consistency
        final updatedItems = await cartRepository.getCartItems(userId);
        emit(CartLoadedState(cart: Cart(items: updatedItems)));
      }
    } catch (e) {
      // Revert to previous state and show error
      emit(CartErrorState(
        cart: previousState.cart,
        errorMessage: 'Failed to update quantity',
      ));
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    final previousState = state;

    try {
      // Optimistically clear the cart
      emit(const CartInitialState());

      // Perform the actual API call
      final cartRef = cartRepository.firestore
          .collection('users')
          .doc(userId)
          .collection('cart');
      final batch = cartRepository.firestore.batch();
      final items = await cartRef.get();

      for (var doc in items.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      // Revert to previous state and show error
      emit(CartErrorState(
        cart: previousState.cart,
        errorMessage: 'Failed to clear cart',
      ));
    }
  }
}
