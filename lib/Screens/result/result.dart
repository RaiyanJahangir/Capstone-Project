import 'package:flutter/material.dart';

List<Map> exams = [
  {
    'exam': ' Class Test 1 ',
    'mark': ' 35 '
  },
  {
    'exam': ' Class Test 2 ',
    'mark': ' 40 '
  },
  {
    'exam': ' Class Test 3 ',
    'mark': ' 45 '
  },
  {
    'exam': ' Class Test 4 ',
    'mark': ' 40 '
  },
  {
    'exam': ' Assignment 1 ',
    'mark': ' 40 '
  },
  {
    'exam': ' Assignment 2 ',
    'mark': ' 30 '
  },
  {
    'exam': ' Assignment 1 ',
    'mark': ' 50 '
  },
];

class rsheet extends StatelessWidget {
  const rsheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Result Details'),
      ),
      body: ListView(
        children: [
          _createDataTable()
        ],
      ),
    );
  }

  DataTable _createDataTable() {
    return DataTable(columns: _createColumns(), rows: _createRows());
  }
  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Exams')),
      DataColumn(label: Text('Marks Obtained'))
    ];
  }
  List<DataRow> _createRows() {
    return exams
        .map((book) => DataRow(cells: [
            DataCell(Text(book['exam'])),
            DataCell(Text(book['mark']))
    ]))
        .toList();
  }
  // List<DataColumn> _createColumns() {
  //   return [
  //     DataColumn(label: Text('Class Test 1')),
  //     DataColumn(label: Text('Class Test 2')),
  //     DataColumn(label: Text('Class Test 3')),
  //     DataColumn(label: Text('Class Test 4')),
  //     DataColumn(label: Text('Assignment 1')),
  //     DataColumn(label: Text('Assignment 2')),
  //     DataColumn(label: Text('Assignment 3'))
  //   ];
  // }
  // List<DataRow> _createRows() {
  //   return result
  //       .map((book) => DataRow(cells: [
  //     DataCell(Text(book['c1'].toString())),
  //     DataCell(Text(book['c2'].toString())),
  //     DataCell(Text(book['c3'].toString())),
  //     DataCell(Text(book['c4'].toString())),
  //     DataCell(Text(book['a1'].toString())),
  //     DataCell(Text(book['a2'].toString())),
  //     DataCell(Text(book['a3'].toString()))
  //   ]))
  //       .toList();
  // }
}