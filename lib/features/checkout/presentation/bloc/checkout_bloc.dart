import 'package:chupachap/features/auth/domain/usecases/auth_usecases.dart';
import 'package:chupachap/features/notifications/domain/repositories/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'checkout_state.dart';
part 'checkout_event.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final FirebaseFirestore firestore;
  final AuthUseCases authUseCases;

  CheckoutBloc({
    required this.firestore,
    required this.authUseCases,
  }) : super(const CheckoutInitialState()) {
    on<UpdateDeliveryInfoEvent>(_onUpdateDeliveryInfo);
    on<UpdatePaymentMethodEvent>(_onUpdatePaymentMethod);
    on<UpdateDeliveryTimeEvent>(_onUpdateDeliveryTime);
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  void _onUpdateDeliveryInfo(
      UpdateDeliveryInfoEvent event, Emitter<CheckoutState> emit) {
    // Remove any notification triggers from here
    emit(state.copyWith(
      address: event.address,
      phoneNumber: event.phoneNumber,
    ));
  }

  void _onUpdatePaymentMethod(
      UpdatePaymentMethodEvent event, Emitter<CheckoutState> emit) {
    // Remove any notification triggers from here
    emit(state.copyWith(paymentMethod: event.paymentMethod));
  }

  void _onUpdateDeliveryTime(
      UpdateDeliveryTimeEvent event, Emitter<CheckoutState> emit) {
    // Remove any notification triggers from here
    emit(state.copyWith(
      deliveryTime: event.deliveryTime,
      specialInstructions: event.specialInstructions,
    ));
  }

  Future<void> _onPlaceOrder(
      PlaceOrderEvent event, Emitter<CheckoutState> emit) async {
    try {
      emit(const CheckoutLoadingState());

      // Check user authentication
      final userId = authUseCases.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Get user details
      final userDetails = await authUseCases.getCurrentUserDetails();
      if (userDetails == null) {
        throw Exception('User details not found');
      }

      // Generate orderId using actual document reference
      final orderRef = firestore.collection('orders').doc();
      final orderId = orderRef.id;

      // Create complete order data
      final orderData = {
        'userId': userId,
        'userEmail': userDetails.email,
        'userName': '${userDetails.firstName} ${userDetails.lastName}',
        'address': state.address,
        'phoneNumber': state.phoneNumber,
        'paymentMethod': event.paymentMethod,
        'deliveryTime': event.deliveryTime,
        'specialInstructions': event.specialInstructions,
        'cartItems': event.cart.items
            .map((item) => {
                  'productName': item.product.productName,
                  'quantity': item.quantity,
                  'price': item.product.price,
                })
            .toList(),
        'totalAmount': event.cart.totalPrice,
        'orderId': orderId,
        'date': DateTime.now().toIso8601String(),
        'status': 'pending',
      };

      // Save to Firestore
      await orderRef.set(orderData);

      // Only show notification after successful order placement
      await NotificationService.showOrderNotification(
        title: 'Order Placed Successfully!',
        body: 'Your order #$orderId has been placed.',
        userId: userId, // Add this parameter
      );

      // Emit success state
      emit(CheckoutOrderPlacedState(
        orderId: orderId,
        totalAmount: event.cart.totalPrice,
        cartItems: event.cart.items,
        address: state.address,
        phoneNumber: state.phoneNumber,
        paymentMethod: event.paymentMethod,
        deliveryTime: event.deliveryTime,
        specialInstructions: event.specialInstructions,
        userEmail: userDetails.email,
        userName: '${userDetails.firstName} ${userDetails.lastName}',
        userId: userId,
        status: 'pending',
      ));
    } catch (e) {
      emit(CheckoutErrorState(
        errorMessage: 'Failed to place order: ${e.toString()}',
        address: state.address,
        phoneNumber: state.phoneNumber,
        paymentMethod: state.paymentMethod,
        deliveryTime: state.deliveryTime,
        specialInstructions: state.specialInstructions,
      ));
    }
  }
}
