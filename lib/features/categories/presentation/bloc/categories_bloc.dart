import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/fetch_categories.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final FetchCategories fetchCategories;
  final FetchNextCategoriesPage fetchNextCategoriesPage;

  CategoriesBloc(this.fetchCategories, this.fetchNextCategoriesPage)
      : super(CategoriesInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<LoadMoreCategories>(_onLoadMoreCategories);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoriesState> emit) async {
    emit(CategoriesLoading());
    try {
      final categories = await fetchCategories();
      emit(CategoriesLoaded(categories: categories, hasMoreData: true));
    } catch (e) {
      emit(CategoriesError('Failed to load categories'));
    }
  }

  Future<void> _onLoadMoreCategories(
      LoadMoreCategories event, Emitter<CategoriesState> emit) async {
    final currentState = state;
    if (currentState is CategoriesLoaded && currentState.hasMoreData) {
      try {
        final newCategories = await fetchNextCategoriesPage();
        if (newCategories.isEmpty) {
          emit(currentState.copyWith(hasMoreData: false));
        } else {
          emit(currentState.copyWith(
              categories: List.of(currentState.categories)
                ..addAll(newCategories),
              hasMoreData: true));
        }
      } catch (e) {
        emit(CategoriesError('Failed to load more categories'));
      }
    }
  }
}
