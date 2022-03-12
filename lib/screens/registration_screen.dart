import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  //our form key
  final _formKey = GlobalKey<FormState>();
  //editing controller
  final nameEditingController = TextEditingController();
  final genderEditingController = TextEditingController();
  final ageEditingController = TextEditingController();
  final occupationEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //first name field
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

    //gender field
    final genderField = TextFormField(
      autocorrect: false,
      controller: genderEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        //RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Gender cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        genderEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Gender",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            10,
          ))),
    );

    //age field
    final ageField = TextFormField(
      autocorrect: false,
      controller: ageEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        //RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Age cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        ageEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Age",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            10,
          ))),
    );

    //occupation field
    final occupationField = TextFormField(
      autocorrect: false,
      controller: occupationEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        //RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Occupation cannot be Empty");
        }
        return null;
      },
      onSaved: (value) {
        ageEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Occupation",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            10,
          ))),
    );

    //email field
    final emailField = TextFormField(
      autocorrect: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            10,
          ))),
    );

    //password field
    final passwordField = TextFormField(
      autocorrect: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min 6 character");
        }
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            10,
          ))),
    );

    //confirm password field
    final confirmPasswordField = TextFormField(
      autocorrect: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (confirmPasswordEditingController.text !=
            passwordEditingController.text) {
          return "Password don't match";
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            10,
          ))),
    );

    //signup button
    final signUpButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: Text(
            "SignUp",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () {
              //passing this to a loop
              Navigator.of(context).pop();
            },
          )),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 200,
                              child: Image.asset(
                                "assets/baby_picture.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 15),
                            nameField,
                            SizedBox(height: 20),
                            genderField,
                            SizedBox(height: 20),
                            ageField,
                            SizedBox(height: 20),
                            occupationField,
                            SizedBox(height: 20),
                            emailField,
                            SizedBox(height: 20),
                            passwordField,
                            SizedBox(height: 20),
                            confirmPasswordField,
                            SizedBox(height: 20),
                            signUpButton,
                            SizedBox(height: 10),
                          ])))),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    //calling our firestore
    //calling our user model
    //calling these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    //writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = nameEditingController.text;
    userModel.gender = genderEditingController.text;
    userModel.age = int.parse(ageEditingController.text);
    userModel.occupation = occupationEditingController.text;

    await firebaseFirestore
        .collection("Users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
}
