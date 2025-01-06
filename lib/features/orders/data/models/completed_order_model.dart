import 'package:chupachap/features/orders/data/models/order_model.dart';

class CompletedOrder {
  final String id;
  final DateTime date;
  final double total;
  final String address;
  final String deliveryTime; // Adjusted to match data structure
  final String phoneNumber;
  final String paymentMethod;
  final List<OrderItem> items;
  final String userEmail; // Added based on provided Firebase data
  final String userName; // Added based on provided Firebase data
  final String userId; // Added based on provided Firebase data

  CompletedOrder({
    required this.id,
    required this.date,
    required this.total,
    this.deliveryTime = 'No delivery time specified', // Default value
    this.address = 'No address provided', // Default value
    this.phoneNumber = 'No phone number', // Default value
    this.paymentMethod = 'Not specified', // Default value
    required this.items,
    required this.userEmail,
    required this.userName,
    required this.userId,
  });

  // Add a factory constructor to create from Firebase data
  factory CompletedOrder.fromFirebase(Map<String, dynamic> data, String docId) {
    DateTime orderDate;
    try {
      orderDate = DateTime.parse(data['date'] as String);
    } catch (e) {
      orderDate = DateTime.now(); // Fallback to current date if parsing fails
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
      deliveryTime:
          data['deliveryTime'] as String? ?? 'No delivery time specified',
      phoneNumber: data['phoneNumber'] as String? ?? 'No phone number',
      paymentMethod: data['paymentMethod'] as String? ?? 'Not specified',
      items: orderItems,
      userEmail: data['userEmail'] as String? ?? 'No email provided',
      userName: data['userName'] as String? ?? 'No name provided',
      userId: data['userId'] as String? ?? 'No user ID provided',
    );
  }
}
