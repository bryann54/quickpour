import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';

class CartRepository {
  final FirebaseFirestore firestore;

  CartRepository({required this.firestore});

  Future<void> addToCart(String userId, CartItem cartItem) async {
    final cartRef =
        firestore.collection('users').doc(userId).collection('cart');

    await cartRef.doc(cartItem.product.id).set({
      'productId': cartItem.product.id,
      'quantity': cartItem.quantity,
      'productName': cartItem.product.productName,
      'price': cartItem.product.price,
      'discountPrice': cartItem.product.discountPrice,
      'imageUrls': cartItem.product.imageUrls,
      'createdAt': FieldValue.serverTimestamp(),
      // Merchant Details
      'merchantId': cartItem.product.merchantId,
      'merchantName': cartItem.product.merchantName,
      'merchantEmail': cartItem.product.merchantEmail,
      'merchantLocation': cartItem.product.merchantLocation,
      'merchantStoreName': cartItem.product.merchantStoreName,
      'merchantImageUrl': cartItem.product.merchantImageUrl,
      'merchantRating': cartItem.product.merchantRating,
      'isMerchantVerified': cartItem.product.isMerchantVerified,
      'isMerchantOpen': cartItem.product.isMerchantOpen,
    });
  }

  Future<void> removeFromCart(String userId, String productId) async {
    final cartRef =
        firestore.collection('users').doc(userId).collection('cart');
    await cartRef.doc(productId).delete();
  }

  Future<void> updateCartQuantity(
      String userId, String productId, int quantity) async {
    final cartRef =
        firestore.collection('users').doc(userId).collection('cart');
    await cartRef.doc(productId).update({'quantity': quantity});
  }

  Future<List<CartItem>> getCartItems(String userId) async {
    final cartRef =
        firestore.collection('users').doc(userId).collection('cart');
    final snapshot = await cartRef.get();

    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          try {
            return CartItem(
              product: ProductModel(
                id: data['productId'] ?? '',
                productName: data['productName'] ?? 'Unknown Product',
                price: (data['price'] ?? 0.0).toDouble(),
                discountPrice: data['discountPrice'] != null &&
                        data['discountPrice'] > 0 &&
                        data['discountPrice'] < data['price']
                    ? data['discountPrice'].toDouble()
                    : data['price'].toDouble(),
                imageUrls: data['imageUrls'] != null
                    ? List<String>.from(data['imageUrls'])
                    : [],
                measure: data['measure'] ?? '',
                merchantId: data['merchantId'] ?? '',
                merchantName: data['merchantName'] ?? '',
                merchantEmail: data['merchantEmail'] ?? '',
                merchantLocation: data['merchantLocation'] ?? '',
                merchantStoreName: data['merchantStoreName'] ?? '',
                merchantImageUrl: data['merchantImageUrl'] ?? '',
                merchantRating: (data['merchantRating'] ?? 0.0).toDouble(),
                isMerchantVerified: data['isMerchantVerified'] ?? false,
                isMerchantOpen: data['isMerchantOpen'] ?? false,
                brandName: data['brandName'] ?? '',
                categoryName: data['categoryName'] ?? '',
                description: data['description'] ?? '',
                sku: data['sku'] ?? '',
                stockQuantity: 0,
                isAvailable: true,
                tags: [],
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
              quantity: (data['quantity'] ?? 0),
            );
          } catch (e) {
            return null;
          }
        })
        .whereType<CartItem>()
        .toList();
  }
}
