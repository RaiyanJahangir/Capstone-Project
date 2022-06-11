import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/notification_screen.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_password_login/model/babies_model.dart';
import 'package:fluttertoast/fluttertoast.dart';


class reqauth extends StatefulWidget {
  const reqauth( {Key? key}) : super(key: key);

  @override
  State<reqauth> createState() => _reqauthState();
}

class _reqauthState extends State<reqauth> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  ChildModel loggedInBaby= ChildModel();
  List? Access;
  int itemCount = 0;

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


  String? _email;
  String? _box = 'Guardian';

  final auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final authas = TextEditingController();
  List items=['Guardian','Nurturer'];
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Babies').snapshots();

  @override
  Widget build(BuildContext context) {
    var wo = MediaQuery.of(context).size.width;
    var wh = MediaQuery.of(context).size.height;
    CollectionReference users =
    FirebaseFirestore.instance.collection('Authorization');
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              List reqname=data['req'];
              //print(reqname);
              bool req=false;
              //print(loggedInUser.email);
              Iterable i= reqname.where((name)=>name.contains(loggedInUser.email.toString())).toList();
              //print(i);
              //print(i.toString()=='['+ loggedInUser.email.toString() +']');
              req=i.toString()=='['+ loggedInUser.email.toString() +']';
              reqname=data['guardian'];
              print(reqname);
              bool g=false;
              print(loggedInUser.uid);
              i= reqname.where((name)=>name.contains(loggedInUser.uid.toString())).toList();
              print(i);
              print(i.toString()=='['+ loggedInUser.uid.toString() +']');
              g=i.toString()=='['+ loggedInUser.uid.toString() +']';
              reqname=data['nurturer'];
              print(reqname);
              bool n=false;
              print(loggedInUser.uid);
              i= reqname.where((name)=>name.contains(loggedInUser.uid.toString())).toList();
              print(i);
              print(i.toString()=='['+ loggedInUser.uid.toString() +']');
              n=i.toString()=='['+ loggedInUser.uid.toString() +']';
              //print();
              return ListTile(
                title: Text(data['name'] ?? ''),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: (g==true || n==true) ? Colors.red[300] : req==false ? Colors.blue : Colors.blueGrey[300],
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))
                  ),
                  child:
                  //     data['req']!=null ?
                  // data['req']!.where((item) => item == loggedInUser.email)!= '(m@g.com)' ?
                  (g==true || n==true) ? Text(
                        'Assigned',
                        style: TextStyle(
                            fontSize: 12,
                        ),
                      ) : req==false ? Text(
                      'Request',
                      style: TextStyle(fontSize: 12),
                    ) : Text(
                    'Requested',
                    style: TextStyle(fontSize: 12),
                  ),
                           // : Text('Requested') : Text('null'),
                  onPressed: () async {
                    if(req==false && g==false && n==false){
                      await FirebaseFirestore.instance.collection('Babies').doc(data['baby_uid']).update({"req": FieldValue.arrayUnion([loggedInUser.email])});
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text('Request Placed'),
                      ),);
                    }
                  },
                ),
                //subtitle: Text(data['company']),
                onTap: null,
              );
            }).toList(),
          );
        },
      )
    );
  }


  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

List<DropdownMenuItem<String>> _dropDownItem() {
  List<String> ddl = ["Guardian", "Nurturer"];
  return ddl
      .map((value) => DropdownMenuItem(
    value: value,
    child: Text(value),
  ))
      .toList();
}
