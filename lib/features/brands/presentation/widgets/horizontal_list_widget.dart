import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:chupachap/features/brands/presentation/widgets/brands_avatar.dart';
import 'package:flutter/material.dart';

class HorizontalbrandsListWidget extends StatelessWidget {
  final List<BrandModel> brand;
  const HorizontalbrandsListWidget({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
 

        // Brands List
        Container(
          height:90, 
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.dividerColorDark.withOpacity(0.2)
                : AppColors.cardColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: brand.isEmpty
              ? Center(
                  child: Text(
                    'No brands available',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: brand.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          brandCardAvatar(
                            brand: brand[index],
                            isFirst: index == 0,
                            isLast: index == brand.length - 1,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
