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
  }

  Future<void> _onFetchNotifications(
    FetchNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final notifications = await _repository.fetchNotifications();
      emit(state.copyWith(
        notifications: notifications,
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
      final updatedNotifications = state.notifications
          .map((notification) => notification.id == event.notificationId
              ? notification.copyWith(isRead: true)
              : notification)
          .toList();
      emit(state.copyWith(notifications: updatedNotifications));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
