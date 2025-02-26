import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/checkout/domain/entities/order.dart';
import 'package:chupachap/features/checkout/domain/repositories/checkout_repository.dart';

class PlaceOrderUseCase {
  final CheckoutRepository repository;

  PlaceOrderUseCase(this.repository);

  Future<Order> execute({
    required Cart cart,
    required String deliveryTime,
    required String specialInstructions,
    required String paymentMethod,
    required String address,
    required String phoneNumber,
    required String deliveryType,
  }) {
    return repository.placeOrder(
      cart: cart,
      deliveryTime: deliveryTime,
      specialInstructions: specialInstructions,
      paymentMethod: paymentMethod,
      address: address,
      phoneNumber: phoneNumber,
      deliveryType: deliveryType,
    );
  }
}
