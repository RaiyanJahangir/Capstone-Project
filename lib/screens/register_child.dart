// ignore_for_file: prefer_const_constructors, duplicate_ignore, non_constant_identifier_names

import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/babies_model.dart';
import 'package:email_password_login/screens/user_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:email_password_login/screens/notification_screen.dart';

import '../model/user_model.dart';

class RegisterChild extends StatefulWidget {
  const RegisterChild({Key? key}) : super(key: key);

  @override
  State<RegisterChild> createState() => _RegisterChildState();
}

class _RegisterChildState extends State<RegisterChild> {
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final nameEditingController = TextEditingController();
  final dobEditingController = TextEditingController();
  final genderEditingController = TextEditingController();
  final ageEditingController = TextEditingController();
  final h8EditingController = TextEditingController();
  final w8EditingController = TextEditingController();
  final bldgrpEditingController = TextEditingController();
  final birthCertEditingController = TextEditingController();
  final fathersnameEditingController = TextEditingController();
  final mothersnameEditingController = TextEditingController();
  final relationEditingController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  // initializing some values for image upload
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;

  // ignore: prefer_typing_uninitialized_variables
  var selectTypeGen, selectTypeBld, selectedGenderType, selectBloodType;
  // ignore: prefer_final_fields, unused_field
  List<String> _genderType = <String>[
    'Male',
    'Female',
  ];
  // ignore: prefer_final_fields
  List<String> _bloodType = <String>[
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];
  String? holder_gen;
  String? holder_bldgrp;
  void getDropDownItem() {
    setState(() {
      holder_gen = selectTypeGen;
      holder_bldgrp = selectTypeBld;
    });
  }

