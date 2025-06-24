// custom_animated_snackbar.dart
import 'package:flutter/material.dart';

class CustomAnimatedSnackbar {
  static OverlayEntry? _overlayEntry;
  static String? _currentMessage;
  static IconData? _currentIcon;
  static Color? _currentBackgroundColor;

  static void show({
    required BuildContext context,
    required String message,
    required IconData icon,
    Color backgroundColor = const Color.fromARGB(190, 0, 0, 0),
    Duration displayDuration = const Duration(seconds: 3),
  }) {
    _currentMessage = message;
    _currentIcon = icon;
    _currentBackgroundColor = backgroundColor;

    if (_overlayEntry != null) {
      _animateOverlayRemoval(context);
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(-100 * (1 - value), 0),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: _SnackbarContent(
              message: message,
              icon: icon,
              backgroundColor: backgroundColor,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(displayDuration, () {
      if (_overlayEntry != null) {
        _animateOverlayRemoval(context);
      }
    });
  }

  static void _animateOverlayRemoval(BuildContext context) {
    OverlayEntry? oldEntry = _overlayEntry;
    if (oldEntry == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            tween: Tween(begin: 1.0, end: 0.0),
            onEnd: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(100 * (1 - value), 0),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: _SnackbarContent(
              message: _currentMessage!,
              icon: _currentIcon!,
              backgroundColor: _currentBackgroundColor!,
            ),
          ),
        ),
      ),
    );

    oldEntry.remove();
    Overlay.of(context).insert(_overlayEntry!);
  }

  static void dismiss() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}

class _SnackbarContent extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color backgroundColor;

  const _SnackbarContent({
    required this.message,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
