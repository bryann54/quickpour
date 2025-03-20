import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chupachap/features/merchant/data/models/merchants_model.dart';

class MerchantsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final int _pageSize = 10;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;

  Future<List<Merchants>> getMerchants() async {
    _lastDocument = null;
    _hasMoreData = true;
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('merchants')
          .orderBy('name')
          .limit(_pageSize)
          .get();
      _updatePaginationState(querySnapshot);
      return _snapshotToMerchants(querySnapshot);
    } catch (e) {
      throw Exception('Error fetching merchants: $e');
    }
  }

  Future<List<Merchants>> getNextMerchantsPage() async {
    if (!_hasMoreData || _lastDocument == null) {
      return [];
    }

    try {
      final query = _firestore
          .collection('merchants')
          .orderBy('name')
          .startAfterDocument(_lastDocument!)
          .limit(_pageSize);

      final snapshot = await query.get();
      _updatePaginationState(snapshot);
      return _snapshotToMerchants(snapshot);
    } catch (e) {
      throw Exception('Failed to fetch more merchants: ${e.toString()}');
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

  List<Merchants> _snapshotToMerchants(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Merchants.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
