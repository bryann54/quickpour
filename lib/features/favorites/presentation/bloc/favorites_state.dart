import 'package:chupachap/features/favorites/data/models/favorites_model.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';

class FavoritesState {
  final FavoritesModel favorites;

  FavoritesState({required this.favorites});

  bool isFavorite(ProductModel product) {
    return favorites.items.any((item) => item.product.id == product.id);
  }
}
