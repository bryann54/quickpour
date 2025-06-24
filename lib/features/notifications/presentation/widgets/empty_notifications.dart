// lib/features/notifications/presentation/widgets/empty_notifications.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyNotificationsView extends StatelessWidget {
  const EmptyNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ...List.generate(
            15,
            (index) => _buildFloatingBell(context, index, isDarkMode),
          ),
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildFloatingBell(BuildContext context, int index, bool isDarkMode) {
    final isSmall = index % 2 == 0;
    final xOffset = (index * 25 - 120).toDouble();
    final startY = index * 35 - 180.0;

    return Positioned(
      left: MediaQuery.of(context).size.width / 2 + xOffset,
      top: startY,
      child: _AnimatedBellIcon(
        isDarkMode: isDarkMode,
        isSmall: isSmall,
        index: index,
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _AnimatedImage(),
        const SizedBox(height: 20),
        _AnimatedText(
          text: 'No notifications yet!',
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 10),
        _AnimatedText(
          text: 'Your notifications will appear here',
          style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyLarge,
          ),
          delay: 200,
        ),
      ],
    );
  }
}

class _AnimatedBellIcon extends StatelessWidget {
  final bool isDarkMode;
  final bool isSmall;
  final int index;

  const _AnimatedBellIcon({
    required this.isDarkMode,
    required this.isSmall,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      FontAwesomeIcons.solidBell,
      color: isDarkMode
          ? Colors.cyan.withValues(alpha: 0.5 + (index % 5) * 0.1)
          : Colors.cyan.withValues(alpha: 0.5 + (index % 5) * 0.1),
      size: isSmall ? 16.0 : 24.0,
    )
        .animate(onPlay: (controller) => controller.repeat())
        .moveY(
          begin: 0,
          end: 500,
          duration: Duration(seconds: isSmall ? 6 + index % 4 : 8 + index % 5),
          curve: Curves.easeInOut,
        )
        .fadeIn(duration: 600.ms)
        .then()
        .fadeOut(
          begin: 0.7,
          delay: Duration(seconds: isSmall ? 5 + index % 3 : 7 + index % 4),
        );
  }
}

class _AnimatedImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/notifications.webp',
      width: 150,
      height: 150,
    ).animate().scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 800.ms,
          curve: Curves.elasticOut,
        );
  }
}

class _AnimatedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int delay;

  const _AnimatedText({
    required this.text,
    required this.style,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text, style: style)
        .animate()
        .fadeIn(duration: 600.ms, delay: Duration(milliseconds: delay))
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 800.ms,
          curve: Curves.elasticOut,
        );
  }
}
