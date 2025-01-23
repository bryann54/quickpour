import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddToCartEvent extends CartEvent {
  final ProductModel product;
  final int quantity;

  const AddToCartEvent({required this.product, required this.quantity});

  @override
  List<Object> get props => [product, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final ProductModel product;

  const RemoveFromCartEvent({required this.product});

  @override
  List<Object> get props => [product];
}

class UpdateCartQuantityEvent extends CartEvent {
  final ProductModel product;
  final int quantity;

  const UpdateCartQuantityEvent(
      {required this.product, required this.quantity});

  @override
  List<Object> get props => [product, quantity];
}
class LoadCartEvent extends CartEvent {
  const LoadCartEvent();

  @override
  List<Object> get props => [];
}

class ClearCartEvent extends CartEvent {}
