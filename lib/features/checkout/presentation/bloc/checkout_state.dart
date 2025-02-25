import 'package:chupachap/features/checkout/domain/entities/merchant_order.dart';
import 'package:equatable/equatable.dart';

abstract class CheckoutState extends Equatable {
  final String? address;
  final String? phoneNumber;
  final String? paymentMethod;
  final String? deliveryTime;
  final String? specialInstructions;
  final String? deliveryType;
  final String? userEmail;
  final String? userName;
  final String? userId;

  const CheckoutState({
    this.address,
    this.phoneNumber,
    this.paymentMethod,
    this.deliveryTime,
    this.specialInstructions,
    this.deliveryType,
    this.userEmail,
    this.userName,
    this.userId,
  });

  CheckoutState copyWith({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
    String? deliveryType,
    String? userEmail,
    String? userName,
    String? userId,
  });

  @override
  List<Object?> get props => [
        address,
        phoneNumber,
        paymentMethod,
        deliveryTime,
        specialInstructions,
        deliveryType,
        userEmail,
        userName,
        userId,
      ];
}

class CheckoutInitialState extends CheckoutState {
  const CheckoutInitialState();

  @override
  CheckoutState copyWith({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
    String? deliveryType,
    String? userEmail,
    String? userName,
    String? userId,
  }) {
    return CheckoutInitialState();
  }
}

class CheckoutLoadingState extends CheckoutState {
  const CheckoutLoadingState({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
    String? deliveryType,
    String? userEmail,
    String? userName,
    String? userId,
  }) : super(
          address: address,
          phoneNumber: phoneNumber,
          paymentMethod: paymentMethod,
          deliveryTime: deliveryTime,
          specialInstructions: specialInstructions,
          deliveryType: deliveryType,
          userEmail: userEmail,
          userName: userName,
          userId: userId,
        );

  @override
  CheckoutState copyWith({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
    String? deliveryType,
    String? userEmail,
    String? userName,
    String? userId,
  }) {
    return CheckoutLoadingState(
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      deliveryType: deliveryType ?? this.deliveryType,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
    );
  }
}

class CheckoutOrderPlacedState extends CheckoutState {
  final String orderId;
  final double totalAmount;
  final List<MerchantOrder> merchantOrders;
  final String status;

  const CheckoutOrderPlacedState({
    required this.orderId,
    required this.totalAmount,
    required this.merchantOrders,
    required this.status,
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
    String? deliveryType,
    String? userEmail,
    String? userName,
    String? userId,
  }) : super(
          address: address,
          phoneNumber: phoneNumber,
          paymentMethod: paymentMethod,
          deliveryTime: deliveryTime,
          specialInstructions: specialInstructions,
          deliveryType: deliveryType,
          userEmail: userEmail,
          userName: userName,
          userId: userId,
        );

  @override
  CheckoutState copyWith({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
    String? deliveryType,
    String? userEmail,
    String? userName,
    String? userId,
    String? status,
  }) {
    return CheckoutOrderPlacedState(
      orderId: orderId,
      totalAmount: totalAmount,
      merchantOrders: merchantOrders,
      status: status ?? this.status,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      deliveryType: deliveryType ?? this.deliveryType,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        orderId,
        totalAmount,
        merchantOrders,
        status,
      ];
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
    String? deliveryType,
    String? userEmail,
    String? userName,
    String? userId,
  }) : super(
          address: address,
          phoneNumber: phoneNumber,
          paymentMethod: paymentMethod,
          deliveryTime: deliveryTime,
          specialInstructions: specialInstructions,
          deliveryType: deliveryType,
          userEmail: userEmail,
          userName: userName,
          userId: userId,
        );

  @override
  CheckoutState copyWith({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
    String? deliveryTime,
    String? specialInstructions,
    String? deliveryType,
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
      deliveryType: deliveryType ?? this.deliveryType,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        errorMessage,
      ];
}
