import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/categories/domain/entities/category.dart';
import 'package:chupachap/features/categories/presentation/widgets/horizontal_avatar_widget.dart';

class HorizontalCategoriesListWidget extends StatelessWidget {
  final List<Category> categories;

  const HorizontalCategoriesListWidget({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Container(
          height: 130,
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.dividerColorDark.withValues(alpha: 0.2)
                : AppColors.cardColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: categories.isEmpty
              ? Center(
                  child: Text(
                    'No categories available',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => CategoryCardAvatar(
                    category: categories[index],
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemCount: categories.length,
                ),
        ),
      ],
    );
  }
}
