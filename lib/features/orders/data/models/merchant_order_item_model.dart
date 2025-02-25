import 'package:chupachap/features/orders/data/models/order_model.dart';

class MerchantOrderItem {
  final String merchantId;
  final String merchantName;
  final String merchantEmail;
  final String merchantLocation;
  final String merchantImageUrl;
  final String merchantStoreName;
  final double merchantRating;
  final bool isMerchantVerified;
  final bool isMerchantOpen;
  final List<OrderItem> items;
  final double subtotal;

  MerchantOrderItem({
    required this.merchantId,
    required this.merchantName,
    required this.merchantEmail,
    required this.merchantLocation,
    required this.merchantImageUrl,
    required this.merchantStoreName,
    required this.merchantRating,
    required this.isMerchantVerified,
    required this.isMerchantOpen,
    required this.items,
    required this.subtotal,
  });

  factory MerchantOrderItem.fromFirebase(Map<String, dynamic> data) {
    return MerchantOrderItem(
      merchantId: data['merchantId'] ?? '',
      merchantName: data['merchantName'] ?? '',
      merchantEmail: data['merchantEmail'] ?? '',
      merchantLocation: data['merchantLocation'] ?? '',
      merchantImageUrl: data['merchantImageUrl'] ?? '',
      merchantStoreName: data['merchantStoreName'] ?? '',
      merchantRating: (data['merchantRating'] ?? 0).toDouble(),
      isMerchantVerified: data['isMerchantVerified'] ?? false,
      isMerchantOpen: data['isMerchantOpen'] ?? false,
      items: (data['items'] as List<dynamic>?)
              ?.map((item) =>
                  OrderItem.fromFirebase(item as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (data['subtotal'] ?? 0).toDouble(),
    );
  }
}
