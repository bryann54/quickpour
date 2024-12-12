import 'package:bloc/bloc.dart';
import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:chupachap/features/brands/data/repositories/brand_repository.dart';
import 'package:equatable/equatable.dart';

part 'brands_event.dart';
part 'brands_state.dart';

class BrandsBloc extends Bloc<BrandsEvent, BrandsState> {
  final BrandRepository brandRepository;

  BrandsBloc({required this.brandRepository}) : super(BrandsInitialState()) {
    on<FetchBrandsEvent>(_onFetchBrands);
    // on<AddBrandEvent>(_onAddBrand);
    // on<UpdateBrandEvent>(_onUpdateBrand);
    // on<DeleteBrandEvent>(_onDeleteBrand);
  }

  void _onFetchBrands(FetchBrandsEvent event, Emitter<BrandsState> emit) async {
    emit(BrandsLoadingState());
    try {
      final brands = await brandRepository.getBrands();
      emit(BrandsLoadedState(brands));
    } catch (e) {
      emit(BrandsErrorState('Failed to load brands: ${e.toString()}'));
    }
  }

  // void _onAddBrand(AddBrandEvent event, Emitter<BrandsState> emit) async {
  //   if (state is BrandsLoadedState) {
  //     try {
  //       final currentBrands = (state as BrandsLoadedState).brands;
  //       final updatedBrands = List<BrandModel>.from(currentBrands)
  //         ..add(event.brand);

  //       // Optional: Add to repository if supported
  //       await brandRepository.addBrand(event.brand);

  //       emit(BrandsLoadedState(updatedBrands));
  //     } catch (e) {
  //       emit(BrandsErrorState('Failed to add brand: ${e.toString()}'));
  //     }
  //   }
  // }

  // void _onUpdateBrand(UpdateBrandEvent event, Emitter<BrandsState> emit) async {
  //   if (state is BrandsLoadedState) {
  //     try {
  //       final currentBrands = (state as BrandsLoadedState).brands;
  //       final updatedBrands = currentBrands
  //           .map((brand) => brand.id == event.brand.id ? event.brand : brand)
  //           .toList();

  //       // Optional: Update in repository if supported
  //       await brandRepository.updateBrand(event.brand);

  //       emit(BrandsLoadedState(updatedBrands));
  //     } catch (e) {
  //       emit(BrandsErrorState('Failed to update brand: ${e.toString()}'));
  //     }
  //   }
  // }

  // void _onDeleteBrand(DeleteBrandEvent event, Emitter<BrandsState> emit) async {
  //   if (state is BrandsLoadedState) {
  //     try {
  //       final currentBrands = (state as BrandsLoadedState).brands;
  //       final updatedBrands =
  //           currentBrands.where((brand) => brand.id != event.brandId).toList();

  //       // Optional: Delete from repository if supported
  //       await brandRepository.deleteBrand(event.brandId);

  //       emit(BrandsLoadedState(updatedBrands));
  //     } catch (e) {
  //       emit(BrandsErrorState('Failed to delete brand: ${e.toString()}'));
  //     }
  //   }
  // }
}
