import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class book extends StatelessWidget {
  const book({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Math Book'),
        ),
        body: SfPdfViewer.asset(
            'assets/book.pdf'));
  }
}
