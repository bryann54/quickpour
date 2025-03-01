import 'package:chupachap/core/utils/functions.dart';
import 'package:flutter/material.dart';

class AnimatedOrderProgress extends StatefulWidget {
  final OrderStatus currentStatus;
  final Duration animationDuration;

  const AnimatedOrderProgress({
    super.key,
    required this.currentStatus,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  State<AnimatedOrderProgress> createState() => _AnimatedOrderProgressState();
}

class _AnimatedOrderProgressState extends State<AnimatedOrderProgress>
    with TickerProviderStateMixin {
  late AnimationController _lineController;
  late Animation<double> _lineAnimation;
  late AnimationController _canceledController;
  late Animation<double> _canceledAnimation;

  @override
  void initState() {
    super.initState();
    _lineController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _lineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _lineController,
        curve: Curves.easeInOut,
      ),
    );

    _canceledController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _canceledAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _canceledController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimation();
  }

  void _startAnimation() {
    _lineController.forward();
    if (widget.currentStatus == OrderStatus.canceled) {
      _canceledController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _lineController.dispose();
    _canceledController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedOrderProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStatus != widget.currentStatus) {
      _lineController.reset();
      _canceledController.reset();
      _startAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = OrderStatus.values.indexOf(widget.currentStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: List.generate(5, (index) {
              final isActive = index <= currentIndex;
              final statusColor =
                  OrderStatusUtils.getStatusColor(OrderStatus.values[index]);

              return Expanded(
                child: Row(
                  children: [
                    // Animated Status Icon
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        key: ValueKey(isActive),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: isActive ? statusColor : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: isActive
                            ? Icon(
                                OrderStatusUtils.getStatusIcon(
                                    OrderStatus.values[index]),
                                size: 12,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    // Progress line
                    if (index < 4)
                      Expanded(
                        child: AnimatedBuilder(
                          animation: _lineAnimation,
                          builder: (context, child) {
                            final lineProgress = index < currentIndex
                                ? 1.0
                                : (index == currentIndex
                                    ? _lineAnimation.value
                                    : 0.0);
                            return Container(
                              height: 2,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: Stack(
                                children: [
                                  Container(
                                    color: Colors.grey.shade300,
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: lineProgress,
                                    child: Container(
                                      color: statusColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        // Interactive Status Labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final isActive = index == currentIndex;
              final statusColor =
                  OrderStatusUtils.getStatusColor(OrderStatus.values[index]);

              return GestureDetector(
                onTap: () {
                  // Add interaction logic here (e.g., show details for the status)
                  print(
                      'Tapped on: ${OrderStatusUtils.getStatusLabel(OrderStatus.values[index])}');
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    OrderStatusUtils.getStatusLabel(OrderStatus.values[index]),
                    key: ValueKey(isActive),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? statusColor : Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }),
          ),
        ),
        // Canceled Status Overlay
        if (widget.currentStatus == OrderStatus.canceled)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(
              child: AnimatedBuilder(
                animation: _canceledAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _canceledAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: OrderStatusUtils.getStatusColor(
                                OrderStatus.canceled)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            OrderStatusUtils.getStatusIcon(
                                OrderStatus.canceled),
                            color: OrderStatusUtils.getStatusColor(
                                OrderStatus.canceled),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Canceled',
                            style: TextStyle(
                              color: OrderStatusUtils.getStatusColor(
                                  OrderStatus.canceled),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
