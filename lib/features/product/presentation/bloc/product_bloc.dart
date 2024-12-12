import 'package:chupachap/features/product/data/repositories/product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository})
      : super(ProductInitialState()) {
    on<FetchProductsEvent>(_onFetchProducts);
  }

  void _onFetchProducts(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState());

    try {
      final products = await productRepository.getProducts();
      emit(ProductLoadedState(products: products));
    } catch (e) {
      emit(const ProductErrorState(errorMessage: 'Failed to load products'));
    }
  }
}
