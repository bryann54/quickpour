import 'package:chupachap/features/orders/presentation/widgets/animated_order_progress.dart';
import 'package:flutter/material.dart';

class StatusIcon extends StatelessWidget {
  final bool isActive;
  final bool isCurrentStatus;
  final int index;
  final Color statusColor;
  final OrderStatusManager statusManager;
  final OrderAnimationManager animations;

  const StatusIcon({
    super.key,
    required this.isActive,
    required this.isCurrentStatus,
    required this.index,
    required this.statusColor,
    required this.statusManager,
    required this.animations,
  });

  @override
  Widget build(BuildContext context) {
    final statusIcon = _buildStatusIcon();

    if (isCurrentStatus) {
      return AnimatedBuilder(
        animation: animations.pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: animations.pulseAnimation.value,
            child: statusIcon,
          );
        },
      );
    }

    return statusIcon;
  }

  Widget _buildStatusIcon() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Container(
        key: ValueKey(isActive),
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isActive ? statusColor : Colors.grey.shade300,
          shape: BoxShape.circle,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.4),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Icon(
            statusManager.getStatusIcon(index),
            size: isActive ? 12 : 18,
            color: isActive ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}
