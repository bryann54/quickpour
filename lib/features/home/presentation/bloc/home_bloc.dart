import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:chupachap/features/brands/data/repositories/brand_repository.dart';
import 'package:chupachap/features/categories/data/repositories/category_repository.dart';
import 'package:chupachap/features/categories/domain/entities/category.dart';
import 'package:chupachap/features/home/presentation/bloc/home_event.dart';
import 'package:chupachap/features/home/presentation/bloc/home_state.dart';
import 'package:chupachap/features/merchant/data/models/merchants_model.dart';
import 'package:chupachap/features/merchant/data/repositories/merchants_repository.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:chupachap/features/product/data/repositories/product_repository.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MerchantsRepository merchantRepository;
  final BrandRepository brandsRepository;
  final CategoryRepository categoryRepository;
  final ProductRepository productRepository;

  HomeBloc({
    required this.merchantRepository,
    required this.brandsRepository,
    required this.categoryRepository,
    required this.productRepository,
  }) : super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(const HomeLoading());

      // Fetch all data in parallel
      final results = await Future.wait([
        merchantRepository.getMerchants(),
        brandsRepository.getBrands(),
        categoryRepository.getCategories(),
        productRepository.getProducts(),
      ]);

      emit(HomeLoaded(
        merchants: results[0] as List<Merchants>,
        brands: results[1] as List<BrandModel>,
        categories: results[2] as List<Category>,
        products: results[3] as List<ProductModel>,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (state is HomeLoaded) {
        final currentState = state as HomeLoaded;
        emit(currentState.copyWith(isProductsLoading: true));

        final results = await Future.wait([
          merchantRepository.getMerchants(),
          brandsRepository.getBrands(),
          categoryRepository.getCategories(),
          productRepository.getProducts(),
        ]);

        emit(HomeLoaded(
          merchants: results[0] as List<Merchants>,
          brands: results[1] as List<BrandModel>,
          categories: results[2] as List<Category>,
          products: results[3] as List<ProductModel>,
        ));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
