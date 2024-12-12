import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  final Cart cart;

  const CartState({required this.cart});

  @override
  List<Object> get props => [cart];
}

class CartInitialState extends CartState {
  const CartInitialState() : super(cart: const Cart());
}

class CartLoadedState extends CartState {
  const CartLoadedState({required Cart cart}) : super(cart: cart);
}

class CartErrorState extends CartState {
  final String errorMessage;

  const CartErrorState({required Cart cart, required this.errorMessage})
      : super(cart: cart);

  @override
  List<Object> get props => [cart, errorMessage];
}
