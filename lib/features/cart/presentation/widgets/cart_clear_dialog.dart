// cart_clear_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:chupachap/core/utils/colors.dart';

class CartClearDialog extends StatelessWidget {
  final VoidCallback onClear;

  const CartClearDialog({
    super.key,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text('Clear Cart')
          .animate()
          .fadeIn(duration: 400.ms)
          .slideY(begin: 0.3, duration: 400.ms),
      content: const Text('Are you sure you want to clear your cart?')
          .animate()
          .fadeIn(delay: 200.ms)
          .slideY(begin: 0.3, duration: 400.ms),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onClear();
          },
          child: const Text(
            'Clear',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ].animate(interval: 100.ms).fadeIn(delay: 400.ms),
    );
  }
}
