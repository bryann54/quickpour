import 'package:chupachap/features/favorites/data/models/favorites_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesState(favorites: FavoritesModel())) {
    on<AddToFavoritesEvent>(_onAddToFavorites);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavorites);
  }

  void _onAddToFavorites(
      AddToFavoritesEvent event, Emitter<FavoritesState> emit) {
    final currentFavorites = List<FavoriteItem>.from(state.favorites.items);

    // Prevent duplicates
    if (!currentFavorites.any((item) => item.product.id == event.product.id)) {
      currentFavorites.add(FavoriteItem(product: event.product));
      emit(FavoritesState(favorites: FavoritesModel(items: currentFavorites)));
    }
  }

  void _onRemoveFromFavorites(
      RemoveFromFavoritesEvent event, Emitter<FavoritesState> emit) {
    final currentFavorites = List<FavoriteItem>.from(state.favorites.items);

    currentFavorites.removeWhere((item) => item.product.id == event.product.id);
    emit(FavoritesState(favorites: FavoritesModel(items: currentFavorites)));
  }
}
