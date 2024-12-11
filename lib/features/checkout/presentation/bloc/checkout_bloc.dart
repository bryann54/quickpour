
import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'checkout_state.dart';
part 'checkout_event.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(const CheckoutInitialState()) {
    on<UpdateDeliveryInfoEvent>(_onUpdateDeliveryInfo);
    on<UpdatePaymentMethodEvent>(_onUpdatePaymentMethod);
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  void _onUpdateDeliveryInfo(
    UpdateDeliveryInfoEvent event,
    Emitter<CheckoutState> emit,
  ) {
    emit(const CheckoutInitialState().copyWith(
      address: event.address,
      phoneNumber: event.phoneNumber,
    ));
  }

  void _onUpdatePaymentMethod(
    UpdatePaymentMethodEvent event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(
      paymentMethod: event.paymentMethod,
    ));
  }

  void _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      emit(const CheckoutLoadingState());

      // Simulate order placement (replace with actual order placement logic)
      await Future.delayed(const Duration(seconds: 2));

      final orderId = const Uuid().v4();
      final totalAmount = event.cart.totalPrice;

      emit(CheckoutOrderPlacedState(
        orderId: orderId,
        totalAmount: totalAmount,
        address: state.address,
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

// Extension method for state copying
extension CheckoutStateCopyWith on CheckoutState {
  CheckoutState copyWith({
    String? address,
    String? phoneNumber,
    String? paymentMethod,
  }) {
    return const CheckoutInitialState().copyWith(
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
