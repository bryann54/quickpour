import 'package:chupachap/features/orders/presentation/widgets/animated_order_progress.dart';
import 'package:flutter/material.dart';

class ProgressLine extends StatelessWidget {
  final int index;
  final int currentIndex;
  final Color statusColor;
  final OrderAnimationManager animations;

  const ProgressLine({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.statusColor,
    required this.animations,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedBuilder(
        animation: animations.lineAnimation,
        builder: (context, child) {
          final lineProgress = index < currentIndex
              ? 1.0
              : (index == currentIndex ? animations.lineAnimation.value : 0.0);

          return Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Stack(
              children: [
                _buildBackgroundLine(),
                _buildProgressOverlay(lineProgress),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundLine() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }

  Widget _buildProgressOverlay(double lineProgress) {
    return FractionallySizedBox(
      widthFactor: lineProgress,
      child: Container(
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(1.5),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.3),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}
