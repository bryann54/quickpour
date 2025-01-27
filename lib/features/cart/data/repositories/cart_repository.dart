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

    // Filter out any potentially problematic entries
    return snapshot.docs
        .map((doc) {
          final data = doc.data();
          try {
            return CartItem(
              product: ProductModel(
                id: data['productId'] ?? '',
                productName: data['productName'] ?? 'Unknown Product',
                price: (data['price'] ?? 0.0).toDouble(),
                imageUrls: data['imageUrls'] != null
                    ? List<String>.from(data['imageUrls'])
                    : [],
                discountPrice: data['discountPrice'] != null &&
                        data['discountPrice'] > 0 &&
                        data['discountPrice'] < data['price']
                    ? data['discountPrice'].toDouble()
                    : data['price'].toDouble(),
                merchantId: '',
                brandName: '',
                categoryName: '',
                description: '',
                sku: '',
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
