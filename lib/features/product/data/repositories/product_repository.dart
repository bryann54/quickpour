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

  // Add this new method for recommended products
  Future<List<ProductModel>> getRecommendedProducts({int limit = 10}) async {
    try {
      // You can adjust this query to determine what "recommended" means for your app
      // For example, you might sort by rating, popularity, or use some recommendation logic
      final QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .orderBy('rating',
              descending: true) // Assuming products have a rating field
          .limit(limit)
          .get();

      return querySnapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching recommended products: $e');
    }
  }
}
