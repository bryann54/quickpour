import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/categories/domain/entities/category.dart';
import 'package:chupachap/features/categories/presentation/pages/category_details_screen.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final double? width;
  final Category category;

  const CategoryCard({super.key, required this.category, this.width});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailsScreen(category: category),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: width ?? 130,
            height: 80,
            decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.dividerColorDark.withOpacity(.3)
                    : AppColors.cardColor.withOpacity(.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accentColor)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:    Hero(
                tag: 'category_image${category.id}', 
                child: Container(
                  width: 100,
                  height: 60,
                  decoration: BoxDecoration(
                    color: category.imageUrl.isEmpty ? Colors.grey[300] : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: category.imageUrl,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Hero(
            tag: 'category_name${category.id}', 
            child: Text(
              category.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
