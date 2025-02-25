// lib/features/notifications/presentation/screens/notifications_screen.dart
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:chupachap/features/notifications/presentation/widgets/empty_notifications.dart';
import 'package:chupachap/features/notifications/presentation/widgets/notifications_header.dart';
import 'package:chupachap/features/notifications/presentation/widgets/notifications_list.dart';
import 'package:chupachap/features/notifications/presentation/widgets/shimmer_notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<NotificationsBloc>();
      bloc
        ..add(FetchNotifications())
        ..add(FetchUnreadCount());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showNotification: false, showCart: false),
      body: Column(
        children: [
          const NotificationsHeader(),
          Expanded(
            child: BlocConsumer<NotificationsBloc, NotificationsState>(
              listener: _handleNotificationStateChanges,
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: NotificationTileShimmer());
                }

                if (state.notifications.isEmpty) {
                  return const EmptyNotificationsView();
                }

                return NotificationsList(notifications: state.notifications);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleNotificationStateChanges(
    BuildContext context,
    NotificationsState state,
  ) {
    if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error!)),
      );
    }
  }
}
