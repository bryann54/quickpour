import 'package:chupachap/features/auth/domain/usecases/auth_usecases.dart';
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
    emit(state.copyWith(
      address: event.address,
      phoneNumber: event.phoneNumber,
    ));
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

      // Create complete order data combining both sources
      final orderData = {
        // User details from AuthUseCases
        'userId': userId,
        'userEmail': userDetails.email,
        'userName': '${userDetails.firstName} ${userDetails.lastName}',

        // Order details from state
        'address': state.address,
        'phoneNumber': state.phoneNumber,
        'paymentMethod': event.paymentMethod,
        'deliveryTime': event.deliveryTime,
        'specialInstructions': event.specialInstructions,

        // Cart details from event
        'cartItems': event.cart.items
            .map((item) => {
                  'productName': item.product.productName,
                  'quantity': item.quantity,
                  'price': item.product.price,
                })
            .toList(),
        'totalAmount': event.cart.totalPrice,

        // Order metadata
        'orderId': orderId,
        'date': DateTime.now().toIso8601String(),
        'status': 'pending',
      };

      // Save to Firestore using the generated reference
      await orderRef.set(orderData);

      // Emit success state with all combined data
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
        status: state.specialInstructions.toString(),
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
