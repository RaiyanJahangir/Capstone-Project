import 'package:email_password_login/screens/login_screen.dart';
import 'package:email_password_login/screens/register_child.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import './screens/login_screen.dart';
import './screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
