import 'dart:math';

import 'package:chupachap/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:chupachap/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';

class FavoriteFAB extends StatefulWidget {
  final ProductModel product;
  final bool isDarkMode;

  const FavoriteFAB({
    Key? key,
    required this.product,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<FavoriteFAB> createState() => _FavoriteFABState();
}

class _FavoriteFABState extends State<FavoriteFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.8)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.8, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_animationController);

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 70,
      ),
    ]).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _playAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        final isFavorite = state.isFavorite(widget.product);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Animated burst effect
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentColor.withOpacity(0.6),
                            blurRadius: 10 * _scaleAnimation.value,
                            spreadRadius: 2 * _scaleAnimation.value,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            // Main heart button
            Hero(
              tag: 'product-favorite-${widget.product.id}',
              child: SizedBox(
                width: 35,
                height: 35,
                child: Material(
                  color: isFavorite
                      ? AppColors.accentColor
                      : (widget.isDarkMode
                          ? AppColors.brandPrimary.withOpacity(.4)
                          : AppColors.background.withOpacity(0.9)),
                  shape: const CircleBorder(),
                  elevation: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      if (isFavorite) {
                        context.read<FavoritesBloc>().add(
                              RemoveFromFavoritesEvent(product: widget.product),
                            );
                      } else {
                        context.read<FavoritesBloc>().add(
                              AddToFavoritesEvent(product: widget.product),
                            );
                        _playAnimation();
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isFavorite && _animationController.isAnimating
                              ? 1.0 + (_scaleAnimation.value - 1.0) * 0.5
                              : 1.0,
                          child: Center(
                            child: FaIcon(
                              isFavorite
                                  ? FontAwesomeIcons.solidHeart
                                  : FontAwesomeIcons.heart,
                              size: 17,
                              color: isFavorite
                                  ? Colors.white
                                  : (widget.isDarkMode
                                      ? AppColors.accentColor
                                      : AppColors.backgroundDark
                                          .withOpacity(.3)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            // Floating hearts animation
            if (isFavorite && _animationController.isAnimating)
              ...List.generate(
                5,
                (index) => _buildFloatingHeart(index),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingHeart(int index) {
    final Random random = Random();
    final double randomX = -0.5 + random.nextDouble();
    final double randomY = -1 + random.nextDouble() * 0.5;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          child: Opacity(
            opacity: (1 - _animationController.value) * 0.7,
            child: Transform.translate(
              offset: Offset(
                randomX * 30 * _animationController.value,
                randomY * 40 * _animationController.value,
              ),
              child: Transform.scale(
                scale: 0.5 * (1 - _animationController.value * 0.5),
                child: const Icon(
                  FontAwesomeIcons.solidHeart,
                  color: AppColors.accentColor,
                  size: 12,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
