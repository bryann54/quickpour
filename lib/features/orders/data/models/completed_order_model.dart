import 'package:chupachap/features/orders/data/models/order_model.dart';

class CompletedOrder {
  final String id;
  final DateTime date;
  final double total;
  final String address;
  final String phoneNumber;
  final String paymentMethod;
  final List<OrderItem> items;

  CompletedOrder({
    required this.id,
    required this.date,
    required this.total,
    required this.address,
    required this.phoneNumber,
    required this.paymentMethod,
    required this.items,
  });
}
