import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final notificationService = NotificationService();
  await notificationService.initialize();

  FirebaseMessaging.onMessage.listen((message) {
    if (message.notification != null) {
      notificationService.showNotification(message);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    notificationService.showNotification(message);
  });

  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'Subscribed to all_users channel',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      ),
    ),
  );
}
