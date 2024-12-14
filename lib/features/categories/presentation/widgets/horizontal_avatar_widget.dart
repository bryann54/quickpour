import 'package:cached_network_image/cached_network_image.dart';
import 'package:chupachap/features/categories/presentation/pages/category_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/categories/domain/entities/category.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryCardAvatar extends StatelessWidget {
  final Category category;
  final double? width;

  const CategoryCardAvatar({super.key, required this.category, this.width});

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
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.accentColor.withOpacity(0.1),
                  AppColors.accentColor.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: AppColors.accentColor.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: category.imageUrl,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Align(
                    alignment: Alignment.center,
                    child: FaIcon(
                      FontAwesomeIcons.cocktail,
                      size: 30,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: isDarkMode ? Colors.white70 : Colors.black87,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
