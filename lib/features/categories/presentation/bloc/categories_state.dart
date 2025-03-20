import '../../domain/entities/category.dart';

abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;
  final bool hasMoreData;

  CategoriesLoaded({required this.categories, required this.hasMoreData});

  CategoriesLoaded copyWith({List<Category>? categories, bool? hasMoreData}) {
    return CategoriesLoaded(
      categories: categories ?? this.categories,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }
}

class CategoriesError extends CategoriesState {
  final String message;

  CategoriesError(this.message);
}
