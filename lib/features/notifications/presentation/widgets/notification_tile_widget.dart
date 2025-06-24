import 'package:flutter/material.dart';
import 'package:chupachap/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:chupachap/features/notifications/data/models/notifications_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chupachap/features/notifications/presentation/widgets/notification_icon.dart';
import 'package:chupachap/features/notifications/presentation/widgets/notification_footer.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.onTap,
    required this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        context
            .read<NotificationsBloc>()
            .add(DismissNotification(notification.id));
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: Icon(Icons.delete, color: Colors.red.shade700),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: notification.isRead
              ? theme.cardColor
              : theme.colorScheme.primary.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (!notification.isRead)
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NotificationIcon(notification: notification, theme: theme),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: notification.isRead
                                      ? FontWeight.w500
                                      : FontWeight.w600,
                                  color: notification.isRead
                                      ? theme.textTheme.bodyLarge?.color
                                      : theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            if (!notification.isRead)
                              Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notification.body,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: notification.isRead
                                ? theme.textTheme.bodyMedium?.color
                                    ?.withValues(alpha: 0.8)
                                : theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 12),
                        NotificationFooter(
                            notification: notification, theme: theme),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
