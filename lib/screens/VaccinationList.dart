import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_sorted_list.dart';
import 'package:flutter/material.dart';

import 'package:email_password_login/screens/HomePage.dart';

class NewTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'avenir'),
      home: newTask(),
    );
  }
}

class newTask extends StatefulWidget {
  @override
  _newTaskState createState() => _newTaskState();
}

class _newTaskState extends State<newTask> {
  CollectionReference users = FirebaseFirestore.instance.collection("vaccines");
  TextEditingController name = new TextEditingController();
  TextEditingController date = new TextEditingController();
  TextEditingController reason = new TextEditingController();

  bool first = false;
  bool second = false;
  bool third = false;

  List<int> selectedList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xfff90CAF9),
        elevation: 0,
        title: Text(
          "Vaccination Details",
          style: TextStyle(fontSize: 25),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              height: 30,
              color: Color(0xfff90CAF9),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: Colors.white),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.85,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Name of the Vaccine",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      //color: Colors.blue.withOpacity(0.2),
                      child: TextField(
                        controller: name,
                        decoration: InputDecoration(
                            fillColor: Colors.blue.withOpacity(0.2),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              //borderSide: BorderSide(color: Color.blue ,width: 5.0),
                            ),
                            hintText: "Vaccine Name"),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Vaccination Date :",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      //color: Colors.blue.withOpacity(0.2),
                      child: TextField(
                        controller: date,
                        decoration: InputDecoration(
                            fillColor: Colors.blue.withOpacity(0.2),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: "Due Date"),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Number of Dose :",
                      style: TextStyle(fontSize: 18),
                    ),

                    // ListView(
                    //   children: [
                    //     buildC
                    //   ],
                    // )

                    CheckboxListTile(
                      title: Text(
                        "First Dose",
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            selectedList.add(1);
                          } else {
                            selectedList.remove(1);
                          }
                        });
                      },
                      value: selectedList.contains(1),
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Second Dose",
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            selectedList.add(2);
                          } else {
                            selectedList.remove(2);
                          }
                        });
                      },
                      value: selectedList.contains(2),
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Third Dose",
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            selectedList.add(3);
                          } else {
                            selectedList.remove(3);
                          }
                        });
                      },
                      value: selectedList.contains(3),
                    ),

                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About the Vaccine :",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 80,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15)),
                                border: Border.all(
                                    color: Colors.blue.withOpacity(0.5))),
                            child: TextField(
                              controller: reason,
                              maxLines: 2,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: " Add description about vaccine",
                              ),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)),
                                border: Border.all(
                                    color: Colors.blue.withOpacity(0.5))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    //child: IconButton(

                                    //icon: Icon(
                                    //  Icons.attach_file,
                                    //  color: Colors.blue,

                                    // ),
                                    //),
                                    )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                color: Color(0xffff90CAF9)),
                            child: Center(
                              child: TextButton(
                                child: const Text(
                                  'Submit!!',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                onPressed: () {
                                  Map<String, dynamic> data = {
                                    "name": name.text,
                                    "date": date.text,
                                    "reason": reason.text,
                                  };
                                  FirebaseFirestore.instance
                                      .collection("vaccines")
                                      .add(data);

                                  print('hello');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                },
                              ),
                              //child: Text(
                              //"Submit",
                              //style:
                              // TextStyle(color: Colors.white, fontSize: 18),
                              //),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );

    // Widget buildCheckbox()=>Checkbox(
    //   value: value,
    //   onChanged: (value){
    //     this.value=value;

    //   },
    //   );
  }
}
