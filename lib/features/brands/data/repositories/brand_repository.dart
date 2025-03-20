import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chupachap/features/brands/data/models/brands_model.dart';

class BrandRepository {
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _pageSize = 12;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;



  bool get hasMoreData => _hasMoreData;

  Future<List<BrandModel>> getBrands() async {
    // Reset pagination state when fetching from beginning
    _lastDocument = null;
    _hasMoreData = true;

    try {
      final query =
          _firestore.collection('brands').orderBy('name').limit(_pageSize);

      final snapshot = await query.get();
      _updatePaginationState(snapshot);

      return _snapshotToBrands(snapshot);
    } catch (e) {
      throw Exception('Failed to fetch brands: ${e.toString()}');
    }
  }

  Future<List<BrandModel>> getNextBrandsPage() async {
    if (!_hasMoreData || _lastDocument == null) {
      return [];
    }

    try {
      final query = _firestore
          .collection('brands')
          .orderBy('name')
          .startAfterDocument(_lastDocument!)
          .limit(_pageSize);

      final snapshot = await query.get();
      _updatePaginationState(snapshot);

      return _snapshotToBrands(snapshot);
    } catch (e) {
      throw Exception('Failed to fetch more brands: ${e.toString()}');
    }
  }

  void _updatePaginationState(QuerySnapshot snapshot) {
    if (snapshot.docs.isEmpty) {
      _hasMoreData = false;
      return;
    }

    if (snapshot.docs.length < _pageSize) {
      _hasMoreData = false;
    }

    _lastDocument = snapshot.docs.last;
  }

  List<BrandModel> _snapshotToBrands(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return BrandModel.fromJson(doc.data() as Map<String, dynamic>, );
    }).toList();
  }
}
