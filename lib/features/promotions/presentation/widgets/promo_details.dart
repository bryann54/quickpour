import 'package:chupachap/core/utils/colors.dart';
import 'package:flutter/material.dart';

class PromoDetails extends StatelessWidget {
  final String campaignTitle;
  final String description;

  const PromoDetails({
    super.key,
    required this.campaignTitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Container(
      
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color:isDarkMode?AppColors.backgroundDark
        : AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            campaignTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
