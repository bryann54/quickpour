import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chupachap/features/notifications/data/models/notifications_model.dart';

class NotificationsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  NotificationsRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final querySnapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return NotificationModel(
          id: doc.id,
          title: data['title'] ?? '',
          body: data['body'] ?? '',
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          isRead: data['isRead'] ?? false,
          type: _getNotificationType(data['type'] ?? 'system'),
        );
      }).toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      print('Error marking notification as read: $e');
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  Future<void> createNotification({
    required String title,
    required String body,
    required NotificationType type,
    required String userId,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'title': title,
        'body': body,
        'type': _getNotificationTypeString(type),
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'userId': userId,
      });
    } catch (e) {
      print('Error creating notification: $e');
      throw Exception('Failed to create notification: $e');
    }
  }

  NotificationType _getNotificationType(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return NotificationType.order;
      case 'promotion':
        return NotificationType.promotion;
      case 'delivery':
        return NotificationType.delivery;
      case 'system':
      default:
        return NotificationType.system;
    }
  }

  String _getNotificationTypeString(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return 'order';
      case NotificationType.promotion:
        return 'promotion';
      case NotificationType.delivery:
        return 'delivery';
      case NotificationType.system:
        return 'system';
    }
  }
}
