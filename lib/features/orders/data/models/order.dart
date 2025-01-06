import 'package:chupachap/features/orders/data/models/order_model.dart';

class Order {
  final String id;
  final double total;
  final String address;
  final String phoneNumber;
  final String paymentMethod;
  final List<OrderItem> items;
  final DateTime date;

  Order({
    required this.id,
    required this.total,
    required this.address,
    required this.phoneNumber,
    required this.paymentMethod,
    required this.items,
    required this.date,
  });
}
