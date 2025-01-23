import 'package:chupachap/features/favorites/data/models/favorites_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/favorites/data/repositories/favorites_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesBloc({required FavoritesRepository favoritesRepository})
      : _favoritesRepository = favoritesRepository,
        super(FavoritesState(favorites: FavoritesModel())) {
    on<AddToFavoritesEvent>(_onAddToFavorites);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavorites);
    on<LoadFavoritesEvent>(_onLoadFavorites);
  }

  void _onAddToFavorites(
      AddToFavoritesEvent event, Emitter<FavoritesState> emit) async {
    await _favoritesRepository.addToFavorites(event.product);
  }

  void _onRemoveFromFavorites(
      RemoveFromFavoritesEvent event, Emitter<FavoritesState> emit) async {
    await _favoritesRepository.removeFromFavorites(event.product);
  }

  void _onLoadFavorites(
      LoadFavoritesEvent event, Emitter<FavoritesState> emit) async {
    await emit.forEach(
      _favoritesRepository.getFavorites(),
      onData: (favorites) => FavoritesState(
          favorites: FavoritesModel(
              items: favorites
                  .map((product) => FavoriteItem(product: product))
                  .toList())),
    );
  }
}
