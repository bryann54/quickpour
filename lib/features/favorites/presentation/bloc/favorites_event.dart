
import 'package:chupachap/features/product/data/models/product_model.dart';

abstract class FavoritesEvent {}

class AddToFavoritesEvent extends FavoritesEvent {
  final ProductModel product;

  AddToFavoritesEvent({required this.product});
}

class RemoveFromFavoritesEvent extends FavoritesEvent {
  final ProductModel product;

  RemoveFromFavoritesEvent({required this.product});
}
