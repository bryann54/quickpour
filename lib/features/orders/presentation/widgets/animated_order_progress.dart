import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/orders/presentation/widgets/widgets/canceled_order_widget.dart';
import 'package:chupachap/features/orders/presentation/widgets/widgets/progress_indicator.dart';
import 'package:chupachap/features/orders/presentation/widgets/widgets/status_label.dart';
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
  late final OrderAnimationManager _animations;
  late final OrderStatusManager _statusManager;

  @override
  void initState() {
    super.initState();
    _animations = OrderAnimationManager(
      vsync: this,
      animationDuration: widget.animationDuration,
    );
    _statusManager = OrderStatusManager();
    _startAnimation();
  }

  void _startAnimation() {
    _animations.startAnimations(widget.currentStatus);
  }

  @override
  void dispose() {
    _animations.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedOrderProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStatus != widget.currentStatus) {
      _animations.resetAnimations();
      _startAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentStatus == OrderStatus.canceled) {
      return const CanceledOrderWidget();
    }

    final currentIndex = _statusManager.getStatusIndex(widget.currentStatus);

    return FadeTransition(
      opacity: _animations.fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderProgressIndicators(
            currentIndex: currentIndex,
            statusManager: _statusManager,
            animations: _animations,
          ),
          const SizedBox(height: 8),
          OrderStatusLabels(
            currentIndex: currentIndex,
            statusManager: _statusManager,
            animations: _animations,
          ),
        ],
      ),
    );
  }
}

class OrderAnimationManager {
  final TickerProvider vsync;
  final Duration animationDuration;

  late final AnimationController lineController;
  late final AnimationController canceledController;
  late final AnimationController bounceController;
  late final AnimationController fadeController;
  late final AnimationController pulseController;

  late final Animation<double> lineAnimation;
  late final Animation<double> bounceAnimation;
  late final Animation<double> fadeAnimation;
  late final Animation<double> pulseAnimation;

  OrderAnimationManager({
    required this.vsync,
    required this.animationDuration,
  }) {
    _initializeControllers();
    _initializeAnimations();
  }

  void _initializeControllers() {
    lineController = AnimationController(
      duration: animationDuration,
      vsync: vsync,
    );

    canceledController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );

    bounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync,
    );

    fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: vsync,
    );

    pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );
  }

  void _initializeAnimations() {
    lineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: lineController,
        curve: Curves.easeInOut,
      ),
    );

    bounceAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: bounceController,
        curve: Curves.elasticOut,
      ),
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: fadeController,
        curve: Curves.easeIn,
      ),
    );

    pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void startAnimations(OrderStatus currentStatus) {
    lineController.forward();
    fadeController.forward();

    if (currentStatus == OrderStatus.canceled) {
      canceledController.repeat(reverse: true);
    } else {
      bounceController.forward().then((_) => bounceController.reset());
      pulseController.repeat(reverse: true);
    }
  }

  void resetAnimations() {
    lineController.reset();
    canceledController.reset();
    fadeController.reset();
    bounceController.reset();
    pulseController.reset();
  }

  void dispose() {
    lineController.dispose();
    canceledController.dispose();
    bounceController.dispose();
    fadeController.dispose();
    pulseController.dispose();
  }
}

class OrderStatusManager {
  final List<OrderStatus> normalOrderFlow = [
    OrderStatus.received,
    OrderStatus.processing,
    OrderStatus.dispatched,
    OrderStatus.delivering,
    OrderStatus.completed,
  ];

  int getStatusIndex(OrderStatus status) {
    return normalOrderFlow.indexOf(status);
  }

  int get statusCount => normalOrderFlow.length;

  OrderStatus getStatusAtIndex(int index) {
    return normalOrderFlow[index];
  }

  Color getStatusColor(int index) {
    return OrderStatusUtils.getStatusColor(normalOrderFlow[index]);
  }

  IconData getStatusIcon(int index) {
    return OrderStatusUtils.getStatusIcon(normalOrderFlow[index]);
  }

  String getStatusLabel(int index) {
    return OrderStatusUtils.getStatusLabel(normalOrderFlow[index]);
  }
}
