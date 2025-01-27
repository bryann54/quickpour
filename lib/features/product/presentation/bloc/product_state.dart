import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {
  final List<ProductModel>? cachedProducts;

  const ProductLoadingState({this.cachedProducts});

  @override
  List<Object> get props => cachedProducts ?? [];
}

class ProductLoadedState extends ProductState {
  final List<ProductModel> products;
  final DateTime lastFetched;

  const ProductLoadedState({
    required this.products,
    required this.lastFetched,
  });

  @override
  List<Object> get props => [products, lastFetched];

  bool get shouldRefetch {
    final now = DateTime.now();
    final difference = now.difference(lastFetched);
    // Refetch if data is older than 5 minutes
    return difference.inMinutes >= 5;
  }
}

class ProductErrorState extends ProductState {
  final String errorMessage;
  final List<ProductModel>? cachedProducts;

  const ProductErrorState({
    required this.errorMessage,
    this.cachedProducts,
  });

  @override
  List<Object> get props => [errorMessage, cachedProducts ?? []];
}
