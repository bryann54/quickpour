import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/drink_request/data/models/drink_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrinkRequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthRepository _authRepository;

  DrinkRequestRepository(this._authRepository);

  Future<void> addDrinkRequest(DrinkRequest request) async {
    try {
      String? userId = _authRepository.getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      // Create a new request with the current user's ID
      final requestWithUser = DrinkRequest(
        id: request.id,
        drinkName: request.drinkName,
        userId: userId,
        quantity: request.quantity,
        timestamp: request.timestamp,
        merchantId: request.merchantId,
        additionalInstructions: request.additionalInstructions,
        preferredTime: request.preferredTime,
      );

      await _firestore.collection('drinkRequests').add(requestWithUser.toMap());
    } catch (e) {
      throw Exception('Failed to add drink request: $e');
    }
  }

  Future<List<DrinkRequest>> getDrinkRequests() async {
    try {
      String? userId = _authRepository.getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      final QuerySnapshot snapshot = await _firestore
          .collection('drinkRequests')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => DrinkRequest.fromMap({
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch drink requests: $e');
    }
  }

  Stream<List<DrinkRequest>> streamDrinkRequests() {
    String? userId = _authRepository.getCurrentUserId();
    if (userId == null) throw Exception('User not authenticated');

    return _firestore
        .collection('drinkRequests')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => DrinkRequest.fromMap({
                  'id': doc.id,
                  ...doc.data() as Map<String, dynamic>,
                }))
            .toList());
  }

  Future<void> deleteDrinkRequest(String id) async {
    try {
      String? userId = _authRepository.getCurrentUserId();
      if (userId == null) throw Exception('User not authenticated');

      // Verify the request belongs to the current user before deleting
      final doc = await _firestore.collection('drinkRequests').doc(id).get();
      if (doc.exists && (doc.data() as Map<String, dynamic>)['userId'] == userId) {
        await _firestore.collection('drinkRequests').doc(id).delete();
      } else {
        throw Exception('Unauthorized to delete this request');
      }
    } catch (e) {
      throw Exception('Failed to delete drink request: $e');
    }
  }
Future<List<Map<String, dynamic>>> getOffers(String requestId) async {
    try {
      // Fetch from nested 'offers' collection
      final QuerySnapshot snapshot = await _firestore
          .collection('drinkRequests')
          .doc(requestId)
          .collection('offers')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch offers: $e');
    }
  }

}