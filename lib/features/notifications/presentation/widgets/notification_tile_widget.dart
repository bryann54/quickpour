import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/notifications/data/models/notifications_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
      decoration: BoxDecoration(
            color: notification.isRead
                ? null
                : theme.colorScheme.primary.withOpacity(0.05),
            border: notification.isRead
                ? null
                : Border.all(color: AppColors.accentColor.withOpacity(.3)),
                borderRadius: BorderRadius.circular(8),
                ),
     
        child: ListTile(
          leading: _buildLeadingIcon(),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight:
                  notification.isRead ? FontWeight.normal : FontWeight.bold,
              color: notification.isRead
                  ? theme.textTheme.bodyLarge?.color
                  : theme.colorScheme.primary,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.body,
                style: TextStyle(
                  color: notification.isRead
                      ? theme.textTheme.bodyMedium?.color
                      : theme.textTheme.bodyLarge?.color,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    _getTypeIcon(),
                    size: 12,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          trailing: !notification.isRead
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary,
                  ),
                )
              : null,
          onTap: onTap,
        ),
      ),
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

  Widget _buildLeadingIcon() {
    switch (notification.type) {
      case NotificationType.order:
        return const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.shopping_cart, color: Colors.white),
        );
      case NotificationType.promotion:
        return const CircleAvatar(
          backgroundColor: Colors.purple,
          child: Icon(Icons.local_offer, color: Colors.white),
        );
      case NotificationType.delivery:
        return const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.local_shipping, color: Colors.white),
        );
      case NotificationType.system:
        return const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.settings, color: Colors.white),
        );
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else {
      return DateFormat('MMM d, HH:mm').format(timestamp);
    }
  }
}
