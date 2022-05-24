// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ChildModel {
  // DocumentReference documentReference =
  //     FirebaseFirestore.instance.collection('Babies').doc();
  String? uid;
  String? name;
  String? dob;
  String? gender;
  String? age;
  String? h8;
  String? w8;
  String? bloodGrp;
  String? birthCertNo;
  String? fathersName;
  String? mothersName;
  String? childsReltn;
  String? guard;
  String? baby_uid;
  List? guardian;
  List? nurturer;
  List? req;
  List? newvaccineuid;
  List? newfeedinguid;


  ChildModel(
      {this.uid,
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
      this.baby_uid,
      this.age,
      this.guardian,
      this.nurturer,
      this.req,
      this.newvaccineuid,
      this.newfeedinguid});


  ///Receiving data from server
  factory ChildModel.fromMap(map) {
    return ChildModel(
        //uid: map['baby_uid'],
        name: map['name'],
        dob: map['dob'],
        gender: map['gender'],
        age: map['age'],
        h8: map['height'],
        w8: map['weight'],
        bloodGrp: map['blood_grp'],
        birthCertNo: map['birth_cert_no'],
        fathersName: map['fathers_name'],
        mothersName: map['mothers_name'],
        childsReltn: map['childs_relation_to_you'],
        baby_uid: map['baby_uid'],
        guardian: map['guardian'],
        nurturer: map['nurturer'],
        req: map['req'],
        newvaccineuid: map['vaccinelist'],
        newfeedinguid: map['feedinglist']);
  }

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'baby_uid': baby_uid,
      'name': name,
      'dob': dob,
      'gender': gender,
      'age': age,
      'height': h8,
      'weight': w8,
      'blood_grp': bloodGrp,
      'birth_cert_no': birthCertNo,
      'fathers_name': fathersName,
      'mothers_name': mothersName,
      'childs_rltn': childsReltn,
      'guardian': FieldValue.arrayUnion([
        uid,
      ]),
      'nurturer': FieldValue.arrayUnion([]),
      'vaccinelist': FieldValue.arrayUnion([]),
      'feedinglist': FieldValue.arrayUnion([])
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
  Map<String, dynamic> addnewvaccineuid(String newvaccineuid) {
    return {
      'vaccinelist': FieldValue.arrayUnion([
        newvaccineuid,
      ]),
    };
  }

  Map<String, dynamic> addnewfeedinguid(String newfeedinguid) {
    return {
      'feedinglist': FieldValue.arrayUnion([
        newfeedinguid,
      ]),
    };
  }
}
