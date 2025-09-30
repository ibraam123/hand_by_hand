import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:hand_by_hand/core/widgets/custom_snackbar.dart';

import '../../../../../init_dependcies.dart';
import '../../../../notification/data/models/notification_model.dart';
import '../../../../notification/firebase_api.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationRepository _notificationRepository = serviceLocator<NotificationRepository>();
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    final notifications = _notificationRepository.getNotifications();
    notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    setState(() {
      _notifications = notifications;
    });
  }

  Future<void> _deleteNotification(String notificationId) async {
    await _notificationRepository.removeNotification(notificationId);
    _loadNotifications();

    CustomSnackBar.show(
      context,
      message: Notifications.remove.tr(),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
      icon: Icons.remove_circle_outline,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    final theme = Theme.of(context);
    if (_notifications.isEmpty) {
      return Center(
        child: Text(Notifications.noNotifications.tr(),
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey)),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];

        return Card(
          color: theme.cardColor,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(notification.title,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            subtitle:
                Text(notification.body, style: theme.textTheme.bodyMedium),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteNotification(notification.id),
            ),
            leading: Icon(Icons.notifications, color: theme.primaryColor),
          ),
        );
      },
    );
  }
}