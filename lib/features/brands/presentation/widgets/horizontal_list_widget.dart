import 'package:chupachap/features/brands/presentation/pages/brand_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/brands/data/models/brands_model.dart';
import 'package:chupachap/features/brands/presentation/widgets/brands_avatar.dart';

class HorizontalBrandsListWidget extends StatelessWidget {
  final List<BrandModel> brands;
  final String? title;

  const HorizontalBrandsListWidget({
    super.key,
    required this.brands,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Optional Title
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white70 : Colors.black87,
              ),
            ),
          ),

        // Brands List
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.dividerColorDark.withOpacity(0.2)
                : AppColors.cardColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: brands.isEmpty
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BrandDetailsScreen(
                                brand: brands[index],
                              ),
                            ),
                          );
                        },
                        child: BrandCardAvatar(
                          brand: brands[index],
                          isFirst: index == 0,
                          isLast: index == brands.length - 1,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
