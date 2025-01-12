import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/colors.dart';

class HomeScreenSearch extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const HomeScreenSearch({
    super.key,
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search product',
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDarkMode ? Colors.white70 : Colors.grey.shade600,
          ),
          filled: true,
          fillColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: isDarkMode
                  ? AppColors.accentColor.withOpacity(0.3)
                  : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.accentColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
