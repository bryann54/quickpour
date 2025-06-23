import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/product/data/models/product_model.dart';

class ProductDetailsHeader extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsHeader({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: isDarkMode ? 2 : 1,
      shadowColor: isDarkMode
          ? AppColors.brandAccent.withOpacity(0.3)
          : AppColors.brandPrimary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDarkMode
              ? AppColors.brandAccent.withOpacity(0.1)
              : AppColors.brandPrimary.withOpacity(0.05),
          width: 1,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isDarkMode
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.cardColor,
                    theme.cardColor.withOpacity(0.95),
                  ],
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name with animated gradient
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Hero(
                      tag: 'product-name-${product.id}',
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.grey.shade700,
                            Colors.grey.shade700,
                          ],
                        ).createShader(bounds),
                        blendMode:
                            BlendMode.srcIn, // Ensures proper gradient effect
                        child: Text(
                          product.productName,
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Hero(
                    tag: 'product-measure-${product.id}',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.measure,
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              isDarkMode ? Colors.grey : Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.brandPrimary.withOpacity(0.05)
                      : AppColors.brandPrimary.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.brandAccent.withOpacity(0.1)
                        : AppColors.brandPrimary.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? AppColors.brandAccent
                            : AppColors.brandPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        color:
                            isDarkMode ? Colors.white70 : Colors.grey.shade600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
