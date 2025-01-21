import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chupachap/features/merchant/data/models/merchants_model.dart';

class MerchantsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Merchants>> getMerchants() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('merchants').get();

      return querySnapshot.docs.map((doc) {
        return Merchants.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching merchants from Firestore: $e');
    }
  }
}
