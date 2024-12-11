import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProductSearchState extends Equatable {
  const ProductSearchState();

  @override
  List<Object?> get props => [];
}

class ProductSearchInitialState extends ProductSearchState {}

class ProductSearchLoadingState extends ProductSearchState {}

class ProductSearchLoadedState extends ProductSearchState {
  final List<ProductModel> searchResults;

  const ProductSearchLoadedState(this.searchResults);

  @override
  List<Object?> get props => [searchResults];
}

class ProductSearchErrorState extends ProductSearchState {
  final String errorMessage;

  const ProductSearchErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
