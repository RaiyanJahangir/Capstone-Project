import 'package:email_password_login/screens/notification_screen.dart';
import 'package:flutter/material.dart';

class Notificationview extends StatelessWidget {
  const Notificationview({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: listView(),
    );
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('Notification Screen'),
    );
  }

  Widget listView() {
    return ListView.separated(
      itemCount: 15,
      separatorBuilder: (context, index) {
        return Divider(height: 0);
      },
      itemBuilder: (context, index) {
        return listViewItem(index);
      },
    );
  }

  Widget listViewItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prefixIcon(),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    message(index),
                    timeAnddata(index),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget prefixIcon() {
    return Container(
      height: 50,
      width: 50,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
      ),
      child: Icon(
        Icons.notifications,
        size: 25,
        color: Colors.grey.shade700,
      ),
    );
  }

  Widget message(int index) {
    double textSize = 14;
    return Container(
      child: RichText(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: 'message',
          style: TextStyle(
              fontSize: textSize,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          children: [
            TextSpan(
                text: 'Notification description',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ))
          ],
        ),
      ),
    );
  }

  Widget timeAnddata(int index) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '23-01-2022',
            style: TextStyle(fontSize: 10),
          )
        ],
      ),
    );
  }
}
