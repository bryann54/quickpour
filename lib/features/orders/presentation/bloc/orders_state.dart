part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersEmpty extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<CompletedOrder> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}
