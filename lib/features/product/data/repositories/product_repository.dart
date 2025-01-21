import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> getProducts() async {
    try {
      final QuerySnapshot querySnapshot =
          await _firestore.collection('products').get();

      return querySnapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products from Firestore: $e');
    }
  }

  Future<void> uploadProduct(ProductModel product) async {
    try {
      await _firestore.collection('products').doc(product.id).set(
            product.toJson(),
            SetOptions(merge: true),
          );
    } catch (e) {
      throw Exception('Error uploading product to Firestore: $e');
    }
  }
}
