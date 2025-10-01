import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../notification/data/models/notification_model.dart';
import '../../../notification/firebase_api.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository repository;

  NotificationsCubit(this.repository) : super(NotificationsInitial());

  Future<void> loadNotifications() async {
    emit(NotificationsLoading());
    try {
      final notifications = repository.getNotifications()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      await repository.removeNotification(id);
      await loadNotifications();
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

}