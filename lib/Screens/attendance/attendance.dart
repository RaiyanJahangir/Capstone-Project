import 'package:flutter/material.dart';

List<Map> attend = [
  {
    'Date': ' 01-05-21 ',
    'Status': ' Present '
  },
  {
    'Date': ' 02-05-21 ',
    'Status': ' Absent '
  },
  {
    'Date': ' 03-05-21 ',
    'Status': ' Present '
  },
];

class attendance extends StatelessWidget {
  const attendance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Details'),
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
      DataColumn(label: Text('Date')),
      DataColumn(label: Text('Status'))
    ];
  }
  List<DataRow> _createRows() {
    return attend
        .map((book) => DataRow(cells: [
      DataCell(Text(book['Date'])),
      DataCell(Text(book['Status']))
    ]))
        .toList();
  }
}