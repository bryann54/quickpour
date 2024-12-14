// notifications_screen.dart
import 'package:chupachap/features/notifications/data/models/notifications_model.dart';
import 'package:chupachap/features/notifications/data/repositories/notifications_repository.dart';
import 'package:chupachap/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NotificationsBloc(context.read<NotificationsRepository>())
            ..add(FetchNotifications()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          centerTitle: true,
        ),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state.error != null) {
              return Center(
                child: Text('Error: ${state.error}'),
              );
            }

            if (state.notifications.isEmpty) {
              return const Center(
                child: Text('No notifications'),
              );
            }

            return ListView.builder(
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                return _NotificationTile(
                  notification: notification,
                  onTap: () {
                    context
                        .read<NotificationsBloc>()
                        .add(MarkNotificationAsRead(notification.id));
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildLeadingIcon(),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification.body,
            style: TextStyle(
              color: notification.isRead ? Colors.grey : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatTimestamp(notification.timestamp),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      trailing: !notification.isRead
          ? Icon(Icons.circle, color: Theme.of(context).primaryColor, size: 12)
          : null,
      onTap: onTap,
    );
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
