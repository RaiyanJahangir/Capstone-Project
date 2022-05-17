import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/notification_screen.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

var latitude = 23.83780840691303;
var longitude = 90.35788633293909;
// var latitude;
// var longitude;

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final databaseRef =
      FirebaseDatabase.instance.reference().child("Sensor Data");

  /*var latitude = 0.0;
  var longitude = 0.0;*/

  static final Marker _kmark = Marker(
      markerId: MarkerId('_kmark'),
      infoWindow: InfoWindow(title: 'Google plex'),
      icon: BitmapDescriptor.defaultMarker,
      //position: LatLng(23.83780840691303, 90.35788633293909));
      position: LatLng(latitude, longitude));

  @override
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

    databaseRef.onValue.listen((event) {
      print(latitude.toString() + "dollar " + longitude.toString());
      var snapshot = event.snapshot;
      int count = 0;
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        count++;
        // if (key == 'Latitude') {
        //   latitude = values;
        // }
        // if (key == 'Longitude') {
        //   longitude = values;
        // }
        if (key == 'Latitude') {
          int a = values;
          latitude = a.toDouble();
          print('Latitude ' + latitude.toString());
        }
        if (key == 'Longitude') {
          int a = values;
          longitude = a.toDouble();
          print('Longitude ' + longitude.toString());
        }
        if (key == 'Pulse Rate') {
          print('Pulse Rate ' + values.toString());
        }
        if (key == 'Temperature') {
          print('Temperature ' + values.toString());
        }
        // setState(() {});
        _setMarker(LatLng(latitude, longitude));
      });
    });
  }

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygon = Set<Polygon>();
  List<LatLng> _latlong = <LatLng>[];
  int _polygonIdCounter = 1;

  static final CameraPosition _kGooglePlex = CameraPosition(
    // target: LatLng(37.42796133580664, -122.085749655962),
    //target: LatLng(23.748742, 90.373972),
    //target: LatLng(23.83780840691303, 90.35788633293909),
    target: LatLng(latitude, longitude),
    zoom: 17.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      //target: LatLng(37.43296265331129, -122.08832357078792),
      //target: LatLng(23.748742, 90.373972),
      //target: LatLng(23.83780840691303, 90.35788633293909),
      target: LatLng(latitude, longitude),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(
        Marker(markerId: MarkerId('marker'), position: point),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Text('Baby Location')),
              IconButton(
                icon: Icon(
                  Icons.circle_notifications,
                  color: Colors.white,
                  size: 24.0,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) => NotificationScreen()));
                },
              ),
            ]),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: ListTile(
                  //var a;
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.blue,
                    size: 24.0,
                  ),
                  //title: const Text(size ?? ''),
                  title: Text(
                    "User Profile",
                  ),
                  subtitle: Text(
                    "${loggedInUser.name}",
                  ),
                  //onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (c) => SensorScreen())),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (c) => Home())),
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.blue,
                  ),
                  title: Text('Logout'),
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Confirm Logging Out ?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.blue,
                                  fontSize: 25)),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  logout(context);
                                },
                                child: Text("YES",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.blueAccent,
                                        fontSize: 20))),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("NO",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.blueAccent,
                                        fontSize: 20)))
                          ],
                        );
                      }),
                ),
              ),
            ],
          ),
        ],
        //backgroundColor: Color.fromRGBO(232, 232, 242, 1),
      ),
      // body: GoogleMap(
      //   mapType: MapType.hybrid,
      //   initialCameraPosition: _kGooglePlex,
      //   onMapCreated: (GoogleMapController controller) {
      //     _controller.complete(controller);
      //   },
      // ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        markers: {_kmark},
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    _setMarker(LatLng(latitude, longitude));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
