import 'package:chupachap/features/drink_request/data/models/drink_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrinkRequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DrinkRequestRepository();

  // Add a drink request to the 'drinkRequests' collection
  Future<void> addDrinkRequest(DrinkRequest request) async {
    try {
      await _firestore.collection('drinkRequests').add(request.toMap());
    } catch (e) {
      throw Exception('Failed to add drink request: $e');
    }
  }

  // Delete a drink request by ID
  Future<void> deleteDrinkRequest(String id) async {
    try {
      await _firestore.collection('drinkRequests').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete drink request: $e');
    }
  }

  // Fetch all drink requests with their IDs
  Future<List<DrinkRequest>> fetchDrinkRequests() async {
    try {
      final snapshot = await _firestore
          .collection('drinkRequests')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => DrinkRequest.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch drink requests: $e');
    }
  }

  // Fetch offers for a specific drink request
  Future<List<Map<String, dynamic>>> getOffers(String requestId) async {
    try {
      final snapshot = await _firestore
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

  // Fetch all drink requests along with their nested offers
  Future<List<DrinkRequest>> fetchDrinkRequestsWithOffers() async {
    try {
      final drinkRequestSnapshot = await _firestore
          .collection('drinkRequests')
          .orderBy('timestamp', descending: true)
          .get();

      final List<DrinkRequest> drinkRequests = [];

      for (final doc in drinkRequestSnapshot.docs) {
        final requestData = doc.data();
        final requestId = doc.id;

        // Fetch nested offers for each drink request
        final offersSnapshot = await _firestore
            .collection('drinkRequests')
            .doc(requestId)
            .collection('offers')
            .orderBy('timestamp', descending: true)
            .get();

        final offers = offersSnapshot.docs
            .map((offerDoc) => offerDoc.data() as Map<String, dynamic>)
            .toList();

        // Include the offers in the drink request
        drinkRequests.add(
          DrinkRequest.fromMap({
            ...requestData,
            'id': requestId,
            'offers': offers,
          }),
        );
      }

      return drinkRequests;
    } catch (e) {
      throw Exception('Failed to fetch drink requests with offers: $e');
    }
  }
}
