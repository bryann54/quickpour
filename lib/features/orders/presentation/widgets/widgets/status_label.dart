import 'package:chupachap/features/orders/presentation/widgets/animated_order_progress.dart';
import 'package:flutter/material.dart';

class OrderStatusLabels extends StatelessWidget {
  final int currentIndex;
  final OrderStatusManager statusManager;
  final OrderAnimationManager animations;

  const OrderStatusLabels({
    super.key,
    required this.currentIndex,
    required this.statusManager,
    required this.animations,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(statusManager.statusCount, (index) {
        final isActive = index == currentIndex;
        final statusColor = statusManager.getStatusColor(index);

        return StatusLabel(
          isActive: isActive,
          index: index,
          statusColor: statusColor,
          statusManager: statusManager,
          animations: animations,
        );
      }),
    );
  }
}

class StatusLabel extends StatelessWidget {
  final bool isActive;
  final int index;
  final Color statusColor;
  final OrderStatusManager statusManager;
  final OrderAnimationManager animations;

  const StatusLabel({
    super.key,
    required this.isActive,
    required this.index,
    required this.statusColor,
    required this.statusManager,
    required this.animations,
  });

  @override
  Widget build(BuildContext context) {
    final label = _buildLabel();

    if (isActive) {
      return AnimatedBuilder(
        animation: animations.bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: animations.bounceAnimation.value,
            child: label,
          );
        },
      );
    }

    return label;
  }

  Widget _buildLabel() {
    return GestureDetector(
      onTap: () {
        // Add interaction logic here
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.3),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Text(
          statusManager.getStatusLabel(index),
          key: ValueKey(isActive),
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? statusColor : Colors.grey,
            letterSpacing: isActive ? 0.5 : 0.0,
            shadows: isActive
                ? [
                    Shadow(
                      color: statusColor.withValues(alpha: 0.3),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
