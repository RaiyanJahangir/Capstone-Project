import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
                "assets/top1.png",
                width: size.width
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
                "assets/top2.png",
                width: size.width
            ),
          ),
          Positioned(
            top: 60,
            right: 30,
            child: Lottie.asset(
              "assets/login.json",
              //width: 200,
              height: size.height * 0.25,
              fit: BoxFit.fill,
            ),
            // Image.asset(
            //     "assets/main.png",
            //     width: size.width * 0.35
            // ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
                "assets/bottom1.png",
                width: size.width
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset('assets/bottom2.png'),
          //   Image.asset(
          //       "assets/bottom2.png",
          //       width: size.width
          //   ),
          ),child
        ],
      ),
    );
  }
}