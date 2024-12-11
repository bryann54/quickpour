
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:chupachap/features/favorites/presentation/widgets/favorites_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showCart: false,),
      body: Column(
        children: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state.favorites.items.isEmpty) {
                return const Center(
                  child: Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              return Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Favorites',
                            style: Theme.of(context).textTheme.displayLarge,
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.favorites.items.length,
                        itemBuilder: (context, index) {
                          final favoriteItem = state.favorites.items[index];
                          return FavoritesWidget(
                            favoriteItem: favoriteItem,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
