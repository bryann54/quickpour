// notifications_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:chupachap/features/notifications/data/models/notifications_model.dart';
import 'package:chupachap/features/notifications/data/repositories/notifications_repository.dart';
import 'package:equatable/equatable.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsBloc({required NotificationsRepository repository})
      : _repository = repository,
        super(const NotificationsState()) {
    on<FetchNotifications>(_onFetchNotifications);
    on<FetchUnreadCount>(_onFetchUnreadCount);
    on<DismissNotification>(_onDismissNotification);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
  }

  Future<void> _onFetchNotifications(
    FetchNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final notifications = await _repository.fetchNotifications();
      emit(state.copyWith(
        notifications: notifications,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to fetch notifications: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> _onFetchUnreadCount(
    FetchUnreadCount event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      final count = await _repository.getUnreadNotificationsCount();
      emit(state.copyWith(unreadCount: count));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to fetch unread count: $e'));
    }
  }

  Future<void> _onDismissNotification(
    DismissNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      await _repository.deleteNotification(event.notificationId);
      final updatedNotifications = state.notifications
          .where((notification) => notification.id != event.notificationId)
          .toList();
      emit(state.copyWith(notifications: updatedNotifications));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to delete notification: $e'));
    }
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      await _repository.markNotificationAsRead(event.notificationId);
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == event.notificationId) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();
      emit(state.copyWith(notifications: updatedNotifications));
      add(FetchUnreadCount());
    } catch (e) {
      emit(state.copyWith(error: 'Failed to mark notification as read: $e'));
    }
  }
}