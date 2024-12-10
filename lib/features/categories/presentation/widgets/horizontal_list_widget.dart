
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/categories/domain/entities/category.dart';
import 'package:chupachap/features/categories/presentation/widgets/horizontal_avatar_widget.dart';
import 'package:flutter/material.dart';

class HorizontalListWidget extends StatelessWidget {
  final List<Category> category;

  const HorizontalListWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      height: 85, // Increased height for better UI space
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: isDarkMode
          ? AppColors.dividerColorDark.withOpacity(0.3)
          : AppColors.cardColor.withOpacity(0.5),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => CategoryCardAvatar(
          category: category[index],
        ),
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemCount: category.length,
      ),
    );
  }
}
