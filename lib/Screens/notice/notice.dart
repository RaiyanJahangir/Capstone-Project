import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:http/http.dart';

class notice extends StatefulWidget {
  const notice({Key? key}) : super(key: key);

  @override
  State<notice> createState() => _noticeState();
}

class _noticeState extends State<notice> {
  final url="https://jsonplaceholder.typicode.com/posts";
  //final url="https://baki-api.herokuapp.com/hello/see/posts";
  var _postsJson=[];

  void fetchPost() async {
    try{
      final response=await get(Uri.parse(url));
      final jsonData= jsonDecode(response.body) as List;
      setState(() {
        _postsJson = jsonData;
      });
    }
    catch(e){
      print(e);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPost();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notice'),
      ),
      body: ListView.builder(
        itemCount: _postsJson.length,
        itemBuilder: (context,index) {
          final post=_postsJson[index];
          return Text(
              //"Title: ${post["taskTitle"]}\n Body: ${post["taskDesc"]}\n\n"
            "Title:    ${post["title"]}\n Body:    ${post["body"]}\n\n",
            style: TextStyle(
            fontSize: 20,
            color: Colors.brown[600],
          ),
          );
        },
      ),
    );
  }
}
