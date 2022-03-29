import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:firebase_upload_example/api/firebase_api.dart';

//UploadTask? task;
// File? file;
File? x;
String? selectedDirectory='not yet';

class assign extends StatefulWidget {
  const assign({Key? key}) : super(key: key);
  //File file;
  @override
  State<assign> createState() => _assignState();
}


class _assignState extends State<assign> {
  File? file;
  Future selectf() async {
    final res= await FilePicker.platform.pickFiles(allowMultiple: false);
    if (res==null)return;
    final path = res.files.single.path;
    setState(() {
      file=File(path!);
    });
  }
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    String up='';
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments'),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                //     disabledColor: Colors.red,
                // disabledTextColor: Colors.black,
                padding: const EdgeInsets.all(20),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  selectf();
                },
                child: Text('Select File'),
              ),
              Text(
                fileName,
                textScaleFactor: 2,
              ),
              RaisedButton(
                //     disabledColor: Colors.red,
                // disabledTextColor: Colors.black,
                padding: const EdgeInsets.all(20),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  up='Uploaded';
                },
                child: Text('Upload File'),
              ),
              Text(
                up.toString(),
                textScaleFactor: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}