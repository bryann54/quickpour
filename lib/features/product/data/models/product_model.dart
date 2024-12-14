import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:chupachap/features/categories/data/models/category_model.dart';

import 'package:chupachap/features/merchant/data/models/merchants_model.dart';

class ProductModel {
  final String id;
  final String productName;
  final List<String> imageUrls;
  final double price;
  final Merchants merchants;
  final BrandModel brand;
  final String description;
  final CategoryModel category;

  ProductModel( {
   required this.brand,
    required this.id,
    required this.productName,
    required this.imageUrls,
    required this.price,
    required this.merchants,
    required this.description,
    required this.category,
  });
}
