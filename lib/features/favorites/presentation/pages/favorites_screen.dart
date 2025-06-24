import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/core/utils/strings.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:chupachap/features/favorites/presentation/widgets/favorites_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        showCart: false,
      ),
      body: Column(
        children: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state.favorites.items.isEmpty) {
                return Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Floating hearts background
                        ...List.generate(20, (index) {
                          final isSmall = index % 2 == 0;
                          final xOffset = (index * 20 - 140).toDouble();
                          final startY = index * 30 - 200.0;

                          return Positioned(
                            left:
                                MediaQuery.of(context).size.width / 2 + xOffset,
                            top: startY,
                            child: Icon(
                              FontAwesomeIcons.solidHeart,
                              color: isDarkMode
                                  ? AppColors.accentColorDark.withValues(
                                      alpha: 0.5 + (index % 5) * 0.1)
                                  : AppColors.accentColor.withValues(
                                      alpha: 0.5 + (index % 5) * 0.1),
                              size: isSmall ? 16.0 : 24.0,
                            )
                                .animate(
                                  onPlay: (controller) => controller.repeat(),
                                )
                                .moveY(
                                  begin: 0,
                                  end: 500,
                                  duration: Duration(
                                      seconds: isSmall
                                          ? 6 + index % 4
                                          : 8 + index % 5),
                                  curve: Curves.easeInOut,
                                )
                                .fadeIn(duration: 600.ms)
                                .then()
                                .fadeOut(
                                  begin: 0.7,
                                  delay: Duration(
                                      seconds: isSmall
                                          ? 5 + index % 3
                                          : 7 + index % 4),
                                ),
                          );
                        }),

                        // Main content
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Animated empty favorites image
                            Image.asset(
                              'assets/favs.webp',
                              width: 200,
                              height: 200,
                            ).animate().scale(
                                  begin: const Offset(0.8, 0.8),
                                  end: const Offset(1.0, 1.0),
                                  duration: 800.ms,
                                  curve: Curves.elasticOut,
                                ),

                            const SizedBox(height: 20),

                            const SizedBox(height: 20),

                            // Text message with typing animation
                            Text(
                              empty_favs,
                              style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.titleLarge),
                            ).animate().fadeIn(duration: 600.ms).scale(
                                begin: const Offset(0.8, 0.8),
                                end: const Offset(1.0, 1.0),
                                duration: 800.ms,
                                curve: Curves.elasticOut),
                            const SizedBox(height: 10),
                            Text(
                              add_favs,
                              style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.bodyLarge),
                            )
                                .animate()
                                .fadeIn(duration: 800.ms)
                                .slideY(begin: 0.5, duration: 800.ms),
                          ],
                        ),
                      ],
                    ),
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
                          )
                              .animate()
                              .fadeIn(
                                duration: 400.ms,
                                delay: Duration(milliseconds: index * 50),
                              )
                              .slideX(begin: 0.2);
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
