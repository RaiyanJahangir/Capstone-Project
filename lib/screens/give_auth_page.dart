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
  var data;

  Widget _authlist() {
    return DropdownButton<String>(
      value: _box,
      icon: Icon(
        Icons.arrow_downward,
        color: Colors.grey.shade900,
      ),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.grey.shade900),
      onChanged: (newValue) {
        setState(() {
          _box = newValue!;
          authas.text = newValue;
        });
      },
      items: <String>['Guardian', 'Nurturer']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildemail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email Address'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      controller: emailEditingController,
      onSaved: (value) {
        _email = value;
        emailEditingController.text = value!;
      },
    );
  }

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
                  flex: 5,
                  child: (itemCount > 0)
                      ? ListView(
                    children: Access!.map((strone) {
                      return Container(
                        child: InkWell(
                          onTap: () {
                            //print('hei');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Text(
                            strone,
                          ),
                          Spacer(),
                          RawMaterialButton(
                            onPressed: () {},
                            //elevation: 1.0,
                            fillColor: Colors.green,
                            child: Icon(
                              Icons.check,
                              size: 25.0,
                             ),
                              padding: EdgeInsets.all(0),
                              shape: CircleBorder(),
                              ),
                              RawMaterialButton(
                            onPressed: () {},
                            //elevation: 2.0,
                            fillColor: Colors.red,
                            child: Icon(
                              Icons.cancel_outlined,
                              size: 25.0,
                              color: Colors.white,
                             ),
                              padding: EdgeInsets.all(0),
                              shape: CircleBorder(),
                              )
                            ],
                          )
                        ),
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.all(15),
                        color: Colors.blue[100],
                      );
                    }).toList(),
                  )
                      : Center(child: const Text('Don\'t have any child')),
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
}
