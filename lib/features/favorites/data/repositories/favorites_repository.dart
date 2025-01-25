import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';

class FavoritesRepository {
  final FirebaseFirestore _firestore;
  final AuthRepository _authRepository;

  FavoritesRepository({
    required FirebaseFirestore firestore,
    required AuthRepository authRepository,
  })  : _firestore = firestore,
        _authRepository = authRepository;

  Future<void> addToFavorites(ProductModel product) async {
    final userId = _authRepository.getCurrentUserId();
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(product.id)
        .set(product.toJson());
  }

  Future<void> removeFromFavorites(ProductModel product) async {
    final userId = _authRepository.getCurrentUserId();
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(product.id)
        .delete();
  }

  Stream<List<ProductModel>> getFavorites() {
    final userId = _authRepository.getCurrentUserId();
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList());
  }

  Future<bool> isFavorite(ProductModel product) async {
    final userId = _authRepository.getCurrentUserId();
    if (userId == null) return false;

    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(product.id)
        .get();

    return doc.exists;
  }
}
