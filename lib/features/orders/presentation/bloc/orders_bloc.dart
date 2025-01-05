import 'package:bloc/bloc.dart';
import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/data/models/order_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final CheckoutBloc checkoutBloc;
  final List<CompletedOrder> _completedOrders = []; // Store completed orders

  OrdersBloc({required this.checkoutBloc}) : super(OrdersInitial()) {
    on<LoadOrdersFromCheckout>(_onLoadOrdersFromCheckout);
    on<AddNewOrder>(_onAddNewOrder);

    // Listen to CheckoutBloc's state changes
    checkoutBloc.stream.listen((state) {
      if (state is CheckoutOrderPlacedState) {
        // Create a new order and add it to the list
        final orderItems = _getOrderItemsFromState(state);
        final newOrder = CompletedOrder(
          id: state.orderId,
          date: DateTime.now(),
          total: state.totalAmount,
          address: state.address ?? '',
          phoneNumber: state.phoneNumber ?? '',
          paymentMethod: state.paymentMethod ?? '',
          items: orderItems,
        );

        add(AddNewOrder(newOrder)); // Add the new order
      }
    });
  }

  void _onAddNewOrder(AddNewOrder event, Emitter<OrdersState> emit) {
    _completedOrders.add(event.order);
    emit(OrdersLoaded(
        List.from(_completedOrders))); 
  }

  void _onLoadOrdersFromCheckout(
    LoadOrdersFromCheckout event,
    Emitter<OrdersState> emit,
  ) {
    if (_completedOrders.isEmpty) {
      emit(OrdersEmpty());
    } else {
      emit(OrdersLoaded(List.from(_completedOrders)));
    }
  }

  List<OrderItem> _getOrderItemsFromState(CheckoutOrderPlacedState state) {
    return state.cartItems
        .map((cartItem) => OrderItem(
              name: cartItem.product.productName,
              quantity: cartItem.quantity,
              price: cartItem.product.price,
            ))
        .toList();
  }
}


