import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:chupachap/features/categories/domain/entities/category.dart';
import 'package:chupachap/features/merchant/data/models/merchants_model.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}

class HomeLoaded extends HomeState {
  final List<Merchants> merchants;
  final List<BrandModel> brands;
  final List<Category> categories;
  final List<ProductModel> products;
  final bool isProductsLoading;

  const HomeLoaded({
    required this.merchants,
    required this.brands,
    required this.categories,
    required this.products,
    this.isProductsLoading = false,
  });

  HomeLoaded copyWith({
    List<Merchants>? merchants,
    List<BrandModel>? brands,
    List<Category>? categories,
    List<ProductModel>? products,
    bool? isProductsLoading,
  }) {
    return HomeLoaded(
      merchants: merchants ?? this.merchants,
      brands: brands ?? this.brands,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      isProductsLoading: isProductsLoading ?? this.isProductsLoading,
    );
  }
}
