import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/cart/data/repositories/cart_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    // Immediately load cart items when bloc is created
    add(const LoadCartEvent());
  }

  void _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    try {
      final cartItems = await cartRepository.getCartItems(userId);
      emit(CartLoadedState(cart: Cart(items: cartItems)));
    } catch (e) {
      emit(CartErrorState(cart: state.cart, errorMessage: e.toString()));
    }
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    try {
      await cartRepository.addToCart(
          userId, CartItem(product: event.product, quantity: event.quantity));

      final updatedItems = await cartRepository.getCartItems(userId);

      

      emit(CartLoadedState(cart: Cart(items: updatedItems)));
    } catch (e) {
      emit(CartErrorState(cart: state.cart, errorMessage: e.toString()));
    }
  }

  void _onRemoveFromCart(
      RemoveFromCartEvent event, Emitter<CartState> emit) async {
    try {
      await cartRepository.removeFromCart(userId, event.product.id);
      final updatedItems = await cartRepository.getCartItems(userId);
      emit(CartLoadedState(cart: Cart(items: updatedItems)));
    } catch (e) {
      emit(CartErrorState(cart: state.cart, errorMessage: e.toString()));
    }
  }

  void _onUpdateCartQuantity(
      UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
    try {
      await cartRepository.updateCartQuantity(
          userId, event.product.id, event.quantity);
      final updatedItems = await cartRepository.getCartItems(userId);
      emit(CartLoadedState(cart: Cart(items: updatedItems)));
    } catch (e) {
      emit(CartErrorState(cart: state.cart, errorMessage: e.toString()));
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    try {
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
      emit(const CartInitialState());
    } catch (e) {
      emit(CartErrorState(cart: state.cart, errorMessage: e.toString()));
    }
  }
}
