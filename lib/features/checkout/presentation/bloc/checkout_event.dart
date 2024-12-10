part of 'checkout_bloc.dart';

abstract class CheckoutEvent {
  const CheckoutEvent();
}

class UpdateDeliveryInfoEvent extends CheckoutEvent {
  final String address;
  final String phoneNumber;

  const UpdateDeliveryInfoEvent({
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

class PlaceOrderEvent extends CheckoutEvent {
  final Cart cart;

  const PlaceOrderEvent({
    required this.cart,
  });
}
