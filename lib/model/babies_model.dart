// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ChildModel {
  String? uid;
  String? name;
  String? dob;
  String? gender;
  String? h8;
  String? w8;
  String? bloodGrp;
  String? birthCertNo;
  String? fathersName;
  String? mothersName;
  String? childsReltn;
  String? guard;
  List? Guardians;

  ChildModel({
    this.uid,
    this.name,
    this.fathersName,
    this.mothersName,
    this.dob,
    this.gender,
    this.h8,
    this.w8,
    this.bloodGrp,
    this.birthCertNo,
    this.childsReltn,
  });

  ///Receiving data from server
  factory ChildModel.fromMap(map) {
    return ChildModel(
      uid: map['uid'],
      name: map['name'],
      dob: map['dob'],
      gender: map['gender'],
      h8: map['height'],
      w8: map['weight'],
      bloodGrp: map['blood_grp'],
      birthCertNo: map['birth_cert_no.'],
      fathersName: map['fathers name'],
      mothersName: map['mothers name'],
      childsReltn: map['childs relation to you'],
    );
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'dob': dob,
      'gender': gender,
      'height': h8,
      'weight': w8,
      'blood_grp': bloodGrp,
      'birth_cert_no': birthCertNo,
      'fathers_name': fathersName,
      'mothers_name': mothersName,
      'childs_rltn': childsReltn,
      'guardian': FieldValue.arrayUnion([
        {
          "uid": uid,
        }
      ]),
    };
  }

  // Map<String, dynamic> guardianItem(String uid) {
  //   return {
  //     'guardian': FieldValue.arrayUnion([
  //       {
  //         "uid": uid,
  //       }
  //     ]),
  //   };
  // }
}
