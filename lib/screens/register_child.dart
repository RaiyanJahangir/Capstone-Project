// ignore_for_file: prefer_const_constructors

import 'package:email_password_login/screens/home_page.dart';
import 'package:flutter/material.dart';

class RegisterChild extends StatefulWidget {
  const RegisterChild({Key? key}) : super(key: key);

  @override
  State<RegisterChild> createState() => _RegisterChildState();
}

class _RegisterChildState extends State<RegisterChild> {
  final _formKey = GlobalKey<FormState>();
  final nameEditingController = TextEditingController();
  final dobEditingController = TextEditingController();
  final h8EditingController = TextEditingController();
  final w8EditingController = TextEditingController();
  final fathersnameEditingController = TextEditingController();
  final mothersnameEditingController = TextEditingController();
  final relationEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //child name field
    final nameField = TextFormField(
      autocorrect: false,
      controller: nameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Name (Min 3 character");
        }
        return null;
      },
      onSaved: (value) {
        nameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Name",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            10,
          ))),
    );

    //DOB field

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
                builder: (ctx) => const HomePage(),
              ),
            );
            //Navigator.pop(context);
          },
        ),
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            // ignore: prefer_const_constructors

            // ignore: prefer_const_constructors
            Expanded(
              // ignore: prefer_const_constructors
              child: Icon(
                Icons.circle_notifications,
                color: Colors.white,
                size: 24.0,
              ),
            ),
            // ignore: prefer_const_constructors
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
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: Image.asset(
                      "assets/baby_picture.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  nameField,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
