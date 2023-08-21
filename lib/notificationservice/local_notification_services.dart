import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp_gocar/message_screen.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> requestNotificationPermissions() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted the permision');
    } else {
      print('user rejected the permision');
    }
  }

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void initializeForground(BuildContext context, RemoteMessage message) async {
    // initializationSettings  for Android
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print('onDidReceiveNotificationResponse called....');

        handleMessage(context, message);
      },
    );
  }

  // //handle tap on notification when app is in background or terminated
  // Future<void> initializeBackground(BuildContext context) async {
  //   // when app is terminated
  //   RemoteMessage? initialMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();

  //   if (initialMessage != null) {
  //     handleMessage(context, initialMessage);
  //   }

  //   //when app ins background
  //   FirebaseMessaging.onMessageOpenedApp.listen((event) {
  //     handleMessage(context, event);
  //   });
  // }

  Future<void> initializeBackground(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }
  // void initializeBackground(BuildContext context, RemoteMessage message) async {
  //   // initializationSettings  for Android
  //   var androidInitializationSettings =
  //       const AndroidInitializationSettings('@mipmap/ic_launcher');

  //   var initializationSettings = InitializationSettings(
  //     android: androidInitializationSettings,
  //   );

  //   _notificationsPlugin.initialize(
  //     initializationSettings,
  //     onDidReceiveBackgroundNotificationResponse: (details) {
  //       print('onDidReceiveNotificationResponse called....');

  //       handleMessage(context, message);
  //     },
  //   );
  // }

  void createanddisplaynotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "gocar",
          "gocarchannel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      final mypayload = {
        'id': message.data['id'],
        'email': message.data['email'],
        'phone': message.data['phone'],
      };

      await _notificationsPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: jsonEncode(mypayload));
    } on Exception catch (e) {
      print(e);
    }
  }

  handleMessage(BuildContext context, RemoteMessage message) {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    if (message.data['type'] == 'msj') {
      Navigator.pushNamed(context, message.data['route']);

      print(message.data['route']);
      print(message.data['type']);

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => MessageScreen(
      //               id: id.toString(),
      //               payloadid: message.data['id'].toString(),
      //               email: message.data['email'].toString(),
      //               phone: message.data['phone'].toString(),
      //             )));
    }
  }

  Future<void> sendNotificationToDevice(String route, String token) async {
    try {
      const String firebaseUrl = 'https://fcm.googleapis.com/fcm/send';

      final FirebaseMessaging messaging = FirebaseMessaging.instance;
      final String notificationTitle = 'New booking';
      final String notificationBody = 'A new user booked a ride.';

      final response = await messaging.getToken().then((value) async {
        var data = {
          'to': token,
          'notification': {
            'title': notificationTitle,
            'body': notificationBody,
            "sound": "jetsons_doorbell.mp3"
          },
          'android': {
            'notification': {
              'notification_count': 23,
            },
          },
          'data': {
            'type': 'msj',
            'id': 'Rehman',
            'email': 'abdulrehman992017@gmail.com',
            'phone': '03172404046',
            'route': route,
          },
        };

        await http
            .post(Uri.parse(firebaseUrl), body: jsonEncode(data), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key=AAAAPmwI--g:APA91bEmMT61PxJdlrEB73RDiXhruhXVHQZY7xX8dR4NdLLmQALQ6EgoCAddXDnfb4q7WPe0YEFIh7oXall2_m8WeyNp6IbYwntRByX1-7I-vKv5GZo1HuNpKK5d2gommgs-JecTFGq-'
        }).then((value) {
          if (kDebugMode) {
            print(value.body.toString());
          }
        }).onError((error, stackTrace) {
          if (kDebugMode) {
            print(error);
          }
        });
      });

      if (response != null) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  void getDeviceToken() async {
    String? token = await messaging.getToken();
    print(token);
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('token refresh');
      }
    });
  }
}
