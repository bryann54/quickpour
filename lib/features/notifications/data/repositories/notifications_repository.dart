// notifications_repository.dart
import 'package:chupachap/features/notifications/data/models/notifications_model.dart';

class NotificationsRepository {
  // Simulated notifications data source
  Future<List<NotificationModel>> fetchNotifications() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      NotificationModel(
        id: '1',
        title: 'Order Confirmed',
        body:
            'Your drink order #1234 has been confirmed and is being prepared.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.order,
      ),
      NotificationModel(
        id: '2',
        title: 'Special Promotion',
        body: '50% off on all cocktails this weekend! Don\'t miss out.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.promotion,
      ),
      NotificationModel(
        id: '3',
        title: 'Delivery Update',
        body: 'Your order is out for delivery and will arrive in 15 minutes.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        type: NotificationType.delivery,
      ),
      NotificationModel(
        id: '4',
        title: 'System Maintenance',
        body: 'Our app will undergo brief maintenance tonight at 11 PM.',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        type: NotificationType.system,
      ),
    ];
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    // Simulating API call to mark notification as read
    await Future.delayed(const Duration(milliseconds: 300));
    print('Notification $notificationId marked as read');
  }
}
