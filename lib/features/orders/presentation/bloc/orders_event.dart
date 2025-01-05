part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class LoadOrdersFromCheckout extends OrdersEvent {}


class AddNewOrder extends OrdersEvent {
  final CompletedOrder order;

  const AddNewOrder(this.order);

  @override
  List<Object> get props => [order];
}
