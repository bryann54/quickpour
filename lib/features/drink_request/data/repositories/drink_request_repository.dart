import 'package:chupachap/features/drink_request/data/models/drink_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrinkRequestRepository {
  final FirebaseFirestore firestore;

  DrinkRequestRepository({required this.firestore});

  Future<void> addDrinkRequest(DrinkRequest request) async {
    try {
      await firestore.collection('drinkRequests').add(request.toMap());
    } catch (e) {
      throw Exception('Failed to add drink request: $e');
    }
  }

  Future<void> deleteDrinkRequest(String id) async {
    try {
      await firestore.collection('drinkRequests').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete drink request: $e');
    }
  }

  Future<List<DrinkRequest>> fetchDrinkRequests() async {
    try {
      final snapshot = await firestore.collection('drinkRequests').get();
      return snapshot.docs
          .map((doc) => DrinkRequest.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch drink requests: $e');
    }
  }
}
