import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chupachap/features/orders/data/models/completed_order_model.dart';

class OrdersRepository {
  final FirebaseFirestore _firestore;

  OrdersRepository(this._firestore);

  Future<List<CompletedOrder>> getOrders() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();

      List<CompletedOrder> orders = [];

      for (var doc in querySnapshot.docs) {
        try {
          final order = CompletedOrder.fromFirebase(doc.data(), doc.id);
          orders.add(order);
        } catch (e) {
          // Continue processing other orders
          continue;
        }
      }

      return orders;
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }
}
