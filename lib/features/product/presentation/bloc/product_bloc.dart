import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:chupachap/features/product/presentation/bloc/product_event.dart';
import 'package:chupachap/features/product/presentation/bloc/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// product_bloc.dart
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository})
      : super(ProductInitialState()) {
    on<FetchProductsEvent>(_onFetchProducts);
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
}
