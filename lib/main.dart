import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp_gocar/SplashScreen/splash_screen.dart';
import 'package:fyp_gocar/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'message_screen.dart';
import 'notificationservice/local_notification_services.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    print("Handling a background message: ${message.messageId}");
    print(message.data.toString());
    print(message.notification!.title);
    await Firebase.initializeApp();
  } catch (e) {
    print('error $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "gocarflutter", options: DefaultFirebaseOptions.currentPlatform);

  LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  HttpOverrides.global = MyHttpOverrides();
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => const MySplashScreen(),
      '/Message_Screen': (context) => const MessageScreen(),
    },
    debugShowCheckedModeBanner: false,
  ));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
