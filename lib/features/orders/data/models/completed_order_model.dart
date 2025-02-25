import 'package:chupachap/features/orders/data/models/order_model.dart';

class CompletedOrder {
  final String id;
  final DateTime date;
  final double total;
  final String address;
  final String deliveryTime;
  final String phoneNumber;
  final String paymentMethod;
  final List<OrderItem> items;
  final String userEmail;
  final String userName;
  final String userId;
  final String status;
  final String deliveryType;

  CompletedOrder({
    required this.status,
    required this.id,
    required this.date,
    required this.total,
    this.deliveryTime = 'No delivery time specified',
    this.address = 'No address provided',
    this.phoneNumber = 'No phone number',
    this.paymentMethod = 'Not specified',
    required this.items,
    required this.userEmail,
    required this.userName,
    required this.userId,
    this.deliveryType = 'No delivery type specified',
  });

  // factory constructor to create from Firebase data
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
      deliveryTime:
          data['deliveryTime'] as String? ?? 'No delivery time specified',
      phoneNumber: data['phoneNumber'] as String? ?? 'No phone number',
      paymentMethod: data['paymentMethod'] as String? ?? 'Not specified',
      items: orderItems,
      userEmail: data['userEmail'] as String? ?? 'No email provided',
      userName: data['userName'] as String? ?? 'No name provided',
      userId: data['userId'] as String? ?? 'No user ID provided',
      status: data['status'] as String? ?? 'Not specified',
      deliveryType:
          data['deliveryType'] as String? ?? 'No delivery type specified',
    );
  }
}