  // picking the image

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("No File selected", Duration(milliseconds: 400));
      }
    });
  }

  //uploading the image to firebase cloudstore
  Future uploadImage(File _image, ChildModel childModel) async {
    final imgId = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('${childModel.baby_uid}/images')
        .child("post_$imgId");

    await reference.putFile(_image);
    downloadURL = await reference.getDownloadURL();

    // cloud firestore
    await firebaseFirestore
        .collection("Babies")
        .doc(childModel.baby_uid)
        .collection("images")
        .add({'downloadURL': downloadURL}).whenComplete(
            () => showSnackBar("Image Uploaded", Duration(seconds: 2)));
  }

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

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('dd-MMMM-yyyy');
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
    ///....used intl package for date format &
    ///....used date_time_picker for setting the date of birth of the child
    // ignore: avoid_unnecessary_containers
    final dobField = Container(
      child: DateTimeField(
        autocorrect: false,
        controller: dobEditingController,
        onSaved: (value) {
          dobEditingController.text = value as String;
        },
        textInputAction: TextInputAction.next,
        format: format,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.calendar_today_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: 'Choose Date',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
        ),
        onShowPicker: (context, currentValue) async {
          final date = showDatePicker(
              context: context,
              initialDate: currentValue ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));
          return date;
        },
      ),
    );

    // //gender field
    final genderField = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: DropdownButton(
        borderRadius: BorderRadius.circular(10),
        items: _genderType
            .map((genValue) => DropdownMenuItem(
                  child: Text(
                    genValue,
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  value: genValue,
                  onTap: () {
                    genderEditingController.text = genValue;
                  },
                ))
            .toList(),
        onChanged: (selectedGenderType) {
          setState(() {
            selectTypeGen = selectedGenderType;
          });
        },
        value: selectTypeGen,
        icon: Icon(Icons.arrow_drop_down),
        elevation: 16,
        isExpanded: true,
        hint: Text(
          "Select Gender",
          style: TextStyle(
            color: Colors.blue[400],
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    //age field
    final ageField = TextFormField(
      autocorrect: false,
      controller: ageEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("Age cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Give a valid age");
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

    //height field
    final h8Field = TextFormField(
      autocorrect: false,
      controller: h8EditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("Age cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Give a valid height");
        }
        return null;
      },
      onSaved: (value) {
        h8EditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Height",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            10,
          ))),
    );

    //weight field
    final w8Field = TextFormField(
      autocorrect: false,
      controller: w8EditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{2,}$');
        if (value!.isEmpty) {
          return ("Age cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Give a valid weight");
        }
        return null;
      },
      onSaved: (value) {
        w8EditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Weight",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            10,
          ))),
    );

    // //blood group field
    final bldGrpField = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: DropdownButton(
        borderRadius: BorderRadius.circular(10),
        items: _bloodType
            .map((bloodValue) => DropdownMenuItem(
                  child: Text(
                    bloodValue,
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  value: bloodValue,
                  onTap: () {
                    bldgrpEditingController.text = bloodValue;
                  },
                ))
            .toList(),
        onChanged: (selectBloodType) {
          setState(() {
            selectTypeBld = selectBloodType;
          });
        },
        value: selectTypeBld,
        icon: Icon(Icons.arrow_drop_down),
        elevation: 16,
        isExpanded: true,
        hint: Text(
          "Select Blood Group",
          style: TextStyle(
            color: Colors.blue[400],
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    //child birth_cert field
    final birthCertField = TextFormField(
      autocorrect: false,
      controller: birthCertEditingController,
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
        birthCertEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Birth Certificate No.",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            10,
          ))),
    );

    //child father's name field
    final fatherField = TextFormField(
      autocorrect: false,
      controller: fathersnameEditingController,
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
        fathersnameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Father's Name",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            10,
          ))),
    );

    //child mother's name field
    final motherField = TextFormField(
      autocorrect: false,
      controller: mothersnameEditingController,
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
        mothersnameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Mother's Name",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            10,
          ))),
    );

    //child mother's name field
    final relationField = TextFormField(
      autocorrect: false,
      controller: relationEditingController,
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
        relationEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Baby's Relation to you",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
            10,
          ))),
    );

    //register button
    final registerButton = Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (_image != null) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Confirm Account Registration ?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.blue,
                              fontSize: 25)),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              // signUp(emailEditingController.text,
                              //     passwordEditingController.text);
                              sendData(
                                  nameEditingController.text,
                                  dobEditingController.text,
                                  genderEditingController.text,
                                  h8EditingController.text,
                                  w8EditingController.text,
                                  bldgrpEditingController.text,
                                  fathersnameEditingController.text,
                                  mothersnameEditingController.text,
                                  birthCertEditingController.text,
                                  relationEditingController.text);
                              getDropDownItem();
                            },
                            child: const Text("YES",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blueAccent,
                                    fontSize: 20))),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("NO",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blueAccent,
                                    fontSize: 20)))
                      ],
                    );
                  });
            } else {
              showSnackBar("Select Image first", Duration(milliseconds: 400));
            }
          },
          child: Text(
            "Register",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ));

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
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
                      height: 5,
                    ),
                    nameField,
                    SizedBox(
                      height: 5,
                    ),
                    dobField,
                    SizedBox(
                      height: 5,
                    ),
                    genderField,
                    SizedBox(
                      height: 5,
                    ),
                    ageField,
                    SizedBox(
                      height: 5,
                    ),
                    h8Field,
                    SizedBox(
                      height: 10,
                    ),
                    w8Field,
                    SizedBox(
                      height: 10,
                    ),
                    bldGrpField,
                    SizedBox(
                      height: 10,
                    ),
                    birthCertField,
                    SizedBox(
                      height: 10,
                    ),
                    fatherField,
                    SizedBox(
                      height: 10,
                    ),
                    motherField,
                    SizedBox(
                      height: 10,
                    ),
                    relationField,
                    SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: Column(children: [
                              const Text("Upload Image"),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  width: 310,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    border:
                                        Border.all(color: Colors.blueAccent),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // the image that we wanted to upload
                                        Expanded(
                                            child: _image == null
                                                ? const Center(
                                                    child: Text(
                                                        "No image selected"))
                                                : Image.file(_image!)),
                                        ElevatedButton(
                                            onPressed: () {
                                              imagePickerMethod();
                                            },
                                            child: const Text("Select Image")),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ]))),
                    SizedBox(
                      height: 10,
                    ),
                    registerButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendData(
      String name,
      String dob,
      String gender,
      String h8,
      String w8,
      String bldgrp,
      String fathersname,
      String mothersname,
      String birthCertNo,
      String childsRltn) async {
    User? user = auth.currentUser;

    //ChildModel? babies = auth.currentUser;
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Babies').doc();
    String? docId = documentReference.id;

    final QuerySnapshot qSnap =
        await FirebaseFirestore.instance.collection('Babies').get();
    final int a = qSnap.docs.length;
    String d = a.toString();
    String baby_uid = "baby" + d;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    UserModel userModel = UserModel();
    ChildModel childModel = ChildModel();
    childModel.uid = user!.uid;
    childModel.name = nameEditingController.text;
    childModel.dob = dobEditingController.text;
    childModel.gender = genderEditingController.text;
    childModel.h8 = h8EditingController.text;
    childModel.w8 = w8EditingController.text;
    childModel.bloodGrp = bldgrpEditingController.text;
    childModel.birthCertNo = birthCertEditingController.text;
    childModel.fathersName = fathersnameEditingController.text;
    childModel.mothersName = mothersnameEditingController.text;
    childModel.childsReltn = relationEditingController.text;
    childModel.baby_uid = baby_uid;
    childModel.age = ageEditingController.text;

    userModel.gaccess?.add(baby_uid);

    await firebaseFirestore
        .collection("Babies")
        .doc(baby_uid)
        .set(childModel.toMap());
    ////await uid = users model<-doc users->collec access array add "baby" + d
    Fluttertoast.showToast(msg: "Baby Registered");

    await firebaseFirestore
        .collection("Users")
        .doc(user.uid)
        .update(userModel.updateBabyuid(baby_uid));

    uploadImage(_image!, childModel);

    final databaseRef =
        FirebaseDatabase.instance.reference().child("${baby_uid}/Sensor Data");
    databaseRef.set({
      "Cry": "NO",
      "Pulse Rate": 72,
      "Temperature": 29.0,
      "Latitude": 2383765,
      "Longitude": 9035776,
      "Timestamp": DateTime.now().toString().substring(0, 19)
    });
    final PrevdatabaseRef = FirebaseDatabase.instance
        .reference()
        .child("${baby_uid}/Previous Sensor Data");
    PrevdatabaseRef.set({
      "Cry": "NO",
      "Pulse Rate": 72,
      "Temperature": 29.0,
      "Latitude": 2383765,
      "Longitude": 9035776,
      "Timestamp": DateTime.now().toString().substring(0, 19)
    });

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => UserHome()));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
