import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  // Initialize Local Notifications
  Future<void> initializeLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: android,
    );

    await _localNotifications.initialize(settings);
  }

  // Initialize Firebase Messaging
  Future<void> initialize() async {
    // Initialize Local Notifications
    await initializeLocalNotifications();

    // Notification Permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint("Notification Permission: ${settings.authorizationStatus}");

    // FCM Token
    String? token = await _messaging.getToken();

    debugPrint("FCM TOKEN:");
    debugPrint(token);

    // Foreground Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("Foreground Notification");

      await _localNotifications.show(
        0,
        message.notification?.title ?? "The Sixer Factory",
        message.notification?.body ?? "",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'cricket_channel',
            'Cricket Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    });

    // Notification Click
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification Clicked");
    });
  }
}