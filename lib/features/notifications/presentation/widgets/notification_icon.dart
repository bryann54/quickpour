import 'package:flutter/material.dart';
import 'package:chupachap/features/notifications/data/models/notifications_model.dart';

class NotificationIcon extends StatelessWidget {
  final NotificationModel notification;
  final ThemeData theme;

  const NotificationIcon({
    Key? key,
    required this.notification,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final Color backgroundColor;

    switch (notification.type) {
      case NotificationType.order:
        icon = Icons.shopping_cart_outlined;
        backgroundColor = Colors.blue.shade50;
        break;
      case NotificationType.promotion:
        icon = Icons.local_offer_outlined;
        backgroundColor = Colors.purple.shade50;
        break;
      case NotificationType.delivery:
        icon = Icons.local_shipping_outlined;
        backgroundColor = Colors.green.shade50;
        break;
      case NotificationType.system:
        icon = Icons.settings_outlined;
        backgroundColor = Colors.grey.shade100;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 24,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
