import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dex_messenger/core/credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void sendPushMessage(String body, String title, String token) async {
  try {
    log('recipent FCM Token: $token');
    Response response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$fcmServerKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,

            "android_channel_id": "messageChannelID", // For Android >= 8
            "channel_id": "messageChannelID", // For Android Version < 8
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          "to": token,
        },
      ),
    );
    log('${response.statusCode}/${response.body}');
    log('done');
  } catch (e) {
    log("error push notification");
  }
}

//-----------------
void listenFCM() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'messageChannelID', 'Message Channel',
              icon: 'launch_foreground',
              importance: Importance.high,
              priority: Priority.high,
              fullScreenIntent: true,
              enableVibration: true,
              ongoing: true,
              playSound: true),
        ),
      );
    }
  });
}

//-----------------------------------------
void loadFCM() async {
  if (!kIsWeb) {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
        'messageChannelID', // id
        'Message Channel', // title
        enableVibration: true,
        importance: Importance.high,
        playSound: true);

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
//----------------------------------------------------------

Future<void> updateFCMToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    log('current fcm token: $token');
    String userUID = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .update({'fcmToken': token});
  }
}
