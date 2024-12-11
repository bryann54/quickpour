import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'product_search_event.dart';
import 'product_search_state.dart';

class ProductSearchBloc extends Bloc<ProductSearchEvent, ProductSearchState> {
  final ProductRepository productRepository;
  List<ProductModel> _allProducts = [];

  ProductSearchBloc({required this.productRepository})
      : super(ProductSearchInitialState()) {
    on<SearchProductsEvent>(_onSearchProducts);
    on<FilterProductsEvent>(_onFilterProducts); // Add this line
  }

  void _onSearchProducts(
      SearchProductsEvent event, Emitter<ProductSearchState> emit) async {
    if (_allProducts.isEmpty) {
      emit(ProductSearchLoadingState());
      try {
        _allProducts = await productRepository.getProducts();
      } catch (e) {
        emit(ProductSearchErrorState('Failed to load products'));
        return;
      }
    }

    final query = event.query.toLowerCase();
    final searchResults = _allProducts.where((product) {
      return product.productName.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.name.toLowerCase().contains(query);
    }).toList();

    emit(ProductSearchLoadedState(searchResults));
  }

  Future<void> _onFilterProducts(
    FilterProductsEvent event,
    Emitter<ProductSearchState> emit,
  ) async {
    if (_allProducts.isEmpty) {
      emit(ProductSearchLoadingState());
      try {
        _allProducts = await productRepository.getProducts();
      } catch (e) {
        emit(ProductSearchErrorState('Failed to load products'));
        return;
      }
    }

    final filteredProducts = _allProducts.where((product) {
      bool matchesCategory =
          event.category == null || product.category.name == event.category;

      bool matchesStore =
          event.store == null || product.merchants.name == event.store;

      bool matchesPrice = event.priceRange == null ||
          (product.price >= event.priceRange!.start &&
              product.price <= event.priceRange!.end);

      return matchesCategory && matchesStore && matchesPrice;
    }).toList();

    emit(ProductSearchLoadedState(filteredProducts));
  }
}
