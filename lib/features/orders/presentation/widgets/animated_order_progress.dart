// widgets/animated_order_progress.dart
import 'package:flutter/material.dart';

enum OrderStatus { received, processing, dispatched, delivered, completed }

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

  final List<String> _statusLabels = [
    'Received',
    'Processing',
    'Dispatched',
    'Delivery',
    'Completed'
  ];

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

    _startAnimation();
  }

  void _startAnimation() {
    _lineController.forward();
  }

  @override
  void dispose() {
    _lineController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedOrderProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStatus != widget.currentStatus) {
      _lineController.reset();
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

              return Expanded(
                child: Row(
                  children: [
                    // Status dot
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF2ECC71)
                            : Colors.grey.shade300,
                        shape: BoxShape.circle,
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
                                      color: const Color(0xFF2ECC71),
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
        // Status labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              final isActive = index == currentIndex;

              return Expanded(
                child: Text(
                  _statusLabels[index],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? const Color(0xFF2ECC71) : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
