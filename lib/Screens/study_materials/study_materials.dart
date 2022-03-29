import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'book.dart';

class FirstScreen extends StatelessWidget {

  String? _selectedGender=null;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Materials'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            DropdownButton(
              value: _selectedGender,
              items: _dropDownItem(),
              onChanged: (value) async {
                _selectedGender=value as String?;
                switch(value){
                  case "Books" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => book()),
                    );
                    break;
                  case "Class Notes" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondScreen()),
                    );
                    break;
                  case "Video" :
                    final url='https://www.youtube.com/watch?v=94N-Yw0AdRM&list=PLEnvNvpjnLbEAkxgSki4HhJXS-49-1Cie&ab_channel=SumonReza';
                    if(await canLaunch(url)){
                await launch(
                url,
                forceSafariVC: true,
                forceWebView: true,
                enableJavaScript: true,
                );
                }
                    break;
                  case "Slides" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => third()),
                    );
                    break;
                }
              },
              hint: Text('Mathematics'),
            ),
            DropdownButton(
              value: _selectedGender,
              items: _dropDownItem(),
              onChanged: (value){
                _selectedGender=value as String?;
                switch(value){
                  case "Books" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondScreen()),
                    );
                    break;
                  case "Class Notes" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondScreen()),
                    );
                    break;
                  case "Video" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => third()),
                    );
                    break;
                  case "Slides" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => third()),
                    );
                    break;
                }
              },
              hint: Text('Science'),
            ),
            DropdownButton(
              value: _selectedGender,
              items: _dropDownItem(),
              onChanged: (value){
                _selectedGender=value as String?;
                switch(value){
                  case "Books" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondScreen()),
                    );
                    break;
                  case "Class Notes" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondScreen()),
                    );
                    break;
                  case "Video" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => third()),
                    );
                    break;
                  case "Slides" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => third()),
                    );
                    break;
                }
              },
              hint: Text('English'),
            ),
            DropdownButton(
              value: _selectedGender,
              items: _dropDownItem(),
              onChanged: (value){
                _selectedGender=value as String?;
                switch(value){
                  case "Books" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondScreen()),
                    );
                    break;
                  case "Class Notes" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondScreen()),
                    );
                    break;
                  case "Video" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => third()),
                    );
                    break;
                  case "Slides" :
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => third()),
                    );
                    break;
                }
              },
              hint: Text('Bangla'),
            ),
          ],
        ),
      ),
    );
  }


  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = ["Books", "Class Notes", "Video", "Slides"];
    return ddl.map(
            (value) =>
            DropdownMenuItem(
              value: value,
              child: Text(value),
            )
    ).toList();
  }
}


class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

class third extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("tgird Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}