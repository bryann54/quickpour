part of 'checkout_bloc.dart';

abstract class CheckoutEvent {
  const CheckoutEvent();
}

class UpdateDeliveryInfoEvent extends CheckoutEvent {
  final String address;
  final String phoneNumber;

  UpdateDeliveryInfoEvent({
    required this.address,
    required this.phoneNumber,
  });
}

class UpdatePaymentMethodEvent extends CheckoutEvent {
  final String paymentMethod;

  const UpdatePaymentMethodEvent({
    required this.paymentMethod,
  });
}

class UpdateDeliveryTimeEvent extends CheckoutEvent {
  final String deliveryTime;
  final String specialInstructions;

  const UpdateDeliveryTimeEvent({
    required this.deliveryTime,
    required this.specialInstructions,
  });
}

class PlaceOrderEvent extends CheckoutEvent {
  final Cart cart;
  final String deliveryTime;
  final String specialInstructions;
  final String paymentMethod;
   final String address; // Add address
  final String phoneNumber;

  const PlaceOrderEvent({
    required this.cart,
    required this.deliveryTime,
    required this.specialInstructions,
    required this.paymentMethod,
       required this.address, // Include in constructor
    required this.phoneNumber,
  });
}

class OrderPlacedEvent extends CheckoutEvent {
  final String orderId;
  final double totalAmount;

  OrderPlacedEvent({
    required this.orderId,
    required this.totalAmount,
  });
}
