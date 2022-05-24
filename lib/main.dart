import 'package:email_password_login/screens/login_screen.dart';
import 'package:email_password_login/screens/register_child.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/user_home_page.dart';
import './screens/login_screen.dart';
import './screens/notification_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'dart:ui';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          //channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  //'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setEnabledSystemUIMode(
//       SystemUiMode.leanBack,
//     );
//     return MaterialApp(
//       title: 'Baby Monitor',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: const LoginScreen(),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseReference _database = FirebaseDatabase().reference();
  FirebaseMessaging? _fcm;
  String? message;
  String? token;

  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                //channel.description,
                icon: android.smallIcon,
              ),
            ));
      }
    });
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.leanBack,
    );
    return MaterialApp(
      title: 'Baby Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = token;
    });
    final DatabaseReference _database = FirebaseDatabase().reference();
    _database.child('fcm-token/${token}').set({"token": token});
  }
}
