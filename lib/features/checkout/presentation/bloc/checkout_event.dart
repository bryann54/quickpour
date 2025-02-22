part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class UpdateDeliveryInfoEvent extends CheckoutEvent {
  final String address;
  final String phoneNumber;
  final String deliveryType;

  const UpdateDeliveryInfoEvent({
    required this.address,
    required this.phoneNumber,
    required this.deliveryType,
  });

  @override
  List<Object?> get props => [address, phoneNumber, deliveryType];
}

class UpdatePaymentMethodEvent extends CheckoutEvent {
  final String paymentMethod;

  const UpdatePaymentMethodEvent({
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [paymentMethod];
}

class UpdateDeliveryTimeEvent extends CheckoutEvent {
  final String deliveryTime;
  final String specialInstructions;

  const UpdateDeliveryTimeEvent({
    required this.deliveryTime,
    required this.specialInstructions,
  });

  @override
  List<Object?> get props => [deliveryTime, specialInstructions];
}

class PlaceOrderEvent extends CheckoutEvent {
  final Cart cart;
  final String deliveryTime;
  final String specialInstructions;
  final String paymentMethod;
  final String address;
  final String phoneNumber;
  final String deliveryType; // Add delivery type

  const PlaceOrderEvent({
    required this.cart,
    required this.deliveryTime,
    required this.specialInstructions,
    required this.paymentMethod,
    required this.address,
    required this.phoneNumber,
    required this.deliveryType, // Add delivery type
  });

  @override
  List<Object?> get props => [
        cart,
        deliveryTime,
        specialInstructions,
        paymentMethod,
        address,
        phoneNumber,
        deliveryType, // Include delivery type
      ];
}

class OrderPlacedEvent extends CheckoutEvent {
  final String orderId;
  final double totalAmount;

  const OrderPlacedEvent({
    required this.orderId,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [orderId, totalAmount];
}
