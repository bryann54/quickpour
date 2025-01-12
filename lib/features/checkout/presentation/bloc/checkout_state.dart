part of 'checkout_bloc.dart';

abstract class CheckoutState {
  final String? address;
  final String? phoneNumber;
  final String? paymentMethod;
  final String? deliveryTime;
  final String? specialInstructions;
  final String? userEmail;
  final String? userName;
  final String? userId;

  const CheckoutState({
    this.address,
    this.phoneNumber,
    this.paymentMethod,
    this.deliveryTime,
    this.specialInstructions,
    this.userEmail,
    this.userName,
    this.userId,
  });

  // Define copyWith method in the abstract class
  CheckoutState copyWith({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
    String? userEmail,
    String? userName,
    String? userId,
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
    String? userEmail,
    String? userName,
    String? userId,
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
    String? userEmail,
    String? userName,
    String? userId,
  }) {
    return CheckoutLoadingState();
  }
}

class CheckoutOrderPlacedState extends CheckoutState {
  final String orderId;
  final double totalAmount;
  final List<CartItem> cartItems;
  final String status; // Added status field

  const CheckoutOrderPlacedState({
    required this.orderId,
    required this.totalAmount,
    required this.cartItems,
    required this.status, // Make status required
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
    String? userEmail,
    String? userName,
    String? userId,
  }) : super(
          address: address,
          phoneNumber: phoneNumber,
          paymentMethod: paymentMethod,
          deliveryTime: deliveryTime,
          specialInstructions: specialInstructions,
          userEmail: userEmail,
          userName: userName,
          userId: userId,
        );

  @override
  CheckoutOrderPlacedState copyWith({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
    String? userEmail,
    String? userName,
    String? userId,
    String? status, // Add status to copyWith
  }) {
    return CheckoutOrderPlacedState(
      orderId: orderId,
      totalAmount: totalAmount,
      cartItems: cartItems,
      status: status ?? this.status, // Preserve existing status if not provided
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
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
    String? userEmail,
    String? userName,
    String? userId,
  }) : super(
          address: address,
          phoneNumber: phoneNumber,
          paymentMethod: paymentMethod,
          deliveryTime: deliveryTime,
          specialInstructions: specialInstructions,
          userEmail: userEmail,
          userName: userName,
          userId: userId,
        );

  @override
  CheckoutErrorState copyWith({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
    String? userEmail,
    String? userName,
    String? userId,
  }) {
    return CheckoutErrorState(
      errorMessage: errorMessage,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
    );
  }
}
