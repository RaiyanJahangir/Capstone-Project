import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/Screens/login/login.dart';
import 'package:lottie/lottie.dart';
import 'package:login/Screens/Calendar/calendar.dart';
import 'package:login/Screens/attendance/attendance.dart';
import 'package:login/Screens/result/result.dart';
import 'package:login/Screens/assignment/assignment.dart';
import 'package:login/Screens/study_materials/study_materials.dart';
import 'package:login/Screens/notice/notice.dart';

enum _MenuValues {
  logout,
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            // do something
          },
        ),
        title: Text('Homepage'),
        actions: [
          PopupMenuButton<_MenuValues>(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Text('LogOut'),
                value: _MenuValues.logout,
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case _MenuValues.logout:
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (c) => LoginScreen()));
                  break;
              }
            },
          ),
          //Text('mr x',),
          // IconButton(
          //   icon: Icon(
          //     Icons.account_circle,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     // do something
          //   },
          //),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        primary: false,
        children: [
          Card(
            elevation: 4,
            child: InkWell(
              onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => FirstScreen()),),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: 
                      Lottie.asset(
                          "assets/books.json",
                          width: 200,
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                    ),
                    Expanded(
                      flex: 1,
                        child: Text('Study Materials')
                    )
                  ],
                ),
               ),
              ),
          Card(
            elevation: 4,
            child: InkWell(
              onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const attendance()),),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: 
                        Lottie.asset(
                          "assets/attendance.json",
                          width: 200,
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text('Attendance'))
                  ],
                ),
            ),
          ),
          Card(
            elevation: 4,
            child: InkWell(
              onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const rsheet()),),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: 
                        Lottie.asset(
                          "assets/result.json",
                          width: 200,
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                    ),
                    Expanded(flex: 1,child: Text('Result'))
                  ],
                ),
            ),
          ),
          Card(
            elevation: 4,
            child: InkWell(
              onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const assign()),),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: 
                        Lottie.asset(
                          "assets/assignment.json",
                          width: 200,
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                    ),
                    Expanded(flex: 1,child: Text('Assignment'))
                  ],
                ),
            ),
          ),
          Card(
            elevation: 4,
            child: InkWell(
              onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const notice()),),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: 
                        Lottie.asset(
                          "assets/notice.json",
                          width: 200,
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                    ),
                    Expanded(flex:1,child: Text('Notice'))
                  ],
                ),
            ),
          ),
          Card(
            elevation: 4,
            child: InkWell(
              onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => const calendar()),),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Expanded(
                    flex: 4,
                    child:
                    Lottie.asset(
                      "assets/calendar.json",
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                ),
                    Expanded(flex: 1,child: Text('Calendar'))
                  ],
                ),
            ),
          )
        ],

      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        child: Container(
          //height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              IconButton(onPressed: null, icon: Icon(Icons.calendar_view_month_rounded , color: Colors.white, size: 30.0,)),
              IconButton(onPressed: null, icon: Icon(Icons.home , color: Colors.white, size: 30.0,)),
              IconButton(onPressed: null, icon: Icon(Icons.cast_for_education_rounded , color: Colors.white, size: 30.0,))
            ],
          ),
        )
      ),
    );
  }
}
