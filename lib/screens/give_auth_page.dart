import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/notification_screen.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_password_login/model/babies_model.dart';
import 'package:fluttertoast/fluttertoast.dart';


class auth extends StatefulWidget {
  final String text;
  const auth(@required this.text , {Key? key}) : super(key: key);

  @override
  State<auth> createState() => _authState();
}

class _authState extends State<auth> {
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
    FirebaseFirestore.instance
        .collection("Babies")
        .doc(widget.text)
        .get()
        .then((value) {
      // ignore: unnecessary_this
      this.loggedInBaby = ChildModel.fromMap(value.data());
      setState(() {
        Access=loggedInBaby.req;
        if (Access!.isNotEmpty) {
          itemCount = Access!.length;
        }
      });
    });
    print(Access);
  }


  String? _email;
  String? _box = 'Guardian';

  final auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final authas = TextEditingController();
  List items=['Guardian','Nurturer'];


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
              Expanded(child: Text('Give Authorization')),
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
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Text("Authorize Permission",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                                color: Colors.lightBlueAccent,
                                offset: Offset(2, 1),
                                blurRadius: 10)
                          ])),
                ),
                Expanded(
                  flex: 6,
                  child: (itemCount > 0)
                      ? RefreshIndicator(
                    onRefresh: refresh,
                        child: ListView.builder(
                        itemCount: Access!.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return Card(
                            color: Colors.blue[50],
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                        child: Text(Access![index])
                                    )
                                ),
                                Expanded(
                                  flex: 1,
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10))),
                                        child: const Text(
                                          'Guardian',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        onPressed: () async {
                                          print(Access![index]);
                                          final snapshot = await FirebaseFirestore.instance
                                              .collection('Users')
                                              .where('Email', isEqualTo: Access![index])
                                              .get().catchError((error) {
                                            Fluttertoast.showToast(msg: error!.message);
                                            print("Something went wrong: ${error.message}");
                                          });
                                          String euid=snapshot.docs.first['uid'].toString();
                                          print(euid);
                                          await FirebaseFirestore.instance.collection('Users').doc(euid).update({"gaccess": FieldValue.arrayUnion([widget.text])});
                                          await FirebaseFirestore.instance.collection('Babies').doc(widget.text).update({"guardian": FieldValue.arrayUnion([euid])});
                                          await FirebaseFirestore.instance.collection('Babies').doc(widget.text).update({"req": FieldValue.arrayRemove([Access![index]])});
                                          await refresh();
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            duration: const Duration(seconds: 2),
                                            content: Text('Authorized as Guardian'),
                                          ),);
                                        },
                                      ),
                                    ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10))),
                                      child: const Text(
                                        'Nurturer',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      onPressed: () async {
                                        print(Access![index]);
                                        final snapshot = await FirebaseFirestore.instance
                                            .collection('Users')
                                            .where('Email', isEqualTo: Access![index])
                                            .get().catchError((error) {
                                          Fluttertoast.showToast(msg: error!.message);
                                          print("Something went wrong: ${error.message}");
                                        });
                                        String euid=snapshot.docs.first['uid'].toString();
                                        print(euid);
                                        await FirebaseFirestore.instance.collection('Users').doc(euid).update({"naccess": FieldValue.arrayUnion([widget.text])});
                                        await FirebaseFirestore.instance.collection('Babies').doc(widget.text).update({"nurturer": FieldValue.arrayUnion([euid])});
                                        await FirebaseFirestore.instance.collection('Babies').doc(widget.text).update({"req": FieldValue.arrayRemove([Access![index]])});
                                        await refresh();
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          duration: const Duration(seconds: 2),
                                          content: Text('Authorized as Nurturer'),
                                        ),);
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10))),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance.collection('Babies').doc(widget.text).update({"req": FieldValue.arrayRemove([Access![index]])});
                                        await refresh();
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          duration: const Duration(seconds: 2),
                                          content: Text('Request Canceled'),
                                        ),);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          );
                        }
                  ),
                      )
                      : Center(child: const Text('No request')),
                ),
              ],
            ),
      ),
    );
  }

  Future<void> sendData(String email,String authp) async {
    String euid;
    bool err=true;
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: email)
        .get().catchError((error) {
      Fluttertoast.showToast(msg: error!.message);
      print("Something went wrong: ${error.message}");
      err=false;
    });
    euid=snapshot.docs.first['uid'].toString();
    print('uid '+ euid);
    if(err == false ){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(' This email doesn\'t exist... '),
      ),);
    }
    else if(authp=='Guardian'){
        await FirebaseFirestore.instance.collection('Users').doc(euid).update({"gaccess": FieldValue.arrayUnion([widget.text])});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 2),
          content: Text('Authorized as Guardian'),
        ),);
        Navigator.pop(context,true);
      }
      else if(authp=='Nurturer'){
        await FirebaseFirestore.instance.collection('Users').doc(euid).update({"naccess": FieldValue.arrayUnion([widget.text])});
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 2),
          content: Text('Authorized as Nurturer'),
        ),);
        Navigator.pop(context,true);
      }
      print(widget.text);
      print(authp);
    }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  Future refresh() async{
    setState(() {
      FirebaseFirestore.instance
          .collection("Babies")
          .doc(widget.text)
          .get()
          .then((value) {
        this.loggedInBaby = ChildModel.fromMap(value.data());
        setState(() {
          Access=loggedInBaby.req;
          if (Access!.isNotEmpty) {
            itemCount = Access!.length;
          }
        });
      });
    });
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
