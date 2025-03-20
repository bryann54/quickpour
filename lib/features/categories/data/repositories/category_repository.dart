import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chupachap/features/categories/data/models/category_model.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _pageSize = 18;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  Future<List<CategoryModel>> getCategories() async {
    _lastDocument = null;
    _hasMoreData = true;
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('categories')
          .orderBy('name')
          .limit(_pageSize)
          .get();
      _updatePaginationState(querySnapshot);
      return _snapshotToCategories(querySnapshot);
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<List<CategoryModel>> getNextCategoriesPage() async {
    if (!_hasMoreData || _lastDocument == null) {
      return [];
    }

    try {
      final query = _firestore
          .collection('categories')
          .orderBy('name')
          .startAfterDocument(_lastDocument!)
          .limit(_pageSize);

      final snapshot = await query.get();
      _updatePaginationState(snapshot);
      return _snapshotToCategories(snapshot);
    } catch (e) {
      throw Exception('Failed to fetch more categories: ${e.toString()}');
    }
  }

  void _updatePaginationState(QuerySnapshot snapshot) {
    if (snapshot.docs.isEmpty) {
      _hasMoreData = false;
      return;
    }
    _lastDocument = snapshot.docs.last;
    _hasMoreData = snapshot.docs.length == _pageSize;
  }

  List<CategoryModel> _snapshotToCategories(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return CategoryModel(
        id: doc['id'],
        name: doc['name'],
        imageUrl: doc['imageUrl'],
      );
    }).toList();
  }
}
