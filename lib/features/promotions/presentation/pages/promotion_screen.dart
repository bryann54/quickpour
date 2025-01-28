// promotions_screen.dart
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/promotions/presentation/widgets/promo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';
import 'package:google_fonts/google_fonts.dart';

class PromotionScreen extends StatelessWidget {
  final List<ProductModel> promotions;

  const PromotionScreen({
    super.key,
    required this.promotions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    // Filter products to include only those with a discount
    final discountedPromotions = promotions
        .where((product) => product.discountPrice < product.price)
        .toList();

    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Center(
              child: Text('Promotions',
                  style: GoogleFonts.montaga(
                    textStyle: theme.textTheme.displayLarge?.copyWith(
                      color: isDarkMode
                          ? AppColors.cardColor
                          : AppColors.accentColorDark,
                    ),
                  )).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 8,
                itemCount: discountedPromotions.length,
                itemBuilder: (context, index) {
                  final product = discountedPromotions[index];
                  return PromotionCard(product: product);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
