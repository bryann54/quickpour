import 'package:chupachap/features/cart/data/models/cart_model.dart';
import 'package:equatable/equatable.dart';

class MerchantOrder extends Equatable {
  final String merchantId;
  final String merchantName;
  final String merchantEmail;
  final String merchantLocation;
  final String merchantStoreName;
  final String merchantImageUrl;
  final double merchantRating;
  final bool isMerchantVerified;
  final bool isMerchantOpen;
  final List<CartItem> items;
  final double subtotal;

  const MerchantOrder({
    required this.merchantId,
    required this.merchantName,
    required this.merchantEmail,
    required this.merchantLocation,
    required this.merchantStoreName,
    required this.merchantImageUrl,
    required this.merchantRating,
    required this.isMerchantVerified,
    required this.isMerchantOpen,
    required this.items,
    required this.subtotal,
  });

  Map<String, dynamic> toJson() => {
        'merchantId': merchantId,
        'merchantName': merchantName,
        'merchantEmail': merchantEmail,
        'merchantLocation': merchantLocation,
        'merchantStoreName': merchantStoreName,
        'merchantImageUrl': merchantImageUrl,
        'merchantRating': merchantRating,
        'isMerchantVerified': isMerchantVerified,
        'isMerchantOpen': isMerchantOpen,
        'items': items
            .map((item) => {
                  'productName': item.product.productName,
                  'quantity': item.quantity,
                  'price': item.product.price,
                  'image': item.product.imageUrls,
                  'productId': item.product.id,
                  'sku': item.product.sku,
                  'measure': item.product.measure,
                })
            .toList(),
        'subtotal': subtotal,
      };

  @override
  List<Object?> get props => [
        merchantId,
        merchantName,
        items,
        subtotal,
      ];
}
