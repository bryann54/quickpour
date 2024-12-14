// notification_model.dart
import 'package:equatable/equatable.dart';

enum NotificationType { order, promotion, delivery, system }

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [id, title, body, timestamp, isRead, type];
}
