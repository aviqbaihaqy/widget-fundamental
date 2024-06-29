import 'package:flutter/material.dart';
import 'package:myapp/data_sources/my_data_source.dart';

class DataTablesSimple extends StatefulWidget {
  const DataTablesSimple({super.key, required this.title});
  final String title;

  @override
  State<DataTablesSimple> createState() => _DataTablesSimple();
}

class _DataTablesSimple extends State<DataTablesSimple> {
  // Add your state variables and methods here.
  @override
  Widget build(BuildContext context) {
    MyDataSource mySource = MyDataSource(["ab", "bc", "de", "ef"]);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scrollbar(
        child: ListView(
          children: [
            Column(
              children: [
                //Widget form
                PaginatedDataTable(
                  header: const Text('List Data'),
                  columns: const <DataColumn>[
                    DataColumn(label: Text('No.')),
                    DataColumn(label: Text('Data 1')),
                    DataColumn(label: Text('Action')),
                  ],
                  source: mySource,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
