import 'package:chupachap/core/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return Switch(
      value: themeController.isDarkMode,
      onChanged: (value) {
        themeController.toggleTheme();
      },
    );
  }
}
