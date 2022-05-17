import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? name;
  String? gender;
  int? age;
  String? occupation;
  String? gaccess;

  ///for authentication
  String? auth_name;
  String? auth_email;
  String? auth_child;
  String? auth_relation;
  List? Babies;

  UserModel(
      {this.uid,
      this.email,
      this.name,
      this.gender,
      this.age,
      this.occupation,
      this.gaccess});

  //receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['Email'],
      name: map['Name'],
      gender: map['Gender'],
      age: map['Age'],
      occupation: map['Occupation'],
      //gaccess: map['Gaccess'],
    );
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'Email': email,
      'Name': name,
      'Gender': gender,
      'Age': age,
      'Occupation': occupation,
      'Gaccess': FieldValue.arrayUnion([
        gaccess,
      ]),
    };
  }

  Map<String, dynamic> updateBabyuid(String gaccess) {
    return {
      'gaccess': FieldValue.arrayUnion([
        gaccess,
      ]),
    };
  }
}
