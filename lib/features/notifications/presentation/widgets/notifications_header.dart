// lib/features/notifications/presentation/widgets/notifications_header.dart
import 'package:chupachap/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsHeader extends StatelessWidget {
  const NotificationsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          'Notifications',
          style: GoogleFonts.montaga(
            textStyle: theme.textTheme.displayLarge?.copyWith(
              color:
                  isDarkMode ? AppColors.cardColor : AppColors.accentColorDark,
            ),
          ),
        ).animate().fadeIn(duration: 1000.ms).slideY(begin: 0.1),
      ),
    );
  }
}
