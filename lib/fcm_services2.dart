import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class FCMServices {
  static const FCMServerToken =
      "AAAAXd7oP3Q:APA91bEpgzSIWUhryqZ8a0YSD2a5BEoqIfB5lMoVMnuhgywSV_AZTmP8PTIiNsXnjcb3_9V57gQfVt8g82smDdwvYLDW5RazXY6MTzJ8NHXiOL9FNNGbn3dh2AAlR361vWrIOeDOsiyo";

// get FCM Token
  static getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      log("FCM Token: $value");
    });
  }

//  subscrible To Topic
  static subscribeToTopic({required topicName}) {
    FirebaseMessaging.instance.subscribeToTopic("$topicName");
  }

// InApp Listen Notification 
  static fcmListen() {
    FirebaseMessaging.onMessage.listen((event) {
      print("RealTime Event: $event");
      var title = event.notification!.title.toString();
      var body = event.notification!.body.toString();
      var data = event.data.toString();

      // show notification
      ShowNotification(title: title, body: body);
    });
  }

// Listen Background Notification
  static Future backgroundMessage(RemoteMessage message) async {


    print("Background Masg: $message");
    print("Title: ${message.notification!.title}");
    print("Body: ${message.notification!.body}");

    // show notification
    ShowNotification(
        title: message.notification!.title.toString(),
        body: message.notification!.body.toString());
  }

// Show Notification
  static ShowNotification({required String title, required String body}) {
    FlutterLocalNotificationsPlugin notificationsPlugin =
        FlutterLocalNotificationsPlugin();

    notificationsPlugin.initialize(const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher")));

    notificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "id",
          "android",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
    );
  }

//  send Notification
  static sendNotification({required to, required title, required body}) async {
    final responce = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=$FCMServerToken',
      },
      body: jsonEncode({
        "to": "$to",
        "notification": {"title": "$title", "body": "$body"},
        // "data": {"item": "Phone", "item_price": "500"}
      }),
    );

    var resCode = responce.statusCode.toString();
    print("Notification status Code: $resCode");
  }
}
