
import 'package:chupachap/features/categories/data/models/category_model.dart';

class Category {
  final String id;
  final String name;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  // Convert Category to CategoryModel
  CategoryModel toCategoryModel() {
    return CategoryModel(
      id: id,
      name: name,
      imageUrl: imageUrl,
    );
  }
}
