import 'package:cloud_firestore/cloud_firestore.dart';

class FeedingModel {
  String? uid;
  //String? feeding_uid;
  String? foodtype;
  String? foodtime;
  String? medication;
  String? fooditem;
  String? food2;
  String? food3;
  List? foodarray;

  FeedingModel({
    this.uid,
    //this.feeding_uid,
    this.foodtype,
    this.foodtime,
    this.medication,
    this.fooditem,
    this.food2,
    this.food3,
    this.foodarray,
  });

  //receiving data from server
  factory FeedingModel.fromMap(map) {
    return FeedingModel(
      uid: map['uid'],
      foodtype: map['Food_type'],
      foodtime: map['Food_Time'],
      medication: map['Medication'],
      fooditem: map['Food_Item'],
      foodarray: map['Food_list'],
      food2: map['Meal_2'],
      food3: map['Meal_3'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      //'f_uid': feeding_uid,
      'uid': uid,
      'foodtype': foodtype,
      'foodtime': foodtime,
      'medication': medication,
      'fooditem': fooditem,
      'food2': food2,
      'food3': food3,
      'foodarray': FieldValue.arrayUnion([
        {
          'date': DateTime.now(),
          'fooditem': fooditem,
          'foodtype': foodtype,
        }
      ])
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
