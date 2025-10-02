import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/services/notification_service.dart';
import 'data/local_data_source/notification_local_data_source.dart';
import 'data/models/notification_model.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NotificationLocalDataSource localDataSource;

  FirebaseApi({required this.localDataSource});

  /// Initialize FCM notifications
  Future<void> initNotifications() async {
    // Request notification permissions
    final NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print("New FCM Token: $newToken");
      await _saveTokenToFirestore(newToken);
    });


    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Initialize local data source
    await localDataSource.init();

    // Foreground notification options (iOS)
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _firebaseMessaging.requestPermission(
      
    );
    // Get FCM token
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      print('FCM Token: $token');
      await _saveTokenToFirestore(token);
    }
  }

  /// Handle incoming notifications and save to BOTH Firestore AND Hive
  Future<void> handleNotifications(RemoteMessage message) async {
    if (message.notification != null) {
      final notification = message.notification!;

      final notificationModel = NotificationModel(
        id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: notification.title ?? 'No Title',
        body: notification.body ?? 'No Body',
        timestamp: DateTime.now(),
      );

      // Save to Firestore with same ID
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationModel.id)
          .set({
        'title': notificationModel.title,
        'body': notificationModel.body,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Save to Hive
      await localDataSource.saveNotification(notificationModel);

      // 👉 Show as a real local notification
      await NotificationService.showNotification(
        title: notificationModel.title,
        body: notificationModel.body,
      );
    }
  }
  Future<void> _saveTokenToFirestore(String token) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('user_tokens').doc(userId).set({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }


  /// Initialize push notification listeners
  void initPushNotifications() {
    // App in foreground
    FirebaseMessaging.onMessage.listen(handleNotifications);

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotifications);
  }
}
class NotificationRepository {
  final NotificationLocalDataSource localDataSource;

  NotificationRepository({required this.localDataSource});

  /// Get notifications from LOCAL storage (Hive)
  List<NotificationModel> getNotifications() {
    return localDataSource.getNotifications();
  }

  /// Remove notification from LOCAL storage only
  Future<void> removeNotification(String notificationId) async {
    await localDataSource.removeNotificationLocally(notificationId);
  }


}