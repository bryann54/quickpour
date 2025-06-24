import 'package:flutter/material.dart';
import 'package:chupachap/core/utils/functions.dart';
import 'package:chupachap/features/notifications/data/models/notifications_model.dart';

class NotificationFooter extends StatelessWidget {
  final NotificationModel notification;
  final ThemeData theme;

  const NotificationFooter({
    Key? key,
    required this.notification,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          _getTypeIcon(),
          size: 14,
          color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 6),
        Text(
          formatTimestamp(notification.timestamp),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  IconData _getTypeIcon() {
    switch (notification.type) {
      case NotificationType.order:
        return Icons.shopping_cart;
      case NotificationType.promotion:
        return Icons.local_offer;
      case NotificationType.delivery:
        return Icons.local_shipping;
      case NotificationType.system:
        return Icons.settings;
    }
  }
}
