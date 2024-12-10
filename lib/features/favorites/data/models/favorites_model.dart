
import 'package:chupachap/features/product/data/models/product_model.dart';

class FavoriteItem {
  final ProductModel product;

  FavoriteItem({required this.product});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteItem && product.id == other.product.id;

  @override
  int get hashCode => product.id.hashCode;
}

class FavoritesModel {
  final List<FavoriteItem> items;

  FavoritesModel({this.items = const []});

  FavoritesModel copyWith({List<FavoriteItem>? items}) {
    return FavoritesModel(
      items: items ?? this.items,
    );
  }
}
