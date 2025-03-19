import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/bloc/product_event.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  bool _isLoadingMore = false;

  ProductBloc({required this.productRepository})
      : super(ProductInitialState()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<LoadMoreProductsEvent>(_onLoadMoreProducts);
  }

  void _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    // Check if we have cached data and if it's still valid
    if (state is ProductLoadedState) {
      final currentState = state as ProductLoadedState;
      if (!currentState.shouldRefetch) {
        // Use cached data if it's still valid
        return;
      }
      // Show loading state with cached data while fetching
      emit(ProductLoadingState(cachedProducts: currentState.products));
    } else {
      emit(const ProductLoadingState());
    }

    try {
      final products = await productRepository.getProducts();
      emit(ProductLoadedState(
        products: products,
        lastFetched: DateTime.now(),
        hasMoreData: productRepository.hasMoreData(),
      ));
    } catch (e) {
      // Keep cached products in error state if available
      final cachedProducts = state is ProductLoadingState
          ? (state as ProductLoadingState).cachedProducts
          : null;

      emit(ProductErrorState(
        errorMessage: 'Failed to load products',
        cachedProducts: cachedProducts,
      ));
    }
  }

  void _onLoadMoreProducts(
    LoadMoreProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    // Prevent multiple simultaneous pagination requests
    if (_isLoadingMore) return;

    // Can only load more if we're in the loaded state
    if (state is! ProductLoadedState) return;

    final currentState = state as ProductLoadedState;

    // Don't load more if there's no more data
    if (!currentState.hasMoreData) return;

    _isLoadingMore = true;

    try {
      // Load next batch
      final moreProducts = await productRepository.getNextProductsPage();

      // Combine with existing products
      final allProducts = List<ProductModel>.from(currentState.products)
        ..addAll(moreProducts);

      emit(ProductLoadedState(
        products: allProducts,
        lastFetched: currentState.lastFetched,
        hasMoreData: productRepository.hasMoreData(),
      ));
    } catch (e) {
      // On error, keep the current products but show error state
      emit(ProductErrorState(
        errorMessage: 'Failed to load more products',
        cachedProducts: currentState.products,
      ));
    } finally {
      _isLoadingMore = false;
    }
  }
}
