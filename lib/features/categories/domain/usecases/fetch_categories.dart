import '../entities/category.dart';
import '../../data/repositories/category_repository.dart';

class FetchCategories {
  final CategoryRepository repository;

  FetchCategories(this.repository);

  Future<List<Category>> call() async {
    final categories = await repository.getCategories();
    return categories
        .map((model) => Category(
              id: model.id,
              name: model.name,
              imageUrl: model.imageUrl,
            ))
        .toList();
  }
}
