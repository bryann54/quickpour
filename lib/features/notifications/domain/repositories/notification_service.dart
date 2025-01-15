// notification_service.dart
import 'package:chupachap/features/notifications/data/models/notifications_model.dart';
import 'package:chupachap/features/notifications/data/repositories/notifications_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static late NotificationsRepository _repository;

  static void initialize(NotificationsRepository repository) async {
    if (_initialized) return;
    _repository = repository;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Notification tapped: ${details.payload}');
      },
    );

    _initialized = true;
  }

  static Future<void> showOrderNotification({
    required String title,
    required String body,
    required String userId,
    String? payload,
  }) async {
    try {
      // First, create the Firestore notification
      await _repository.createNotification(
        title: title,
        body: body,
        type: NotificationType.order,
        userId: userId,
      );

      // Then, show the local notification
      const androidDetails = AndroidNotificationDetails(
        'orders_channel',
        'Orders',
        channelDescription: 'Notifications for order updates',
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.show(
        DateTime.now().millisecond,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
    } catch (e) {
      print('Error showing notification: $e');
      // You might want to handle this error differently
    }
  }
}
