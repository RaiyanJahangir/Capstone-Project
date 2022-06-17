import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/notification_screen.dart';
import 'package:email_password_login/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

var latitude = 23.83773;
var longitude = 90.3577;

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final databaseRef =
      FirebaseDatabase.instance.reference().child("baby0").child("Sensor Data");

  static Marker _kmark = Marker(
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
      WidgetsBinding.instance?.addPostFrameCallback((_) => _goToTheLake());
    });

    //function for string sizing
    String strSizing(String l) {
      if (l.length < 7) {
        int rem = 7 - l.length;
        for (int i = 0; i < rem; i++) {
          l += "0";
        }
      } else if (l.length > 7) {
        l = l.substring(0, 7);
      }
      return l;
    }
    //function for string sizing

    databaseRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      int count = 0;
      Map<dynamic, dynamic> values = snapshot.value;
      print("\n\nvalues :\n");
      print(values);
      String temp1 = values['Latitude'];
      temp1 = strSizing(temp1);
      //temp1 = temp1 / 100000.00;
      String temp2 = values['Longitude'];
      temp2 = strSizing(temp2);
      //temp2 = temp2 / 100000.00;

      print("\n");
      var myDouble1 = double.parse(temp1);
      assert(myDouble1 is double);
      myDouble1 = myDouble1 / 100000.00;
      print(myDouble1);
      print("\n");
      var myDouble2 = double.parse(temp2);
      assert(myDouble2 is double);
      myDouble2 = myDouble2 / 100000.00;
      print(myDouble2);
      print("\n\n");
      latitude = myDouble1;
      longitude = myDouble2;

      values.forEach((key, values) {
        count++;

        if (count == 1) {
          int temp = values;
          latitude = temp.toDouble();
          print("\n\nThis is the found lat:");
          print(latitude);
          print("\n\n");
        } else if (count == 2) {
          int temp = values;
          latitude = temp.toDouble();
          print("\n\nThis is the found long:");
          print(longitude);
          print("\n\n");
        }
      });
    });
    //for debugging
    print("\n" + latitude.toString() + "   " + longitude.toString() + "\n");
    print("\n" + "\n");
    //for debugging
    //checking update
  }

  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Set<Polygon> _polygon = Set<Polygon>();
  List<LatLng> _latlong = <LatLng>[];
  int _polygonIdCounter = 1;

  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 18.5,
  );

  void _setMarker(LatLng point) {
    var markerIdVal = markers.length + 1;
    String mar = markerIdVal.toString();
    final MarkerId markerId = MarkerId(mar);
    final Marker marker = Marker(markerId: markerId, position: point);
    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    //for debugging fetching

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
      body: GoogleMap(
        mapType: MapType.normal,
        markers: Set<Marker>.of(markers.values),
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Refresh Location'),
        icon: Icon(Icons.refresh),
      ),
    );
    print(latitude.toString() + " " + longitude.toString() + "\n");
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(latitude, longitude),
        tilt: 59.440717697143555,
        zoom: 17.5);
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    print(latitude.toString() + "@" + longitude.toString() + "\n");
    _setMarker(LatLng(latitude, longitude));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
