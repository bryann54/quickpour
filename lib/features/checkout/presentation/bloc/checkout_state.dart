part of 'checkout_bloc.dart';

abstract class CheckoutState {
  final String? address;
  final String? phoneNumber;
  final String? paymentMethod;
  final String? deliveryTime;
  final String? specialInstructions;

  const CheckoutState({
    this.address,
    this.phoneNumber,
    this.paymentMethod,
    this.deliveryTime,
    this.specialInstructions,
  });

  // Define copyWith method in the abstract class
  CheckoutState copyWith({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
  });
}

class CheckoutInitialState extends CheckoutState {
  const CheckoutInitialState();

  @override
  CheckoutInitialState copyWith({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
  }) {
    return CheckoutInitialState();
  }
}

class CheckoutLoadingState extends CheckoutState {
  const CheckoutLoadingState();

  @override
  CheckoutLoadingState copyWith({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
  }) {
    return CheckoutLoadingState();
  }
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
    String? deliveryTime,
    String? specialInstructions,
  }) : super(
          address: address,
          phoneNumber: phoneNumber,
          paymentMethod: paymentMethod,
          deliveryTime: deliveryTime,
          specialInstructions: specialInstructions,
        );

  @override
  CheckoutOrderPlacedState copyWith({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
  }) {
    return CheckoutOrderPlacedState(
      orderId: orderId,
      totalAmount: totalAmount,
      cartItems: cartItems,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}

class CheckoutErrorState extends CheckoutState {
  final String errorMessage;

  const CheckoutErrorState({
    required this.errorMessage,
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
  }) : super(
          address: address,
          phoneNumber: phoneNumber,
          paymentMethod: paymentMethod,
          deliveryTime: deliveryTime,
          specialInstructions: specialInstructions,
        );

  @override
  CheckoutErrorState copyWith({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
  }) {
    return CheckoutErrorState(
      errorMessage: errorMessage,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}
