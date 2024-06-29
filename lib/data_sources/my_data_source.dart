import 'package:flutter/material.dart';

class MyDataSource extends DataTableSource {
  List<String> value;
  MyDataSource(this.value) {
    // print(value);
  }

  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('$index')),
        DataCell(Text(value[index])),
        DataCell(
          InkWell(
            onTap: () {
              //fill the form above the table and after user fill it, the data inside the table will be refreshed
            },
            child: const Text("Click"),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => value.length;

  @override
  int get selectedRowCount => 0;
}
