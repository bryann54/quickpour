import 'package:chupachap/core/utils/strings.dart';
import 'package:chupachap/features/cart/presentation/widgets/animated_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
        child: Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Floating shopping bags
          ...List.generate(20, (index) {
            final isSmall = index % 2 == 0;
            final xOffset = (index * 20 - 120).toDouble();
            final startY = index * 30 - 200.0;

            return Positioned(
              left: MediaQuery.of(context).size.width / 2 + xOffset,
              top: startY,
              child: Icon(
                FontAwesomeIcons.bagShopping,
                color: isDarkMode
                    ? Colors.orangeAccent
                        .withValues(alpha: 0.5 + (index % 5) * 0.1)
                    : Colors.amber.withValues(alpha: 0.5 + (index % 5) * 0.1),
                size: isSmall ? 16.0 : 24.0,
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .moveY(
                    begin: 0,
                    end: 500,
                    duration: Duration(
                        seconds: isSmall ? 6 + index % 4 : 8 + index % 5),
                    curve: Curves.easeInOut,
                  )
                  .fadeIn(duration: 600.ms)
                  .then()
                  .fadeOut(
                    begin: 0.7,
                    delay: Duration(
                        seconds: isSmall ? 5 + index % 3 : 7 + index % 4),
                  ),
            );
          }),

          // Main empty cart UI
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AnimatedCartImage(),
              const SizedBox(height: 20),
              Text(
                empty_cart,
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.titleLarge),
              ).animate().fadeIn(duration: 600.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 800.ms,
                  curve: Curves.elasticOut),
              const SizedBox(height: 10),
              Text(
                looking_for_something,
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.bodyLarge),
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.5, duration: 800.ms),
            ],
          ),
        ],
      ),
    ));
  }
}
