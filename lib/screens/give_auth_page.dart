import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum user { guardian , nurturer }
String? myEmail;
String? myName;
class auth extends StatefulWidget {
  const auth({Key? key}) : super(key: key);

  @override
  State<auth> createState() => _authState();
}

class _authState extends State<auth> {
  user? _site = user.guardian;
  String? _name;
  String? _email;
  String? _box = 'Child1';
  String? _relation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<bool?> toast(String message) {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 15.0);
  }
  Widget _buildname() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'UserName'),
      maxLength: 30,
      validator: (value){
        if(value!.isEmpty)return 'Required';
        return null;
      },
      onSaved: (value){
        _name=value;
      },
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
      onSaved: (value) {
        _email = value;
      },
    );
  }
  Widget _buildbox() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Guardian'),
          leading: Radio(
            value: user.guardian,
            groupValue: _site,
            onChanged: (value) {
              setState(() {
                _site = value as user?;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Nurturer'),
          leading: Radio(
            value: user.nurturer,
            groupValue: _site,
            onChanged: (value) {
              setState(() {
                _site = value as user?;
              });
            },
          ),
        ),
      ],
    );
  }
  Widget _buildlist() {
    return DropdownButton<String>(
      value: _box,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (newValue) {
        setState(() {
          _box = newValue!;
        });
      },
      items: <String>['Child1', 'Child2', 'Child3', 'Child4']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
  Widget _builduser() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Child Relation to the User'),
      maxLength: 30,
      validator: (value){
        if(value!.isEmpty)return 'Required';
        return null;
      },
      onSaved: (value){
        _relation=(value as String?)!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Authorization');
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.circle_notifications,
                color: Colors.white,
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              FutureBuilder(
                future: _fetch(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Text("Loading data...Please wait");
                  return Text("$myEmail");
                },
              ),
              Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
              )
            ]
        ),
        //backgroundColor: Color.fromRGBO(232, 232, 242, 1),
      ),
        //resizeToAvoidBottomInset: false,
        body: Container(
        margin: EdgeInsets.all(24),
        child: SingleChildScrollView(
          reverse: true,
          padding: EdgeInsets.all(32),
          child: Column(
              children: [
                Text(
                  "Authorize Permission",
                  textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.red[400],
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(color: Colors.blueAccent, offset: Offset(2,1), blurRadius:10)
                    ]
                )
                ),
                SizedBox(height: 50,),
                Form(
                  key: _formKey,
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildname(),
                      SizedBox(height: 10,),
                      _buildemail(),
                      SizedBox(height: 20),
                      Text('Give permission as: ',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                        ),
                          ),
                      _buildbox(),
                      Text('Give permission on: ',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      _buildlist(),
                      SizedBox(height: 10,),
                      _builduser(),
                      SizedBox(height: 10,),
                      RaisedButton(
                        child: Text(
                          'Submit',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {return;}
                          else {
                            _formKey.currentState!.save();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sending Data to the Cloud Firestore')));
                            await users.add({'user-name': _name,'email': _email , 'permission-type' : _relation, 'permission-on': _box, 'relation': _relation, }).
                            then((value) => toast("Authorization Successful")).catchError((error)=> toast("Failed to Authorize"));
                            Navigator.pop(context);
                          }
                          print(_site);
                          print(_name);
                          print(_email);
                          print(_box);
                          print(_relation);
                        },
                      )
                    ],
                  )
                )
              ],
            ),
        ),
        ),
    );
  }
  _fetch() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser!;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        myEmail = ds.data()!['Email'];
        myName = ds.data()!['Name'];
        print(myEmail);
      }).catchError((e) {
        print(e);
      });
    }
  }
}
