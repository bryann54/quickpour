import 'package:chupachap/features/orders/data/models/merchant_order_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedOrder {
  final String id;
  final double total;
  final DateTime date;
  final String address;
  final String phoneNumber;
  final String paymentMethod;
  final List<MerchantOrderItem> merchantOrders;
  final String userEmail;
  final String userName;
  final String userId;
  final String status;
  final String deliveryType;
  final String deliveryTime;
  final String specialInstructions;

  CompletedOrder({
    required this.id,
    required this.total,
    required this.date,
    required this.address,
    required this.phoneNumber,
    required this.paymentMethod,
    required this.merchantOrders,
    required this.userEmail,
    required this.userName,
    required this.userId,
    required this.status,
    this.deliveryType = 'No delivery type specified',
    this.deliveryTime = 'No delivery time specified',
    this.specialInstructions = '',
  });

  factory CompletedOrder.fromFirebase(Map<String, dynamic> data, String id) {
    DateTime parseDate(dynamic dateData) {
      if (dateData is Timestamp) {
        return dateData.toDate();
      } else if (dateData is String) {
        return DateTime.parse(dateData);
      }
      return DateTime.now();
    }

    return CompletedOrder(
      id: id,
      total: (data['totalAmount'] ?? 0).toDouble(),
      date: parseDate(data['date']),
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      paymentMethod: data['paymentMethod'] ?? '',
      merchantOrders: (data['merchantOrders'] as List<dynamic>?)
              ?.map((merchantData) => MerchantOrderItem.fromFirebase(
                  merchantData as Map<String, dynamic>))
              .toList() ??
          [],
      userEmail: data['userEmail'] ?? '',
      userName: data['userName'] ?? '',
      userId: data['userId'] ?? '',
      status: data['status'] ?? 'pending',
      deliveryType: data['deliveryType'] ?? 'No delivery type specified',
      deliveryTime: data['deliveryTime'] ?? 'No delivery time specified',
      specialInstructions: data['specialInstructions'] ?? '',
    );
  }
}
