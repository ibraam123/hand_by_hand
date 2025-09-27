import '../models/notification_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class NotificationLocalDataSource {
  /// Initialize Hive box for notifications
  Future<void> init();

  /// Save notification to local storage
  Future<void> saveNotification(NotificationModel notification);

  /// Save multiple notifications to local storage
  Future<void> saveNotifications(List<NotificationModel> notifications);

  /// Get all notifications from local storage
  List<NotificationModel> getNotifications();

  /// Remove notification from local storage only (not from Firestore)
  Future<void> removeNotificationLocally(String notificationId);

}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  Box<NotificationModel>? _notificationsBox;
  final String _notificationsBoxName = 'notifications';

  @override
  Future<void> init() async {
    // Check if adapter is already registered to avoid errors
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NotificationModelAdapter());
    }
    _notificationsBox = await Hive.openBox<NotificationModel>(_notificationsBoxName);
  }

  @override
  Future<void> saveNotification(NotificationModel notification) async {
    await _notificationsBox?.put(notification.id, notification);
  }

  @override
  Future<void> saveNotifications(List<NotificationModel> notifications) async {
    final Map<String, NotificationModel> notificationsMap = {
      for (var notification in notifications) notification.id: notification
    };
    await _notificationsBox?.putAll(notificationsMap);
  }

  @override
  List<NotificationModel> getNotifications() {
    return _notificationsBox?.values.toList() ?? [];
  }


  @override
  Future<void> removeNotificationLocally(String notificationId) async {
    await _notificationsBox?.delete(notificationId);
  }

}