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
      appBar: AppBar(
        centerTitle: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Text('Request for Authorization')),
              IconButton(
                icon: Icon(
                  Icons.circle_notifications,
                  color: Colors.white,
                  size: 24.0,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) => NotificationScreen()));
                },
              ),
            ]),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  //var a;
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.blue,
                    size: 24.0,
                  ),
                  //title: const Text(size ?? ''),
                  title: Text(
                    "User Profile",
                  ),
                  subtitle: Text(
                    "${loggedInUser.name}",
                  ),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (c) => Home())),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.blue,
                  ),
                  title: Text('Logout'),
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Confirm Logging Out ?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.blue,
                                  fontSize: 25)),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  logout(context);
                                },
                                child: Text("YES",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.blueAccent,
                                        fontSize: 20))),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("NO",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.blueAccent,
                                        fontSize: 20)))
                          ],
                        );
                      }),
                ),
              ),
            ],
          ),
        ],
        //backgroundColor: Color.fromRGBO(232, 232, 242, 1),
      ),
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
              (data['req']!=null) ? print(data['req']!.where((item) => item == loggedInUser.email)) : print('yo');
              //(data['req']!=null) ? print(data['req'].contain('m@g.com')) : print('yo');
              return ListTile(
                title: Text(data['name'] ?? ''),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child:
                  //     data['req']!=null ?
                  // data['req']!.where((item) => item == loggedInUser.email)!= '(m@g.com)' ?
                      Text(
                        'Request',
                        style: TextStyle(fontSize: 12),
                      ),
                           // : Text('Requested') : Text('null'),
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('Babies').doc(data['baby_uid']).update({"req": FieldValue.arrayUnion([loggedInUser.email])});
                    //await refresh();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 2),
                      content: Text('Request Placed'),
                    ),);
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
