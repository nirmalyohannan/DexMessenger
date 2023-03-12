// import 'dart:developer';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static const NotificationDetails notificationDetails = NotificationDetails(
//       android: AndroidNotificationDetails(
//     'DexchannelId',
//     'DexchannelName',
//   ));

//   static Future<void> init() async {
//     const AndroidInitializationSettings androidInitializationSettings =
//         AndroidInitializationSettings('@mipmap/launcher_icon');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: androidInitializationSettings);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   static Future<void> showNotification(
//       int id, String title, String? body) async {
//     log('Calling Notification');
//     await flutterLocalNotificationsPlugin.show(
//         id, title, body, notificationDetails);
//     log('Calling Notification Completed');
//   }
// }
