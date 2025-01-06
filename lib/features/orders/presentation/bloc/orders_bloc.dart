import 'package:chupachap/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';
import 'package:chupachap/features/orders/data/models/order_model.dart';
import 'package:chupachap/features/orders/data/repositories/orders_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'orders_event.dart';
part 'orders_state.dart';
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final CheckoutBloc checkoutBloc;
  final OrdersRepository ordersRepository;

  OrdersBloc({
    required this.checkoutBloc,
    required this.ordersRepository,
  }) : super(OrdersInitial()) {
    on<LoadOrdersFromCheckout>(_onLoadOrders);
    on<AddNewOrder>(_onAddNewOrder);

    // Listen to checkout completion
    checkoutBloc.stream.listen((state) {
      if (state is CheckoutOrderPlacedState) {
        final newOrder = CompletedOrder(
          id: state.orderId,
          total: state.totalAmount,
          date: DateTime.now(),
          address: state.address ?? '',
          phoneNumber: state.phoneNumber ?? '',
          paymentMethod: state.paymentMethod ?? '',
          items: state.cartItems
              .map((cartItem) => OrderItem(
                    name: cartItem.product.productName,
                    quantity: cartItem.quantity,
                    price: cartItem.product.price,
                  ))
              .toList(),
        );
        add(AddNewOrder(newOrder));
      }
    });
  }

  Future<void> _onLoadOrders(
    LoadOrdersFromCheckout event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final orders = await ordersRepository.getOrders();
      if (orders.isEmpty) {
        emit(OrdersEmpty());
      } else {
        emit(OrdersLoaded(orders));
      }
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  void _onAddNewOrder(AddNewOrder event, Emitter<OrdersState> emit) {
    if (state is OrdersLoaded) {
      final currentOrders = (state as OrdersLoaded).orders;
      emit(OrdersLoaded([...currentOrders, event.order]));
    } else {
      emit(OrdersLoaded([event.order]));
    }
  }
}
