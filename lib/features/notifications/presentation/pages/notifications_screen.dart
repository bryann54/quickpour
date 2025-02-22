import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_appbar.dart';
import 'package:chupachap/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:chupachap/features/notifications/presentation/widgets/notification_tile_widget.dart';
import 'package:chupachap/features/notifications/presentation/widgets/shimmer_notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                  return _buildEmptyOrdersView(context);
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

  Widget _buildEmptyOrdersView(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Fix: Removed the Expanded widget that was causing the error
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Floating box animation background
          ...List.generate(15, (index) {
            final isSmall = index % 2 == 0;
            final xOffset = (index * 25 - 120).toDouble();
            final startY = index * 35 - 180.0;

            return Positioned(
              left: MediaQuery.of(context).size.width / 2 + xOffset,
              top: startY,
              child: Icon(
                FontAwesomeIcons.solidBell,
                color: isDarkMode
                    ? Colors.cyan.withOpacity(0.5 + (index % 5) * 0.1)
                    : Colors.cyan
                        .withOpacity(0.5 + (index % 5) * 0.1),
                size: isSmall ? 16.0 : 24.0,
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .moveY(
                    begin: 0,
                    end: 500,
                    duration: Duration(
                        seconds: isSmall ? 6 + index % 4 : 8 + index % 5),
                    curve: Curves.easeInOut,
                  )
                  .fadeIn(duration: 600.ms)
                  .then()
                  .fadeOut(
                    begin: 0.7,
                    delay: Duration(
                        seconds: isSmall ? 5 + index % 3 : 7 + index % 4),
                  ),
            );
          }),

          // Main content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/notifications.webp',
                width: 150,
                height: 150,
              ).animate().scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 800.ms,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 20),

              // Text message with animations
              Text(
                'No orders yet!',
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.titleLarge),
              ).animate().fadeIn(duration: 600.ms).scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 800.ms,
                  curve: Curves.elasticOut),

              const SizedBox(height: 10),

              Text(
                'Your order history will appear here',
                style: GoogleFonts.lato(
                    textStyle: Theme.of(context).textTheme.bodyLarge),
              )
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.5, duration: 800.ms),
            ],
          ),
        ],
      ),
    );
  }

}
