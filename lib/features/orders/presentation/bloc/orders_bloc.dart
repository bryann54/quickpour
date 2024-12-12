import 'package:bloc/bloc.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final CheckoutBloc checkoutBloc;

  OrdersBloc({required this.checkoutBloc}) : super(OrdersInitial()) {
    on<LoadOrdersFromCheckout>(_onLoadOrdersFromCheckout);
  }

  void _onLoadOrdersFromCheckout(
      LoadOrdersFromCheckout event, Emitter<OrdersState> emit) {
    final completedOrders = _getCompletedOrders(checkoutBloc);

    if (completedOrders.isEmpty) {
      emit(OrdersEmpty());
    } else {
      emit(OrdersLoaded(completedOrders));
    }
  }

  List<CompletedOrder> _getCompletedOrders(CheckoutBloc checkoutBloc) {
    final completedOrders = <CompletedOrder>[];

    // Check if the current state is an order placed state
    if (checkoutBloc.state is CheckoutOrderPlacedState) {
      final placedState = checkoutBloc.state as CheckoutOrderPlacedState;
      completedOrders.add(CompletedOrder(
        id: placedState.orderId,
        date: DateTime.now(),
        total: placedState.totalAmount,
        address: placedState.address ?? '',
        phoneNumber: placedState.phoneNumber ?? '',
        paymentMethod: placedState.paymentMethod ?? '',
        items: [], // You'd populate this from the cart
      ));
    }

    return completedOrders;
  }
}
