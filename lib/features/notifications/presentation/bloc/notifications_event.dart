part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class FetchNotifications extends NotificationsEvent {}

class FetchUnreadCount extends NotificationsEvent {}

class DismissNotification extends NotificationsEvent {
  final String notificationId;

  const DismissNotification(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class MarkNotificationAsRead extends NotificationsEvent {
  final String notificationId;

  const MarkNotificationAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}
