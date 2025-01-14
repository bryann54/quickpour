// notifications_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:chupachap/features/notifications/data/models/notifications_model.dart';
import 'package:chupachap/features/notifications/data/repositories/notifications_repository.dart';
import 'package:equatable/equatable.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsBloc(this._repository) : super(const NotificationsState()) {
    on<FetchNotifications>(_onFetchNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<FetchUnreadCount>(_onFetchUnreadCount);
  }

  Future<void> _onFetchNotifications(
    FetchNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final notifications = await _repository.fetchNotifications();
      final unreadCount = notifications.where((n) => !n.isRead).length;

      emit(state.copyWith(
        notifications: notifications,
        unreadCount: unreadCount,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      await _repository.markNotificationAsRead(event.notificationId);

      // Update the local state to reflect the change
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == event.notificationId) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();

      final newUnreadCount =
          updatedNotifications.where((n) => !n.isRead).length;

      emit(state.copyWith(
        notifications: updatedNotifications,
        unreadCount: newUnreadCount,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onFetchUnreadCount(
    FetchUnreadCount event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      final notifications = await _repository.fetchNotifications();
      final unreadCount = notifications.where((n) => !n.isRead).length;
      emit(state.copyWith(unreadCount: unreadCount));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
