import 'package:chupachap/features/promotions/presentation/bloc/promotions_event.dart';
import 'package:chupachap/features/promotions/presentation/bloc/promotions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';

class PromotionsBloc extends Bloc<PromotionsEvent, PromotionsState> {
  final ProductRepository productRepository;

  PromotionsBloc(this.productRepository) : super(PromotionsInitial()) {
    on<FetchPromotions>((event, emit) async {
      emit(PromotionsLoading());
      try {
        final products = await productRepository.getProducts();
        emit(PromotionsLoaded(products));
      } catch (e) {
        emit(PromotionsError(e.toString()));
      }
    });
  }
}
