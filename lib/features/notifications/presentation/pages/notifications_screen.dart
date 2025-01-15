import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:chupachap/features/notifications/presentation/widgets/notification_tile_widget.dart';
import 'package:chupachap/features/notifications/presentation/widgets/shimmer_notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch notifications and unread count when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsBloc>().add(FetchNotifications());
      context.read<NotificationsBloc>().add(FetchUnreadCount());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: CustomAppBar(showNotification: false, showCart: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Notifications',
                style: GoogleFonts.montaga(
                  textStyle: theme.textTheme.displayLarge?.copyWith(
                    color: isDarkMode
                        ? AppColors.cardColor
                        : AppColors.accentColorDark,
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1),
            ),
          ),
          Expanded(
            child: BlocConsumer<NotificationsBloc, NotificationsState>(
              listener: (context, state) {
                if (state.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error!)),
                  );
                }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: NotificationTileShimmer(),
                  );
                }

                if (state.notifications.isEmpty) {
                  return const Center(
                    child: Text('No notifications'),
                  );
                }

                return RefreshIndicator(
                    onRefresh: () async {
                      context.read<NotificationsBloc>()
                        ..add(FetchNotifications())
                        ..add(FetchUnreadCount());
                    },
                    child: ListView.builder(
                      itemCount: state.notifications.length,
                      itemBuilder: (context, index) {
                        final notification = state.notifications[index];
                        return NotificationTile(
                          key: ValueKey(notification
                              .id), // Ensure a unique key for each tile
                          notification: notification,
                          onTap: () {
                            if (!notification.isRead) {
                              context.read<NotificationsBloc>()
                                ..add(MarkNotificationAsRead(notification.id))
                                ..add(FetchUnreadCount());
                            }
                          },
                        );
                      },
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
