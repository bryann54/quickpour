import 'package:chupachap/features/orders/presentation/widgets/animated_order_progress.dart';
import 'package:chupachap/features/orders/presentation/widgets/widgets/progress_line.dart';
import 'package:chupachap/features/orders/presentation/widgets/widgets/status_icon.dart';
import 'package:flutter/material.dart';

class OrderProgressIndicators extends StatelessWidget {
  final int currentIndex;
  final OrderStatusManager statusManager;
  final OrderAnimationManager animations;

  const OrderProgressIndicators({
    super.key,
    required this.currentIndex,
    required this.statusManager,
    required this.animations,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(statusManager.statusCount, (index) {
        final isActive = index <= currentIndex;
        final isCurrentStatus = index == currentIndex;
        final statusColor = statusManager.getStatusColor(index);

        return Expanded(
          child: Row(
            children: [
              StatusIcon(
                isActive: isActive,
                isCurrentStatus: isCurrentStatus,
                index: index,
                statusColor: statusColor,
                statusManager: statusManager,
                animations: animations,
              ),
              if (index < statusManager.statusCount - 1)
                ProgressLine(
                  index: index,
                  currentIndex: currentIndex,
                  statusColor: statusColor,
                  animations: animations,
                ),
            ],
          ),
        );
      }),
    );
  }
}
