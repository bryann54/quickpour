
import 'package:chupachap/features/categories/data/models/category_model.dart';
import 'package:chupachap/features/farmer/data/models/farmer_model.dart';

class ProductModel {
  final String id;
  final String productName;
  final List<String> imageUrls;
  final double price;
  final String metrics;
  final String description;
  final CategoryModel category;
  final Farmer farmer;

  ProductModel({
    required this.id,
    required this.farmer,
    required this.productName,
    required this.imageUrls,
    required this.price,
    required this.metrics,
    required this.description,
    required this.category,
  });
}
