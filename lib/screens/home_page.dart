// ignore_for_file: prefer_const_constructors, duplicate_ignore, avoid_unnecessary_containers
//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/childReg_model.dart';
import 'package:email_password_login/screens/register_child.dart';
import 'package:email_password_login/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: prefer_typing_uninitialized_variables
  var selectType, selectGurd;
  var selectedType, selectedCat;
  // ignore: prefer_final_fields
  List<String> _gurdType = <String>[
    'Baby1',
    'Baby2',
    'Baby3',
    'Baby4',
    'Baby5',
    'Baby6',
  ];
  final selectedTypeEditingController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  ChildModel loggedInUser = ChildModel();

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("Babies")
        .doc(user!.uid)
        .get()
        .then((value) {
      // ignore: unnecessary_this
      this.loggedInUser = ChildModel.fromMap(value.data());
      setState(() {});
    });
  }

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
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                primary: false,
                children: [
                  Card(
                    elevation: 1,
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
                              image: AssetImage("assets/child_reg.png"),
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

              // child: StreamBuilder<QuerySnapshot>(
              //   stream:
              //       FirebaseFirestore.instance.collection("Babies").snapshots(),
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return Text("Loading");
              //     }
              //     return Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       // ignore: prefer_const_literals_to_create_immutables
              //       children: <Widget>[
              //         Icon(
              //           Icons.payments_outlined,
              //           size: 30,
              //           color: Colors.black,
              //         ),
              //         SizedBox(
              //           width: 20,
              //         ),
              //         DropdownButton(
              //             // ignore: prefer_const_literals_to_create_immutables
              //             items: snapshot.data!.docs
              //                 .map((DocumentSnapshot document) {
              //               return DropdownMenuItem(
              //                 value: document.get("Name"),
              //                 // ignore: unnecessary_string_interpolations
              //                 child: Text('${document.get("Name")}'),
              //                 onTap: () {
              //                   selectedTypeEditingController.text =
              //                       document.get("Name");
              //                 },
              //               );
              //             }).toList(),
              //             onChanged: (catValue) {
              //               setState(() {
              //                 selectedCat = catValue;
              //               });
              //             },
              //             value: selectedCat,
              //             isExpanded: false,
              //             // ignore: unnecessary_new
              //             hint: new Text(
              //               "List of babies",
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 20,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             )),
              //       ],
              //     );
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
