import 'dart:math';
import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/functions.dart';

class CanceledOrderWidget extends StatefulWidget {
  final Duration animationDuration;

  const CanceledOrderWidget({
    Key? key,
    this.animationDuration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  @override
  State<CanceledOrderWidget> createState() => _CanceledOrderWidgetState();
}

class _CanceledOrderWidgetState extends State<CanceledOrderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _startAnimation();
  }

  void _startAnimation() {
    _animationController.forward();
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: OrderStatusUtils.getStatusColor(OrderStatus.canceled)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: OrderStatusUtils.getStatusColor(
                                OrderStatus.canceled)
                            .withValues(alpha: 0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildShakingIcon(),
                      const SizedBox(width: 16),
                      _buildStatusTexts(),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShakingIcon() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      builder: (context, double value, child) {
        final sinValue = sin(value * 3 * pi);
        return Transform.rotate(
          angle: sinValue * 0.08,
          child: child,
        );
      },
      child: Icon(
        OrderStatusUtils.getStatusIcon(OrderStatus.canceled),
        color: OrderStatusUtils.getStatusColor(OrderStatus.canceled),
        size: 28,
      ),
    );
  }

  Widget _buildStatusTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ),
          child: Text(
            'Order Canceled',
            style: TextStyle(
              color: OrderStatusUtils.getStatusColor(OrderStatus.canceled),
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        FadeTransition(
          opacity: CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
          child: Text(
            'Your order was canceled',
            style: TextStyle(
              color: OrderStatusUtils.getStatusColor(OrderStatus.canceled)
                  .withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
