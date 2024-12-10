

import 'package:chupachap/features/orders/data/models/order_model.dart';

class OrdersRepository {
  final List<Order> _orders = [];

  List<Order> getOrders() {
    return List.unmodifiable(_orders);
  }

  void addOrder(Order order) {
    _orders.add(order);
  }

  void clearOrders() {
    _orders.clear();
  }

Order? getOrderById(String id) {
  try {
    return _orders.firstWhere((order) => order.id == id);
  } catch (e) {
    // Return null if no match is found
    return null;
  }
}

}
