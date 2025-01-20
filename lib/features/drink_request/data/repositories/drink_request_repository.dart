import 'package:chupachap/features/drink_request/data/models/drink_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrinkRequestRepository {

    final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Use _firestore directly



  DrinkRequestRepository();

  Future<void> addDrinkRequest(DrinkRequest request) async {
    try {
      await _firestore.collection('drinkRequests').add(request.toMap());
    } catch (e) {
      throw Exception('Failed to add drink request: $e');
    }
  }

  Future<void> deleteDrinkRequest(String id) async {
    try {
      await _firestore.collection('drinkRequests').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete drink request: $e');
    }
  }
// Stream<List<Map<String, dynamic>>> streamOffers(String drinkRequestId) {
//     return _firestore
//         .collection('drinkRequests') // Access the main collection
//         .doc(drinkRequestId) // Specify the document ID for the drink request
//         .collection('offers') // Access the nested "offers" collection
//         .orderBy('timestamp', descending: true) // Order the offers by timestamp
//         .snapshots() // Get real-time updates
//         .map((snapshot) => snapshot.docs
//             .map((doc) => {
//                   'id': doc.id, // Include the document ID if needed
//                   ...doc.data() as Map<String, dynamic>, // Add document fields
//                 })
//             .toList());
//   }


  Future<List<DrinkRequest>> getDrinkRequests() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('drinkRequests')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map(
              (doc) => DrinkRequest.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch drink requests: $e');
    }
  }

  Stream<List<DrinkRequest>> streamDrinkRequests() {
    return _firestore
        .collection('drinkRequests')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                DrinkRequest.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
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
