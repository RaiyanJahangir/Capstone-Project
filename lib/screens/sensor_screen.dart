import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
//import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
//import 'package:email_password_login/model/sensor_model.dart';
//import 'package:email_password_login/model/sensor_data_dao.dart';
//import 'package:firebase_database/ui/firebase_animated_list.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({Key? key}) : super(key: key);
  //SensorScreen({this.app});
  //final FirebaseApp app;

  @override
  SensorScreenState createState() => SensorScreenState();
}

class SensorScreenState extends State<SensorScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final textcontroller = TextEditingController();
  final Future<FirebaseApp> _future = Firebase.initializeApp();
  final databaseRef =
      FirebaseDatabase.instance.reference().child("Sensor Data");
  final databaseRef2 =
      FirebaseDatabase.instance.reference().child("Temperature");
  // DatabaseReference ref1 =
  //     FirebaseDatabase.instance.reference().child("Pulse Rate");
  // DatabaseReference ref2 =
  //     FirebaseDatabase.instance.reference().child("Temperature");

//  ref1.onValue.listen((DatabaseEvent event ){
//     final data=event.snapshot.value;
//     updateStarCount(data);
//   });
//DataSnapshot event=await  ref1.once();

  void addData(String data) {
    //databaseRef.push().set({'name': data, 'comment': 'a good season'});
    //databaseRef.push().set({'Pulse Rate': 140});
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  // void printFirebase() {
  //   databaseRef.child('Pulse Rate').once().then((DataSnapshot snapshot) {
  //     print('Data : ${snapshot.value}');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            //passing this to a loop
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        title: Text("Sensor Page"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FirebaseAnimatedList(
          query: databaseRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            //var x = snapshot.value["Pulse Rate"];
            return ListTile(
              title: Text('${snapshot.value}'),
              //subtitle: Text(snapshot.value['Temperature']['Data']),
            );
          },
        ),
      ),
      // body: FutureBuilder(
      //     future: _future,
      //     builder: (context, snapshot) {
      //       if (snapshot.hasError) {
      //         return Text(snapshot.error.toString());
      //       } else {
      //         return Container(
      //           child: Column(
      //             children: <Widget>[
      //               SizedBox(height: 250.0),
      //               Padding(
      //                 padding: EdgeInsets.all(10.0),
      //                 child: TextField(),
      //               ),
      //               SizedBox(height: 30.0),
      //               Center(
      //                 child: ElevatedButton(
      //                   //color: Colors.pinkAccent,
      //                   child: Text("Save to Database"),
      //                   onPressed: () {
      //                     addData(textcontroller.text);
      //                     printFirebase();
      //                   },
      //                 ),
      //               )
      //             ],
      //           ),
      //         );
      //       }
      //     }),
    );

    // body: Container(
    //   child: Column(
    //     children: <Widget>[
    //       Padding(
    //         padding: const EdgeInsets.all(10.0),
    //         child: Text(
    //           'Name',
    //           style: TextStyle(
    //               fontSize: 20,
    //               fontWeight: FontWeight.bold,
    //               shadows: [
    //                 Shadow(
    //                   blurRadius: 10,
    //                   color: Colors.blue,
    //                 )
    //               ]),
    //         ),
    //       ),
    //       // Flexible(child: TextField(
    //       //   onChanged: (val){
    //       //     setState(() {
    //       //       pulse=val;
    //       //     });
    //       //   },
    //       // )),
    //       // ElevatedButton(
    //       //   onPressed:(){
    //       //     dref1.set(pulse);
    //       //   },
    //       //   child:Text("Registration"),
    //       //    ),
    //       ElevatedButton(
    //         onPressed: () {
    //           dref1.once().then((event) {
    //             final datasnapshot = event.snapshot;
    //             if (datasnapshot.value != null) {
    //               pulseData = pulse.fromSnapshot(datasnapshot);
    //             }
    //           });
    //         },
    //         child: Text("Retrieve data"),
    //       ),
    //       Text(pulse),
    //     ],
    //   ),
    // ),
    //);
  }
  //  Center(
  //   child: Padding(
  //       padding: EdgeInsets.all(20),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: <Widget>[
  //           SizedBox(
  //             height: 100,
  //             child: Image.asset(
  //               "assets/baby_picture.png",
  //               fit: BoxFit.contain,
  //             ),
  //           ),
  //           Text(
  //             "Welcome Back",
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 10),
  //           Text(
  //             "${loggedInUser.name}",
  //             style: TextStyle(
  //                 color: Colors.black54, fontWeight: FontWeight.w500),
  //           ),
  //           Text(
  //             "${loggedInUser.email}",
  //             style: TextStyle(
  //                 color: Colors.black54, fontWeight: FontWeight.w500),
  //           ),
  //           SizedBox(height: 15),
  //           ActionChip(
  //               label: Text("Logout"),
  //               onPressed: () {
  //                 logout(context);
  //               }),
  //           SizedBox(height: 15),
  //           // ActionChip(label: Text("Sensor Data"),
  //           // onPressed:(){
  //           //   Navigator.push(
  //           //                   context,
  //           //                   MaterialPageRoute(
  //           //                       builder: (context) =>
  //           //                           ));
  //           // }
  //           // ),
  //         ],
  //       )),
  // ),

  // Widget _getMessageList() {
  //   return Expanded(
  //     child: FirebaseAnimatedList(
  //       controller: _scrollController,
  //       query: widget.sensor.getMessageQuery(),
  //       itemBuilder: (context, snapshot, animation, index) {
  //         final json = snapshot.value as Map<dynamic, dynamic>;
  //         final message = Message.fromJson(json);
  //         return MessageWidget(message.text, message.date);
  //       },
  //     ),
  //   );
  // }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
