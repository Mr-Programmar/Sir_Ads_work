// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class FCMServices {
  static var fcmServerKey =
      'AAAAG_WvXug:APA91bGZwJo8NylzJAYG7QKDBj2GArbEraKELhBz9G39VnuLw_-lscY-jrkj2xuiCp2N4xxYZrJ9l01YraHcOsn4ObLps3Vr74rE4wDIYCNbSP53A65VPJBgy-db56UD7eZll07sWTWn';

//  get device token
  static generateFCMToken() {
    try {
      FirebaseMessaging.instance.getToken().then((value) {
        print("Device Token: $value");
      });
    } catch (e) {
      print("Device Token e: $e");
    }
  }

// listen onApp FCM
  static listenAppFCM() {
    FirebaseMessaging.onMessage.listen((event) {
      print("OnApp FCM : $event");

      String title = event.notification!.title.toString();
      String body = event.notification!.body.toString();

      print(title);
      print(body);
      displyNotification(title: title, body: body);
    });
  }

  // listen background FCM

  static listenbackgroundFCM(RemoteMessage message) {
    print("FCM message");

    var title = message.notification!.title;
    var body = message.notification!.body;
    // displyNotification(title: title.toString(), body: body.toString());
  }

  // createLocalNotificaion()
  static displyNotification({required String title, required String body}) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ));

    flutterLocalNotificationsPlugin.show(
      1,
      "title",
      "body",
      NotificationDetails(
          android: AndroidNotificationDetails(
        "1",
        "test",
        // playSound: true,
        // priority: Priority.high,
        // importance: Importance.high,
        // enableVibration: true,
      )),
    );
  }

  static sendFCMNotification() async {
    final responce = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$fcmServerKey'
      },
      body: jsonEncode({
        'to': '',
        'notification': {
          'title': '',
          'body': '',
        }
      }),
    );
  }
}
