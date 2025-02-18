// cart_empty_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CartEmptyView extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final bool isDarkMode;

  const CartEmptyView({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: screenHeight - (AppBar().preferredSize.height + 50),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/Animation - 1732905747047.gif',
                width: screenWidth * 0.7,
                height: screenHeight * 0.3,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 18,
                  color: isDarkMode ? Colors.white70 : Colors.grey,
                ),
              ),
            ],
          ).animate().fadeIn(duration: 600.ms).scale(),
        ),
      ),
    );
  }
}
