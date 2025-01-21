import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chupachap/features/categories/data/models/category_model.dart';

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('categories').get();
      return querySnapshot.docs.map((doc) {
        return CategoryModel(
          id: doc['id'],
          name: doc['name'],
          imageUrl: doc['imageUrl'],
        );
      }).toList();
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<void> addCategories(List<CategoryModel> categories) async {
    final batch = _firestore.batch();
    for (var category in categories) {
      final docRef = _firestore.collection('categories').doc(category.id);
      batch.set(docRef, {
        'id': category.id,
        'name': category.name,
        'imageUrl': category.imageUrl,
      });
    }
    await batch.commit();
  }
}
