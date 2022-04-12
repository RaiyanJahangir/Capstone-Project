import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:email_password_login/model/user_model.dart';
import 'package:email_password_login/screens/home_screen.dart';


class guardian_homepage extends StatefulWidget {
  const guardian_homepage({Key? key}) : super(key: key);

  @override
  guardian_homepageState createState() => guardian_homepageState();
}

class guardian_homepageState extends State<guardian_homepage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String? a;
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
    a=loggedInUser.name;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(child: Text('Baby Info Page')),
                Icon(
                Icons.circle_notifications,
                color: Colors.white,
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
                ),
              ]
          ),
          actions: [
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                const PopupMenuItem(
                  child: ListTile(
                    //var a;
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.blue,
                      size: 24.0,),
                    //title: const Text(size ?? ''),
                    title: Text("Profile",),
                    // subtitle: Text(
                    //   a,
                    //   style: TextStyle(
                    //       color: Colors.black54, fontWeight: FontWeight.w500),
                    // ),
                      onTap: null,
                  ),
                ),
                const PopupMenuItem(
                  child: ListTile(
                    leading: Icon(
                      Icons.circle_notifications,
                      color: Colors.blue,
                      size: 24.0,
                    ),
                    title: Text('Notification'),
                    onTap: null,
                  ),
                ),
                const PopupMenuItem(
                  child: ListTile(
                    leading: Icon(
                    Icons.logout,
                    color: Colors.blue,
                      ),
                    title: Text('Logout'),
                    onTap: null,
                  ),
                ),
                // const PopupMenuDivider(),
                // const PopupMenuItem(child: Text('Item A')),
                // const PopupMenuItem(child: Text('Item B')),
              ],
            ),
          ],
          //backgroundColor: Color.fromRGBO(232, 232, 242, 1),
    ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: Text('Name : ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.red[400],
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(color: Colors.blueAccent, offset: Offset(2,1), blurRadius:10)
                            ]
                        )
                    ),
                  ),
                  Expanded(
                    child: Text("${loggedInUser.name}"),
                  ),
                  Expanded(
                    child: RaisedButton(
                      //     disabledColor: Colors.red,
                      // disabledTextColor: Colors.black,
                      padding: const EdgeInsets.all(20),
                      textColor: Colors.white,
                      color: Colors.green,
                      onPressed: () {
                        //selectf();
                      },
                      child: Text('Check Info'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                primary: false,
                children: [
                  Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () => null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child:
                            Lottie.asset(
                              "assets/food.json",
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text('Feeding Info',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () => null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child:
                            Lottie.asset(
                              "assets/health.json",
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text('Health Record',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () => null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child:
                            Lottie.asset(
                              "assets/map.json",
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Text('Check Baby Location',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              )
                          )
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    child: InkWell(
                      onTap: () => null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child:
                            Lottie.asset(
                              "assets/user.json",
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Text('Authorize New Users',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              )
                          )
                          )
                        ],
                      ),
                    ),
                  ),
                ],

              ),
            ),
          ],
        ),
      ),
    );
  }
}
