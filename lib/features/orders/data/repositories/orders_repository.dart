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

      return querySnapshot.docs
          .map((doc) => CompletedOrder.fromFirebase(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching orders: $e'); // For debugging
      throw Exception('Failed to fetch orders: $e');
    }
  }
}
