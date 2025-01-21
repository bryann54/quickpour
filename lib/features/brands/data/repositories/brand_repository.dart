import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BrandRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> uploadBrands(List<BrandModel> brands) async {
    try {
      WriteBatch batch = _firebaseFirestore.batch();

      for (var brand in brands) {
        DocumentReference brandRef =
            _firebaseFirestore.collection('brands').doc(brand.id);
        batch.set(brandRef, brand.toJson());
      }

      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BrandModel>> getBrands() async {
    try {
      QuerySnapshot querySnapshot =
          await _firebaseFirestore.collection('brands').get();

      List<BrandModel> brands = querySnapshot.docs
          .map((doc) => BrandModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return brands;
    } catch (e) {
      rethrow;
    }
  }
}
