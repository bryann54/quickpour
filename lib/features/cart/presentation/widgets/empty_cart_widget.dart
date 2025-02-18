import 'package:chupachap/core/utils/strings.dart';
import 'package:chupachap/features/cart/presentation/widgets/animated_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const AnimatedCartImage(),
        const SizedBox(height: 20),
        Text(
          empty_cart,
          style: Theme.of(context).textTheme.titleLarge,
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(),
        const SizedBox(height: 10),
        Text(
          looking_for_something,
          style: Theme.of(context).textTheme.bodyLarge,
        )
            .animate()
            .fadeIn(duration: 800.ms)
            .slideY(begin: 0.5, duration: 800.ms),
      ],
    );
  }
}
