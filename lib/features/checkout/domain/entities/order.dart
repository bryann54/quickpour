import 'package:chupachap/features/checkout/domain/entities/merchant_order.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final String orderId;
  final String userId;
  final String userEmail;
  final String userName;
  final String address;
  final String phoneNumber;
  final String paymentMethod;
  final String deliveryTime;
  final String specialInstructions;
  final String deliveryType;
  final List<MerchantOrder> merchantOrders;
  final double totalAmount;
  final DateTime date;
  final String status;

  const Order({
    required this.orderId,
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.address,
    required this.phoneNumber,
    required this.paymentMethod,
    required this.deliveryTime,
    required this.specialInstructions,
    required this.deliveryType,
    required this.merchantOrders,
    required this.totalAmount,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'userId': userId,
        'userEmail': userEmail,
        'userName': userName,
        'address': address,
        'phoneNumber': phoneNumber,
        'paymentMethod': paymentMethod,
        'deliveryTime': deliveryTime,
        'specialInstructions': specialInstructions,
        'deliveryType': deliveryType,
        'merchantOrders':
            merchantOrders.map((order) => order.toJson()).toList(),
        'totalAmount': totalAmount,
        'date': date.toIso8601String(),
        'status': status,
      };

  @override
  List<Object?> get props => [
        orderId,
        userId,
        address,
        phoneNumber,
        paymentMethod,
        deliveryTime,
        merchantOrders,
        totalAmount,
        date,
        status,
      ];
}
