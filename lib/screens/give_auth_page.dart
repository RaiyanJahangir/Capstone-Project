import 'package:flutter/material.dart';


enum user { guardian , nurturer }

class auth extends StatefulWidget {
  const auth({Key? key}) : super(key: key);

  @override
  State<auth> createState() => _authState();
}

class _authState extends State<auth> {
  user? _site = user.guardian;
  String? _name;
  String? _email;
  String _box = 'One';
  String? _relation;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildname() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'UserName'),
      maxLength: 30,
      validator: (value){
        if(value!.isEmpty)return 'Required';
        return null;
      },
      onSaved: (value){
        _name=value;
      },
    );
  }
  Widget _buildemail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email Address'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email is Required';
        }

        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (value) {
        _email = value;
      },
    );
  }
  Widget _buildbox() {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Guardian'),
          leading: Radio(
            value: user.guardian,
            groupValue: _site,
            onChanged: (value) {
              setState(() {
                _site = value as user?;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Nurturer'),
          leading: Radio(
            value: user.nurturer,
            groupValue: _site,
            onChanged: (value) {
              setState(() {
                _site = value as user?;
              });
            },
          ),
        ),
      ],
    );
  }
  Widget _buildlist() {
    return DropdownButton<String>(
      value: _box,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (newValue) {
        setState(() {
          _box = newValue!;
        });
      },
      items: <String>['One', 'Two', 'Free', 'Four']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
  Widget _builduser() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Child Relation to the User'),
      maxLength: 30,
      validator: (value){
        if(value!.isEmpty)return 'Required';
        return null;
      },
      onSaved: (value){
        _relation=(value as String?)!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            //crossAxisAlignment: CrossAxisAlignment.end,
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
        margin: EdgeInsets.all(24),
        child: Column(
            children: [
              Expanded(
                flex: 1,
                  child: Text(
                "Authorize Permission",
                textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.red[400],
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      shadows: [
                        Shadow(color: Colors.blueAccent, offset: Offset(2,1), blurRadius:10)
                      ]
                  )
              )
              ),
              Expanded(
                flex: 8,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildname(),
                        SizedBox(height: 10,),
                        _buildemail(),
                        SizedBox(height: 10),
                        Text('Give permission as: ',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                          ),
                            ),
                        _buildbox(),
                        Text('Give permission on: ',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        _buildlist(),
                        SizedBox(height: 10,),
                        _builduser(),
                        SizedBox(height: 10,),
                        RaisedButton(
                          child: Text(
                            'Submit',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {return;}
                            _formKey.currentState!.save();
                            print(_site);
                            print(_name);
                            print(_email);
                            print(_box);
                            print(_relation);
                          },
                        )
                      ],
                    )
                  )
              )
            ],
          ),
        ),
    );
  }
}
