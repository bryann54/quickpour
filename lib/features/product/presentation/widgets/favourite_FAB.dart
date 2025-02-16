import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';

class FavoriteFAB extends StatelessWidget {
  final ProductModel product;
  final bool isDarkMode;

  const FavoriteFAB({
    Key? key,
    required this.product,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state.isFavorite(product);

        return Hero(
          tag: 'product-favorite-${product.id}',
          child: SizedBox(
            width: 32,
            height: 32,
            child: Material(
              color: isFavorite
                  ? AppColors.accentColor
                  : (isDarkMode
                      ? AppColors.background
                      : AppColors.brandPrimary.withOpacity(0.5)),
              shape: const CircleBorder(),
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  if (isFavorite) {
                    context.read<FavoritesBloc>().add(
                          RemoveFromFavoritesEvent(product: product),
                        );
                  } else {
                    context.read<FavoritesBloc>().add(
                          AddToFavoritesEvent(product: product),
                        );
                  }
                },
                child: Center(
                  child: FaIcon(
                    isFavorite
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    size: 14,
                    color: isFavorite
                        ? Colors.white
                        : (isDarkMode
                            ? AppColors.accentColor
                            : AppColors.background),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
