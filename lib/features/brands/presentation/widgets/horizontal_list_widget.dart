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

 

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.dividerColorDark.withOpacity(.3)
              : AppColors.cardColor.withOpacity(.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: brand.isEmpty
            ? const Center(
                child: Text(
                  'No verified brands available',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) =>
                    brandCardAvatar(brand: brand[index]),
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemCount: brand.length,
              ),
      ),
    );
  }
}
