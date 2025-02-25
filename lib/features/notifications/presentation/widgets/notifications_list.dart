// lib/features/notifications/presentation/widgets/notifications_list.dart
import 'package:chupachap/features/notifications/data/models/notifications_model.dart';
import 'package:chupachap/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:chupachap/features/notifications/presentation/widgets/notification_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsList extends StatelessWidget {
  final List<NotificationModel> notifications;

  const NotificationsList({
    super.key,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NotificationsBloc>()
          ..add(FetchNotifications())
          ..add(FetchUnreadCount());
      },
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationTile(
            key: ValueKey(notification.id),
            notification: notification,
            onTap: () => _handleNotificationTap(context, notification),
            onDismissed: () =>
                _handleNotificationDismiss(context, notification),
          );
        },
      ),
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    NotificationModel notification,
  ) {
    if (!notification.isRead) {
      context.read<NotificationsBloc>()
        ..add(MarkNotificationAsRead(notification.id))
        ..add(FetchUnreadCount());
    }
  }

  void _handleNotificationDismiss(
    BuildContext context,
    NotificationModel notification,
  ) {
    context.read<NotificationsBloc>().add(DismissNotification(notification.id));
  }
}
