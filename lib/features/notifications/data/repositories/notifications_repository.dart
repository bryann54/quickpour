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

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final userId = _auth.currentUser?.uid;
      // Debug log

      if (userId == null) {
        // Debug log
        return [];
      }

      final querySnapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      // Debug log

      final notifications = querySnapshot.docs.map((doc) {
        final data = doc.data();
        // Debug log
        // Debug log

        return NotificationModel(
          id: doc.id,
          title: data['title'] ?? '',
          body: data['body'] ?? '',
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          isRead: data['isRead'] ?? false,
          type: _getNotificationType(data['type'] ?? 'system'),
        );
      }).toList();

      // Debug log
      return notifications;
    } catch (e) {
      // Debug log
      rethrow;
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
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  Future<int> getUnreadNotificationsCount() async {
    try {
      final userId = _auth.currentUser?.uid;

      if (userId == null) {
        return 0;
      }

      final querySnapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to fetch unread notifications count: $e');
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
