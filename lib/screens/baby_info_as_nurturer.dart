import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum _MenuValues {
  logout,
}
String dropdownValue = 'One';
class nurturer_homepage extends StatefulWidget {
  const nurturer_homepage({Key? key}) : super(key: key);

  @override
  State<nurturer_homepage> createState() => _nurturer_homepageState();
}

class _nurturer_homepageState extends State<nurturer_homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Icon(
                  Icons.circle_notifications,
                  color: Colors.white,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
              ),
              Expanded(
                child: Text("John Cameron"),
              ),
              Expanded(
                child: Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
              )
            ]
        ),
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
                    child: Text('List of Babies : ',
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
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['One', 'Two', 'Free', 'Four']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                primary: false,
                children: [
                  Card(
                    elevation: 2,
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
                    elevation: 2,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
