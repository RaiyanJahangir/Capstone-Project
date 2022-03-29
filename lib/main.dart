import 'package:flutter/material.dart';
//import 'package:googleapis/calendar/v3.dart';
import 'Screens/login/login.dart';
//import 'drive/upload_screen.dart';
//import 'Screens/study_materials/study_materials.dart';
import 'Screens/study_materials/book.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF2661FA),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}