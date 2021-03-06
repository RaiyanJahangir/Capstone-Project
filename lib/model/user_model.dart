import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? email;
  String? name;
  String? gender;
  int? age;
  String? occupation;
  List? access;
  List? gaccess;
  List? naccess;

  UserModel(
      {this.uid,
      this.email,
      this.name,
      this.gender,
      this.age,
      this.occupation,
      this.gaccess,
      this.naccess
      });


  //receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['Email'],
      name: map['Name'],
      gender: map['Gender'],
      age: map['Age'],
      occupation: map['Occupation'],
      gaccess: map['gaccess'],
      naccess: map['naccess'],
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
