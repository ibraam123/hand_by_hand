import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// Initialize FCM notifications
  Future<void> initNotifications() async {
    // Request notification permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Check if permission granted
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Set foreground notification presentation options (iOS only)
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get FCM token
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      print('FCM Token: $token');
    }
  }

  /// Handle incoming notifications
  void handleNotifications(RemoteMessage message) {
    if (message.notification != null) {
      final notification = message.notification!;
      print('Notification Title: ${notification.title}');
      print('Notification Body: ${notification.body}');
      // You can also trigger local notifications here if needed
    }
  }

  /// Initialize push notification listeners
  void initPushNotifications() {
    // App in foreground
    FirebaseMessaging.onMessage.listen(handleNotifications);

    // App opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotifications);
  }
}
