import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_password_login/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:email_password_login/screens/login_screen.dart';
import 'package:email_password_login/screens/VaccinationList.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:email_password_login/screens/FeedingList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_password_login/model/user_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'avenir'),
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final Stream<QuerySnapshot> vaccinestream =
      FirebaseFirestore.instance.collection('vaccines').snapshots();

  String filterType = "today";
  DateTime today = new DateTime.now();
  String taskPop = "close";
  var monthNames = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEPT",
    "OCT",
    "NOV",
    "DEC"
  ];
  CalendarController ctrlr = new CalendarController();
  @override
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

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
  }

  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: vaccinestream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('something is wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            //print(storedocs);
          }).toList();

          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(child: Text('Baby Schedule')),
                    Icon(
                      Icons.circle_notifications,
                      color: Colors.white,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ]),
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
                          size: 24.0,
                        ),
                        //title: const Text(size ?? ''),
                        title: Text(
                          "Profile",
                        ),
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
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 70,
                      color: Color(0xfff90CAF9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  changeFilter("Vaccination list");
                                },
                                child: Text(
                                  "Vaccination List",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 4,
                                width: 120,
                                color: (filterType == "Vaccination list")
                                    ? Colors.white
                                    : Colors.transparent,
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  changeFilter("monthly");
                                },
                                child: Text(
                                  "Feeding List",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 4,
                                width: 120,
                                color: (filterType == "monthly")
                                    ? Colors.white
                                    : Colors.transparent,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    (filterType == "monthly")
                        ? Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TableCalendar(
                                    calendarController: ctrlr,
                                    startingDayOfWeek: StartingDayOfWeek.monday,
                                    initialCalendarFormat: CalendarFormat.week,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Today ${monthNames[today.month - 1]}, ${today.day}/${today.year}",
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                  for (var i in storedocs)
                                    Column(
                                      children: [
                                        taskWidget(
                                          Color(0xfff90CAF9),
                                          "${i['name']}",
                                          "${i['date']}",
                                        ),
                                      ],
                                    ),

                                  // taskWidget(
                                  //     Colors.blue, "Meeting with someone", "9:00 AM"),
                                  // taskWidget(
                                  //     Colors.green, "Take your medicines", "9:00 AM"),
                                  // Container(
                                  //   child: ListView.builder(
                                  //     itemCount: 1,
                                  //     itemBuilder: (BuildContext context, int) {
                                  //       return ListTile(title: Text('hello'));
                                  //       // return taskWidget(
                                  //       //   Color(0xfff96060),
                                  //       //   "${storedocs[index]['name']}",
                                  //       //   "${storedocs[index]['reason']}",
                                  //       // );
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    (filterType == "Vaccination list")
                        ? Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Today ${monthNames[today.month - 1]}, ${today.day}/${today.year}",
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                  for (var i in storedocs)
                                    Column(
                                      children: [
                                        taskWidget(
                                          Color(0xfff90CAF9),
                                          "${i['name']}",
                                          "${i['reason']}",
                                        ),
                                      ],
                                    ),

                                  // taskWidget(
                                  //     Colors.blue, "Meeting with someone", "9:00 AM"),
                                  // taskWidget(
                                  //     Colors.green, "Take your medicines", "9:00 AM"),
                                  // Container(
                                  //   child: ListView.builder(
                                  //     itemCount: 1,
                                  //     itemBuilder: (BuildContext context, int) {
                                  //       return ListTile(title: Text('hello'));
                                  //       // return taskWidget(
                                  //       //   Color(0xfff96060),
                                  //       //   "${storedocs[index]['name']}",
                                  //       //   "${storedocs[index]['reason']}",
                                  //       // );
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    (filterType != "Vaccination list" &&
                            filterType != "monthly")
                        ? Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Today ${monthNames[today.month - 1]}, ${today.day}/${today.year}",
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ),
                                  for (var i in storedocs)
                                    Column(
                                      children: [
                                        taskWidget(
                                          Color(0xfff90CAF9),
                                          "${i['date']}",
                                          "${i['reason']}",
                                        ),
                                      ],
                                    ),

                                  // taskWidget(
                                  //     Colors.blue, "Meeting with someone", "9:00 AM"),
                                  // taskWidget(
                                  //     Colors.green, "Take your medicines", "9:00 AM"),
                                  // Container(
                                  //   child: ListView.builder(
                                  //     itemCount: 1,
                                  //     itemBuilder: (BuildContext context, int) {
                                  //       return ListTile(title: Text('hello'));
                                  //       // return taskWidget(
                                  //       //   Color(0xfff96060),
                                  //       //   "${storedocs[index]['name']}",
                                  //       //   "${storedocs[index]['reason']}",
                                  //       // );
                                  //     },
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    Container(
                      height: 110,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: 90,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.blue,
                              padding: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Vaccines",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.menu,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "List",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.content_paste,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Chart",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.account_circle,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Profile",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 25,
                            left: 0,
                            right: 0,
                            child: InkWell(
                              onTap: openTaskPop,
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color.fromARGB(255, 6, 55, 95),
                                        Color.fromARGB(255, 109, 162, 204)
                                      ],
                                    ),
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Text(
                                    "+",
                                    style: TextStyle(
                                        fontSize: 40, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  child: (taskPop == "open")
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black.withOpacity(0.3),
                          child: Center(
                            child: InkWell(
                              onTap: openTaskPop,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.white),
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      height: 1,
                                    ),
                                    InkWell(
                                      onTap: openVaccinationList,
                                      child: Container(
                                        child: Text(
                                          "Add Vaccination",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 1,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      color: Colors.blue.withOpacity(0.2),
                                    ),
                                    InkWell(
                                      onTap: openFeedingList,
                                      child: Container(
                                        child: Text(
                                          "Add Feeding time",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 1,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                )
              ],
            ),
          );
        });
  }

  openTaskPop() {
    taskPop = "open";
    setState(() {});
  }

  closeTaskPop() {
    taskPop = "close";
    setState(() {});
  }

  changeFilter(String filter) {
    filterType = filter;
    setState(() {});
  }

  Slidable taskWidget(Color color, String title, String time) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.3,
      child: Container(
        height: 80,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: Offset(0, 9),
              blurRadius: 20,
              spreadRadius: 1)
        ]),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 4)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                )
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              height: 50,
              width: 5,
              color: color,
            )
          ],
        ),
      ),
      secondaryActions: [
        IconSlideAction(
          caption: "Edit",
          color: Colors.white,
          icon: Icons.edit,
          onTap: () {},
        ),
        IconSlideAction(
          caption: "Delete",
          color: color,
          icon: Icons.edit,
          onTap: () {},
        )
      ],
    );
  }

  openVaccinationList() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewTask()));
  }

  openFeedingList() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FeedingList()));

    //context, MaterialPageRoute(builder: (context) => openFeedingList()));
  }

  openNewCheckList() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
