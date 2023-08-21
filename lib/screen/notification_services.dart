// import 'dart:convert';
// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:fyp_gocar/message_screen.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationServices {
//   //initialising firebase message plugin
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   //initialising firebase message plugin
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   //function to initialise flutter local notification plugin to show notifications for android when app is active
//   void initLocalNotifications(
//       BuildContext context, RemoteMessage message) async {
//     var androidInitializationSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitializationSettings = const DarwinInitializationSettings();

//     var initializationSetting = InitializationSettings(
//         android: androidInitializationSettings, iOS: iosInitializationSettings);

//     await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
//         onDidReceiveNotificationResponse: (payload) {
//       // handle interaction when app is active for android
//       handleMessage(context, message);
//     });
//   }

//   void requestNotificationPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print('user granted permission');
//       }
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print('user granted provisional permission');
//       }
//     } else {
//       //appsetting.AppSettings.openNotificationSettings();
//       if (kDebugMode) {
//         print('user denied permission');
//       }
//     }
//   }

//   // function to show visible notification when app is active
//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//         message.notification!.android!.channelId.toString(),
//         message.notification!.android!.channelId.toString(),
//         importance: Importance.max,
//         showBadge: true,
//         playSound: true,
//         sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'));

//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//             channel.id.toString(), channel.name.toString(),
//             channelDescription: 'your channel description',
//             importance: Importance.high,
//             priority: Priority.high,
//             playSound: true,
//             ticker: 'ticker',
//             sound: channel.sound
//             //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
//             //  icon: largeIconPath
//             );

//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//             presentAlert: true, presentBadge: true, presentSound: true);

//     NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: darwinNotificationDetails);

//     Future.delayed(Duration.zero, () {
//       _flutterLocalNotificationsPlugin.show(
//         0,
//         message.notification!.title.toString(),
//         message.notification!.body.toString(),
//         notificationDetails,
//       );
//     });
//   }

//   void handleMessage(BuildContext context, RemoteMessage message) {
//     if (message.data['type'] == 'msj') {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => MessageScreen(
//                     id: message.data['id'],
//                     payloadid: message.data[''],
//                     email: message.data['adkab@gmail.com'],
//                     phone: message.data['1213133'],
//                   )));
//     }
//   }

//   //function to get device token on which we will send the notifications
//   Future<String> getDeviceToken() async {
//     String? token = await messaging.getToken();
//     return token!;
//   }

//   void isTokenRefresh() async {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//       if (kDebugMode) {
//         print('refresh');
//       }
//     });
//   }

//   Future<void> sendNotificationToDevice() async {
//     try {
//       const String firebaseUrl = 'https://fcm.googleapis.com/fcm/send';

//       final FirebaseMessaging messaging = FirebaseMessaging.instance;
//       final String notificationTitle = 'Abdul rehman';
//       final String notificationBody = 'This is a test notification for gocar';

//       final response = await messaging.getToken().then((value) async {
//         var data = {
//           'to': value.toString(),
//           'notification': {
//             'title': notificationTitle,
//             'body': notificationBody,
//             "sound": "jetsons_doorbell.mp3"
//           },
//           'android': {
//             'notification': {
//               'notification_count': 23,
//             },
//           },
//           'data': {
//             'type': 'msj',
//             'id': 'Rehman',
//             'email': 'abdulrehman992017@gmail.com',
//             'phone': '03172404046',
//           },
//         };

//         await http
//             .post(Uri.parse(firebaseUrl), body: jsonEncode(data), headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//           'Authorization':
//               'key=AAAAPmwI--g:APA91bEmMT61PxJdlrEB73RDiXhruhXVHQZY7xX8dR4NdLLmQALQ6EgoCAddXDnfb4q7WPe0YEFIh7oXall2_m8WeyNp6IbYwntRByX1-7I-vKv5GZo1HuNpKK5d2gommgs-JecTFGq-'
//         }).then((value) {
//           if (kDebugMode) {
//             print(value.body.toString());
//           }
//         }).onError((error, stackTrace) {
//           if (kDebugMode) {
//             print(error);
//           }
//         });
//       });

//       if (response != null) {
//         print('Notification sent successfully');
//       } else {
//         print('Failed to send notification');
//       }
//     } catch (e) {
//       print('Error sending notification: $e');
//     }
//   }
// }
