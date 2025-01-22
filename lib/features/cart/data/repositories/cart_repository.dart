import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/cart/data/models/cart_model.dart';

class CartRepository {
  final FirebaseFirestore firestore;
  final AuthRepository _authRepository;

  CartRepository(this._authRepository, this.firestore);

  // Add or update a cart item
  Future<void> addOrUpdateCartItem(CartItem cartItem) async {
    try {
      String? userId = _authRepository.getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      final cartDoc = firestore.collection('cartItems').doc(userId);

      await cartDoc.set({
        'items': FieldValue.arrayUnion([cartItem.toMap()]),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to add/update cart item: $e');
    }
  }

  // Remove a cart item
  Future<void> removeCartItem(String productId) async {
    try {
      String? userId = _authRepository.getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      final cartDoc = firestore.collection('cartItems').doc(userId);

      final cartData = await cartDoc.get();
      if (!cartData.exists) return;

      List<dynamic> items = cartData.data()?['items'] ?? [];
      items.removeWhere((item) => item['product']['id'] == productId);

      await cartDoc.update({'items': items});
    } catch (e) {
      throw Exception('Failed to remove cart item: $e');
    }
  }

  // Fetch cart items
  Future<Cart> getCartItems() async {
    try {
      String? userId = _authRepository.getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      final cartDoc =
          await firestore.collection('cartItems').doc(userId).get();

      if (!cartDoc.exists) return const Cart();

      final data = cartDoc.data() as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>).map((item) {
        return CartItem(
          product: ProductModel.fromFirestore(item['product']),
          quantity: item['quantity'],
        );
      }).toList();

      return Cart(items: items);
    } catch (e) {
      throw Exception('Failed to fetch cart items: $e');
    }
  }

  // Clear the cart
  Future<void> clearCart() async {
    try {
      String? userId = _authRepository.getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      await firestore.collection('cartItems').doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }
}
