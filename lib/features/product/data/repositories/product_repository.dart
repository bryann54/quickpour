import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _pageSize = 10; // Number of products per page
  DocumentSnapshot? _lastDocument; // Tracks the last document retrieved
  bool _hasMoreData = true; // Flag to check if more data is available

  // Get the first page of products
  Future<List<ProductModel>> getProducts() async {
    try {
      // Reset pagination state
      _lastDocument = null;
      _hasMoreData = true;

      final QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .orderBy('createdAt', descending: true) // Adjust ordering as needed
          .limit(_pageSize)
          .get();

      // Update pagination state
      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
      } else {
        _hasMoreData = false;
      }

      return querySnapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching products from Firestore: $e');
    }
  }

  // Get next page of products
  Future<List<ProductModel>> getNextProductsPage() async {
    if (!_hasMoreData || _lastDocument == null) {
      return [];
    }

    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .orderBy('createdAt',
              descending: true) // Use same ordering as initial query
          .startAfterDocument(_lastDocument!)
          .limit(_pageSize)
          .get();

      // Update pagination state
      if (querySnapshot.docs.isEmpty) {
        _hasMoreData = false;
        return [];
      }

      _lastDocument = querySnapshot.docs.last;

      return querySnapshot.docs.map((doc) {
        return ProductModel.fromFirestore(doc);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching next page of products: $e');
    }
  }

  // Check if more data is available
  bool hasMoreData() {
    return _hasMoreData;
  }

  // Add method for recommended products with pagination support
  Future<List<ProductModel>> getRecommendedProducts({int limit = 10}) async {
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .orderBy('rating', descending: true)
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
