import 'package:chupachap/core/utils/colors.dart';
import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;
  final IconData? icon;
  final Color? valueColor;

  const SummaryRow({
    Key? key,
    required this.title,
    required this.value,
    this.isTotal = false,
    this.icon,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 16,
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: valueColor ??
                  (isTotal
                      ? (isDark
                          ? theme.colorScheme.primary
                          : AppColors.primaryColor)
                      : theme.textTheme.bodySmall?.color),
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              fontSize: isTotal ? 15 : 14,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
