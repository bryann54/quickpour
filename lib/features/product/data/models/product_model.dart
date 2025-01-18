
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String productName;
  final List<String> imageUrls;
  final double price;
  final double discountPrice;
  final String merchantId;
  final String brandName;
  final String categoryName;
  final String description;
  final String sku;
  final int stockQuantity;
  final bool isAvailable;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.productName,
    required this.imageUrls,
    required this.price,
    required this.discountPrice,
    required this.merchantId,
    required this.brandName,
    required this.categoryName,
    required this.description,
    required this.sku,
    required this.stockQuantity,
    required this.isAvailable,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      productName: data['productName'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      price: (data['price'] ?? 0).toDouble(),
      discountPrice: (data['discountPrice'] ?? 0).toDouble(),
      merchantId: data['merchantId'] ?? '',
      brandName: data['brandName'] ?? '',
      categoryName: data['categoryName'] ?? '',
      description: data['description'] ?? '',
      sku: data['sku'] ?? '',
      stockQuantity: data['stockQuantity'] ?? 0,
      isAvailable: data['isAvailable'] ?? false,
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'imageUrls': imageUrls,
      'price': price,
      'discountPrice': discountPrice,
      'merchantId': merchantId,
      'brandName': brandName,
      'categoryName': categoryName,
      'description': description,
      'sku': sku,
      'stockQuantity': stockQuantity,
      'isAvailable': isAvailable,
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
