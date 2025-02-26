import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:chupachap/features/checkout/domain/entities/order.dart';

abstract class CheckoutRepository {
  Future<Order> placeOrder({
    required Cart cart,
    required String deliveryTime,
    required String specialInstructions,
    required String paymentMethod,
    required String address,
    required String phoneNumber,
    required String deliveryType,
  });
}
