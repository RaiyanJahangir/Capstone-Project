// import 'package:firebase_database/firebase_database.dart';
// import 'sensor_model.dart';

// class SensorDataDao {
//   final DatabaseReference _pulseRef =
//       FirebaseDatabase.instance.ref().child('Pulse Rate');
//   final DatabaseReference _temperatureRef =
//       FirebaseDatabase.instance.ref().child('Temperature');

//   //to save pulse rate data to realtime database
//   void savePulseData(PulseData message) {
//     _pulseRef.push().set(message.toJson());
//   }

//   //to save temperature data to realtime database
//   void saveTemperatureData(TemperatureData message) {
//     _temperatureRef.push().set(message.toJson());
//   }

//   Query getPulseData() {
//     return _pulseRef;
//   }

//   Query getTemperatureData() {
//     return _temperatureRef;
//   }
// }
