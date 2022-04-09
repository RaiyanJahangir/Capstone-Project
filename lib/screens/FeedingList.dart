import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:flutter/src/widgets/framework.dart';

class FeedingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'avenir'),
      home: feedingList(),
    );
  }
}

class feedingList extends StatefulWidget {
  @override
  _newTaskState createState() => _newTaskState();
}

class _newTaskState extends State<feedingList> {
  // CollectionReference users = FirebaseFirestore.instance.collection("users");
  TextEditingController name = new TextEditingController();
  TextEditingController date = new TextEditingController();
  TextEditingController reason = new TextEditingController();

  List<int> selectedList = [];
  List<int> medselectedList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xfff90CAF9),
        elevation: 0,
        title: Text(
          "Feeding Details",
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
                          "Feeding Time",
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
                            hintText: "Time"),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Which food was provided :",
                      style: TextStyle(fontSize: 18),
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Rice",
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
                        "Milk",
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
                        "Meat",
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
                    CheckboxListTile(
                      title: Text(
                        "Vegetables",
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            selectedList.add(4);
                          } else {
                            selectedList.remove(4);
                          }
                        });
                      },
                      value: selectedList.contains(4),
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Others",
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            selectedList.add(5);
                          } else {
                            selectedList.remove(5);
                          }
                        });
                      },
                      value: selectedList.contains(5),
                    ),
                    Text(
                      "Any Medication ?",
                      style: TextStyle(fontSize: 18),
                    ),
                    CheckboxListTile(
                      title: Text(
                        "Yes",
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
                      value: medselectedList.contains(1),
                    ),
                    CheckboxListTile(
                      title: Text(
                        "No",
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
                      value: medselectedList.contains(2),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              child: FlatButton(
                                child: const Text(
                                  'Submit!!',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                onPressed: () {
                                  /*Map<String, dynamic> data = {
                                    "Vaccine Name": name.text,
                                    "Vaccination Date": date.text,
                                    "Vaccination for": reason.text,
                                  };
                                  FirebaseFirestore.instance
                                      .collection("vaccine")
                                      .add(data);
                                  ;*/
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
  }
}
