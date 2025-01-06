import 'package:chupachap/features/auth/domain/usecases/auth_usecases.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

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
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<UpdateDeliveryTimeEvent>(_onUpdateDeliveryTime);
  }

  void _onUpdateDeliveryInfo(
      UpdateDeliveryInfoEvent event, Emitter<CheckoutState> emit) {
    emit(
        state.copyWith(address: event.address, phoneNumber: event.phoneNumber));
  }

  void _onUpdatePaymentMethod(
      UpdatePaymentMethodEvent event, Emitter<CheckoutState> emit) {
    emit(state.copyWith(paymentMethod: event.paymentMethod));
  }
  void _onUpdateDeliveryTime(
      UpdateDeliveryTimeEvent event, Emitter<CheckoutState> emit) {
    emit(state.copyWith(
      deliveryTime: event.deliveryTime,
      specialInstructions: event.specialInstructions,
    ));
  }
  Future<void> _onPlaceOrder(
      PlaceOrderEvent event, Emitter<CheckoutState> emit) async {
    try {
      emit(const CheckoutLoadingState());
      final orderId = const Uuid().v4();
      // final totalAmount = event.cart.totalPrice;
      // Check if user is authenticated using AuthUseCases
      final userId = authUseCases.getCurrentUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      // Get current user details
      final userDetails = await authUseCases.getCurrentUserDetails();
      if (userDetails == null) {
        throw Exception('User details not found');
      }

      // Save order to Firestore

    final orderData = {
        'orderId': orderId,
        'userId': userId,
        'userEmail': userDetails.email,
        'userName': '${userDetails.firstName} ${userDetails.lastName}',
        'totalAmount': event.cart.totalPrice,
        'address': state.address,
        'phoneNumber': state.phoneNumber,
        'paymentMethod': state.paymentMethod,
        'deliveryTime': event.deliveryTime, // Add this
        'specialInstructions': event.specialInstructions, // Add this
        'cartItems': event.cart.items
            .map((item) => {
                  'productName': item.product.productName,
                  'quantity': item.quantity,
                  'price': item.product.price,
                })
            .toList(),
        'date': DateTime.now().toIso8601String(),
        'status': 'pending',
      };

      await firestore.collection('orders').doc(orderId).set(orderData);

      emit(CheckoutOrderPlacedState(
        orderId: orderId,
        totalAmount: event.cart.totalPrice,
        address: state.address,
        cartItems: event.cart.items,
        phoneNumber: state.phoneNumber,
        paymentMethod: state.paymentMethod,
      ));
    } catch (e) {
      emit(CheckoutErrorState(
        errorMessage: 'Failed to place order: ${e.toString()}',
        address: state.address,
        phoneNumber: state.phoneNumber,
        paymentMethod: state.paymentMethod,
      ));
    }
  }

}
