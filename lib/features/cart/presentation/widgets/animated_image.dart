import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedCartImage extends StatefulWidget {
  const AnimatedCartImage({super.key});

  @override
  State<AnimatedCartImage> createState() => _AnimatedCartImageState();
}

class _AnimatedCartImageState extends State<AnimatedCartImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: -0.03, end: 0.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scaleAnimation.value,
      child: Transform.rotate(
        angle: _rotationAnimation.value,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/cart.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            )
                .animate()
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 800.ms,
                  curve: Curves.elasticOut,
                )
                .shimmer(
                  duration: 2000.ms,
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Badge extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;

  const Badge({super.key, required this.backgroundColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: child,
    );
  }
}
