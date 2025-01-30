import 'package:chupachap/features/favorites/data/models/favorites_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/favorites/data/repositories/favorites_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesBloc({required FavoritesRepository favoritesRepository})
      : _favoritesRepository = favoritesRepository,
        super(FavoritesState(favorites: FavoritesModel(items: []))) {
    on<AddToFavoritesEvent>(_onAddToFavorites);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavorites);
    on<LoadFavoritesEvent>(_onLoadFavorites);
  }

  // Add to favorites logic
  void _onAddToFavorites(
      AddToFavoritesEvent event, Emitter<FavoritesState> emit) async {
    await _favoritesRepository.addToFavorites(event.product);
    // Reload favorites after adding
    await _loadFavorites(emit);
  }

  // Remove from favorites logic
  void _onRemoveFromFavorites(
      RemoveFromFavoritesEvent event, Emitter<FavoritesState> emit) async {
    await _favoritesRepository.removeFromFavorites(event.product);
    // Reload favorites after removing
    await _loadFavorites(emit);
  }

  // Load favorites logic
  void _onLoadFavorites(
      LoadFavoritesEvent event, Emitter<FavoritesState> emit) async {
    await _loadFavorites(emit);
  }

  // Helper function to load favorites and update the state
  Future<void> _loadFavorites(Emitter<FavoritesState> emit) async {
    final favoritesStream = _favoritesRepository.getFavorites();
    await emit.forEach(
      favoritesStream,
      onData: (favorites) => FavoritesState(
        favorites: FavoritesModel(
          items: favorites
              .map((product) => FavoriteItem(product: product))
              .toList(),
        ),
      ),
    );
  }
}
