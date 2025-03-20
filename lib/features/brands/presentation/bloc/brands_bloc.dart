import 'package:bloc/bloc.dart';
import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:chupachap/features/brands/data/repositories/brand_repository.dart';
import 'package:equatable/equatable.dart';

part 'brands_event.dart';
part 'brands_state.dart';

class BrandsBloc extends Bloc<BrandsEvent, BrandsState> {
  final BrandRepository brandRepository;
  bool _isLoadingMore = false;

  BrandsBloc({required this.brandRepository}) : super(BrandsInitialState()) {
    on<FetchBrandsEvent>(_onFetchBrands);
    on<LoadMoreBrandsEvent>(_onLoadMoreBrands);
  }

  Future<void> _onFetchBrands(
      FetchBrandsEvent event, Emitter<BrandsState> emit) async {
    emit(BrandsLoadingState());
    try {
      final brands = await brandRepository.getBrands();
      emit(BrandsLoadedState(
        brands,
        DateTime.now(),
        hasMoreData: brandRepository.hasMoreData,
      ));
    } catch (e) {
      emit(BrandsErrorState('Failed to load brands: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoreBrands(
      LoadMoreBrandsEvent event, Emitter<BrandsState> emit) async {
    // Guard against invalid states or duplicate loading
    if (state is! BrandsLoadedState || _isLoadingMore) {
      return;
    }

    final currentState = state as BrandsLoadedState;

    // If no more data, just return
    if (!currentState.hasMoreData) {
      return;
    }

    // Set loading more flag to prevent concurrent loads
    _isLoadingMore = true;

    try {
      // Show loading more state while maintaining current brands
      emit(BrandsLoadingMoreState(currentState.brands, currentState.timestamp));

      final newBrands = await brandRepository.getNextBrandsPage();

      emit(BrandsLoadedState(
        [...currentState.brands, ...newBrands],
        DateTime.now(),
        hasMoreData: brandRepository.hasMoreData,
      ));
    } catch (e) {
      // Revert to previous state with error
      emit(currentState.copyWith(
        errorMessage: 'Failed to load more brands: ${e.toString()}',
      ));
    } finally {
      _isLoadingMore = false;
    }
  }

}
