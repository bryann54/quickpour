import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/promotions/data/models/promotion_model.dart';
import 'package:intl/intl.dart'; // Add this import

class PromoValidityInfo extends StatelessWidget {
  final PromotionModel promotion;

  const PromoValidityInfo({super.key, required this.promotion});

  // Custom date formatter that only shows the date
  String formatDateOnly(DateTime dateTime) {
    final formatter = DateFormat('MMM dd, yyyy'); // e.g. Jan 01, 2025
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.backgroundDark.withOpacity(0.7)
            : AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 18,
                color: isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                'Promotion Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? Colors.white.withOpacity(0.9)
                      : Colors.black87,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildDetailRow(
            context,
            Icons.calendar_today,
            'Valid From',
            formatDateOnly(
                promotion.startDate), // Use your new date-only formatter
          ),
          _buildDetailRow(
            context,
            Icons.calendar_today,
            'Valid Until',
            formatDateOnly(
                promotion.endDate), // Use your new date-only formatter
          ),
          _buildDetailRow(
            context,
            Icons.category,
            'Promotion Type',
            getPromotionTypeDisplay(promotion.promotionTarget),
          ),
          if (promotion.usageLimit != null)
            _buildDetailRow(
              context,
              Icons.person,
              'Usage Limit',
              '${promotion.usageCount}/${promotion.usageLimit}',
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final labelColor =
        isDarkMode ? Colors.grey.shade300 : Colors.blueGrey.shade800;

    final valueColor = isDarkMode
        ? Colors.white.withOpacity(0.8)
        : Colors.black.withOpacity(0.8);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade600,
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: labelColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
