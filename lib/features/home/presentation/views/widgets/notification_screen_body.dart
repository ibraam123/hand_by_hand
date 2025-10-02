import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_by_hand/core/config/app_keys_localization.dart';
import 'package:hand_by_hand/core/widgets/custom_snackbar.dart';

import '../../../../notification/data/models/notification_model.dart';
import '../../logic/notifications_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsCubit>().loadNotifications();
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationsError) {
          CustomSnackBar.show(
            context,
            message: state.message,
            backgroundColor: Theme.of(context).colorScheme.error,
            icon: Icons.error_outline,
          );
        }
      },
      builder: (context, state) {
        if (state is NotificationsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NotificationsLoaded) {
          if (state.notifications.isEmpty) {
            return _buildEmptyState();
          }

          return _buildNotificationsList(state.notifications);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(16.w),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return NotificationCard(
          notification: notification,
          onDelete: () => _deleteNotification(notification.id),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64.sp,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            Notifications.noNotifications.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _deleteNotification(String id) {
    context.read<NotificationsCubit>().deleteNotification(id);
    CustomSnackBar.show(
      context,
      message: Notifications.remove.tr(),
      backgroundColor: Theme.of(context).colorScheme.error,
      icon: Icons.delete_outline,
      duration: const Duration(seconds: 2),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.cardColor,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Icon(Icons.notifications, color: theme.colorScheme.primary, size: 28.sp),
        title: Text(
          notification.title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Wrap(
          spacing: 8.w, // Horizontal space between items
          runSpacing: 4.h, // Vertical space between lines
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: double.infinity),
              child: Text(
                notification.body,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              _formatTimestamp(notification.timestamp),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: theme.colorScheme.error),
          tooltip: Notifications.remove.tr(),
          onPressed: onDelete,
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    }
    return 'Just now';
  }
}
