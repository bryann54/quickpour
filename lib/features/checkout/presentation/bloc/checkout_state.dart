part of 'checkout_bloc.dart';

abstract class CheckoutState {
  final String? address;
  final String? phoneNumber;
  final String? paymentMethod;

  const CheckoutState({
    this.address,
    this.phoneNumber,
    this.paymentMethod,
  });
}

class CheckoutInitialState extends CheckoutState {
  const CheckoutInitialState();
}

class CheckoutLoadingState extends CheckoutState {
  const CheckoutLoadingState();
}

class CheckoutOrderPlacedState extends CheckoutState {
  final String orderId;
  final double totalAmount;
  final List<CartItem> cartItems;

  const CheckoutOrderPlacedState({
    required this.orderId,
    required this.totalAmount,
    required this.cartItems,
    String? address,
    String? phoneNumber,
    String? paymentMethod,
  }) : super(
          address: address,
          phoneNumber: phoneNumber,
          paymentMethod: paymentMethod,
        );
}

class CheckoutErrorState extends CheckoutState {
  final String errorMessage;

  const CheckoutErrorState({
    required this.errorMessage,
    String? address,
    String? phoneNumber,
    String? paymentMethod,
  }) : super(
          address: address,
          phoneNumber: phoneNumber,
          paymentMethod: paymentMethod,
        );
}
