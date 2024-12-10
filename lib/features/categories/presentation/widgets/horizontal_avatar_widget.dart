
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/categories/domain/entities/category.dart';
import 'package:flutter/material.dart';

class CategoryCardAvatar extends StatelessWidget {
  final double? width;
  final Category category;

  const CategoryCardAvatar({super.key, required this.category, this.width});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        // Add navigation logic here if needed
        // For example:
        // Navigator.pushNamed(
        //   context,
        //   Routes.productsByCategory,
        //   arguments: category.id,
        // );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.accentColor.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: width ?? 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accentColor, width: 2),
                  color: Colors.grey[100],
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: category.imageUrl,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                      size: 35,
                      color: isDarkMode
                          ? AppColors.accentColor
                          : AppColors.surfaceColorDark.withOpacity(.4),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                category.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
