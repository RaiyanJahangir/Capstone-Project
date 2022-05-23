import 'package:cloud_firestore/cloud_firestore.dart';

class VaccineModel {
  String? uid;
  String? vaccinename;
  String? vaccinereason;
  String? vaccinedate;
  String? vaccine2nddate;
  String? vaccine3rddate;

  List? array;

  VaccineModel({
    this.uid,
    this.vaccinename,
    this.vaccinereason,
    this.vaccinedate,
    this.vaccine2nddate,
    this.vaccine3rddate,
    this.array,
  });

  //receiving data from server
  factory VaccineModel.fromMap(map) {
    return VaccineModel(
      uid: map['uid'],
      vaccinename: map['Vaccine_Name'],
      vaccinereason: map['Vaccine_Reason'],
      vaccinedate: map['Vaccine_Date'],
      vaccine2nddate: map['Vaccine_2nd Date'],
      vaccine3rddate: map['Vaccine_3rd Date'],
    );
  }

  // Map<String, dynamic> toJson() => {
  //
  //       'uid': uid,
  //       'name': vaccinename,
  //       'reason': vaccinereason,
  //       'date': vaccinedate,
  //       'date2': vaccine2nddate,
  //       'date3': vaccine3rddate,
  //       'array': array,
  //     };

  //sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': vaccinename,
      'reason': vaccinereason,
      'date': vaccinedate,
      'date2': vaccine2nddate,
      'date3': vaccine3rddate,
      // 'array': FieldValue.arrayUnion([
      //   {
      //     'date': DateTime.now(),
      //     'reason': vaccinereason,
      //     'name': vaccinename,
      //   }
      // ])
    };
  }
// ///creating a object from a firebase snapshot
//   VaccineModel.fromSnapshot(DocumentSnapshot snapshot)
//       : vaccineuid = snapshot.data()['vaccine_uid'],
//         uid = snapshot.data()['uid'],
//         vaccinename = snapshot.data()['name'],
//         vaccinereason = snapshot.data()['reason'],
//         vaccinedate = snapshot.data()['date'],
//         vaccine2nddate = snapshot.data()['date2'],
//         vaccine3rddate = snapshot.data()['date3'],
//         array = snapshot.data()['array'];

}
