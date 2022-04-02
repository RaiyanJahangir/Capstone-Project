// ignore_for_file: prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers

import 'package:email_password_login/screens/register_child.dart';
import 'package:email_password_login/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_typing_uninitialized_variables
  var selectType, selectGurd;
  // ignore: prefer_final_fields
  List<String> _gurdType = <String>[
    'Check babies as Guardian',
    'Check babies as Nurturer',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          // ignore: prefer_const_constructors
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (ctx) => RegistrationScreen(),
              ),
            );
          },
        ),
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            // ignore: prefer_const_constructors

            Expanded(
              child: Icon(
                Icons.circle_notifications,
                color: Colors.white,
                size: 24.0,
              ),
            ),
            Expanded(
              child: Text("John Cameron"),
            ),
            Expanded(
              child: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 24.0,
              ),
            ),
          ],
        ),
        //backgroundColor: Color.fromRGBO(232, 232, 242, 1),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                primary: false,
                children: [
                  Card(
                    elevation: 2,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (ctx) => RegisterChild(),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Expanded(
                            flex: 4,
                            child: Image(
                              image: AssetImage("assets/reg_child.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Register Child',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DropdownButton(
                borderRadius: BorderRadius.circular(10),
                items: _gurdType
                    .map((value) => DropdownMenuItem(
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Colors.blue[400],
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          value: value,
                        ))
                    .toList(),
                onChanged: (selectedGurdType) {
                  setState(() {
                    selectType = selectedGurdType;
                  });
                },
                value: selectType,
                isExpanded: false,
                hint: Text(
                  "Select Type Of Viewer",
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
