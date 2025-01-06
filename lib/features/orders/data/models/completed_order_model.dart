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
    this.address = 'No address provided', // Default value
    this.phoneNumber = 'No phone number', // Default value
    this.paymentMethod = 'Not specified', // Default value
    required this.items,
  });

  // Add a factory constructor to create from Firebase data
  factory CompletedOrder.fromFirebase(Map<String, dynamic> data, String docId) {
    DateTime orderDate;
    try {
      orderDate = DateTime.parse(data['date'] as String);
    } catch (e) {
      orderDate = DateTime.now();
    }

    List<OrderItem> orderItems = [];
    if (data['cartItems'] != null) {
      orderItems = (data['cartItems'] as List<dynamic>).map((item) {
        return OrderItem(
          name: item['productName'] as String? ?? '',
          quantity: item['quantity'] as int? ?? 0,
          price: (item['price'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();
    }

    return CompletedOrder(
      id: data['orderId'] as String? ?? docId,
      date: orderDate,
      total: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      address: data['address'] as String? ?? 'No address provided',
      phoneNumber: data['phoneNumber'] as String? ?? 'No phone number',
      paymentMethod: data['paymentMethod'] as String? ?? 'Not specified',
      items: orderItems,
    );
  }
}
