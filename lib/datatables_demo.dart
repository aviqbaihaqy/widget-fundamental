import 'package:flutter/material.dart';
import 'package:myapp/data_sources/dessert_data_source.dart';
import 'package:myapp/models/dessert.dart';

class DataTablesDemo extends StatefulWidget {
  const DataTablesDemo({super.key, required this.title});
  final String title;

  @override
  State<DataTablesDemo> createState() => _DataTablesDemoState();
}

class _DataTablesDemoState extends State<DataTablesDemo> with RestorationMixin {
  // Create restoration properties
  final RestorableDessertSelections _dessertSelections =
      RestorableDessertSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage =
      RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);

  // Declare a _DessertDataSource instance and initialize it to null
  DessertDataSource? _dessertsDataSource;

  // final RestorableInt _rowIndex = RestorableInt(0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize _dessertsDataSource if it is null
    _dessertsDataSource ??= DessertDataSource(context);

    // Add listener to _dessertsDataSource to update selected dessert row
    _dessertsDataSource!.addListener(_updateSelectedDessertRowListener);
  }

  // Update the selected dessert row
  void _updateSelectedDessertRowListener() {
    _dessertSelections.setDessertSelections(_dessertsDataSource!.desserts);
  }

  @override
  void dispose() {
    // Remove the listener that updates the selected dessert row
    // from the _dessertsDataSource
    _dessertsDataSource!.removeListener(_updateSelectedDessertRowListener);

    // Dispose of the _dessertsDataSource stream subscription
    _dessertsDataSource!.dispose();
    super.dispose();
  }

  @override
  String? get restorationId => 'data_table_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_dessertSelections, 'selected_row_indices');
    registerForRestoration(_rowIndex, 'current_row_index');
    registerForRestoration(_rowsPerPage, 'rows_per_page');
    registerForRestoration(_sortAscending, 'sort_ascending');
    registerForRestoration(_sortColumnIndex, 'sort_column_index');

    // Initialize _dessertsDataSource if it is null
    _dessertsDataSource ??= DessertDataSource(context);

    // Sort the data source according to the sort column index
    switch (_sortColumnIndex.value) {
      case 0:
        _dessertsDataSource!.sort<String>((d) => d.name, _sortAscending.value);
        break;
      case 1:
        _dessertsDataSource!.sort<num>((d) => d.calories, _sortAscending.value);
        break;
      case 2:
        _dessertsDataSource!.sort<num>((d) => d.fat, _sortAscending.value);
        break;
      case 3:
        _dessertsDataSource!.sort<num>((d) => d.carbs, _sortAscending.value);
        break;
      case 4:
        _dessertsDataSource!.sort<num>((d) => d.protein, _sortAscending.value);
        break;
      case 5:
        _dessertsDataSource!.sort<num>((d) => d.sodium, _sortAscending.value);
        break;
      case 6:
        _dessertsDataSource!.sort<num>((d) => d.calcium, _sortAscending.value);
        break;
      case 7:
        _dessertsDataSource!.sort<num>((d) => d.iron, _sortAscending.value);
        break;
    }

    // Update the selection of desserts
    _dessertsDataSource!.updateSelectedDesserts(_dessertSelections);

    // Add listener to _dessertsDataSource to update selected dessert row
    _dessertsDataSource!.addListener(_updateSelectedDessertRowListener);
  }

  // Sort the data source
  void _sort<T>(
    Comparable<T> Function(Dessert d) getField,
    int columnIndex,
    bool ascending,
  ) {
    _dessertsDataSource!.sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex.value = columnIndex;
      _sortAscending.value = ascending;
    });
  }

  // Add your state variables and methods here.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scrollbar(
        child: ListView(
          restorationId: 'data_table_list_view',
          padding: const EdgeInsets.all(16),
          children: [
            PaginatedDataTable(
              header: const Text('Nutrision'),
              rowsPerPage: _rowsPerPage.value,
              onRowsPerPageChanged: (value) {
                setState(() {
                  _rowsPerPage.value = value!;
                });
              },
              initialFirstRowIndex: _rowIndex.value,
              onPageChanged: (rowIndex) {
                setState(() {
                  _rowIndex.value = rowIndex;
                });
              },
              sortColumnIndex: _sortColumnIndex.value,
              sortAscending: _sortAscending.value,
              onSelectAll: _dessertsDataSource!.selectAll,
              columns: [
                DataColumn(
                  label: const Text(
                      'Dessert 1 Serving'), // Set the label of the first column
                  onSort: (columnIndex, ascending) => _sort<String>(
                      (d) => d.name,
                      columnIndex,
                      ascending), // Set the sorting function of the first column
                ),
                DataColumn(
                  label: const Text('Calories'), // Set the label of the second column
                  numeric: true,
                  onSort: (columnIndex, ascending) => _sort<num>(
                      (d) => d.calories,
                      columnIndex,
                      ascending), // Set the sorting function of the second column
                ),
                DataColumn(
                  label: const Text('Fat (g)'), // Set the label of the third column
                  numeric: true,
                  onSort: (columnIndex, ascending) => _sort<num>(
                      (d) => d.fat,
                      columnIndex,
                      ascending), // Set the sorting function of the third column
                ),
                DataColumn(
                  label:
                      const Text('Carbs (g)'), // Set the label of the fourth column
                  numeric: true,
                  onSort: (columnIndex, ascending) => _sort<num>(
                      (d) => d.carbs,
                      columnIndex,
                      ascending), // Set the sorting function of the fourth column
                ),
                DataColumn(
                  label:
                      const Text('Protein (g)'), // Set the label of the fifth column
                  numeric: true,
                  onSort: (columnIndex, ascending) => _sort<num>(
                      (d) => d.protein,
                      columnIndex,
                      ascending), // Set the sorting function of the fifth column
                ),
                DataColumn(
                  label:
                      const Text('Sodium (mg)'), // Set the label of the sixth column
                  numeric: true,
                  onSort: (columnIndex, ascending) => _sort<num>(
                      (d) => d.sodium,
                      columnIndex,
                      ascending), // Set the sorting function of the sixth column
                ),
                DataColumn(
                  label:
                      const Text('Calcium %'), // Set the label of the seventh column
                  numeric: true,
                  onSort: (columnIndex, ascending) => _sort<num>(
                      (d) => d.calcium,
                      columnIndex,
                      ascending), // Set the sorting function of the seventh column
                ),
                DataColumn(
                  label: const Text('Iron %'), // Set the label of the eighth column
                  numeric: true,
                  onSort: (columnIndex, ascending) => _sort<num>(
                      (d) => d.iron,
                      columnIndex,
                      ascending), // Set the sorting function of the eighth column
                ),
              ],
              source: _dessertsDataSource!,
            )
          ],
        ),
      ),
    );
  }
}

class RestorableDessertSelections extends RestorableProperty<Set<int>> {
  // The set of indices of selected dessert rows
  Set<int> _dessertSelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _dessertSelections.contains(index);

  /// Takes a list of [_Dessert]s and saves the row indices of selected rows
  /// into a [Set].
  void setDessertSelections(List<Dessert> desserts) {
    final updatedSet = <int>{};
    for (var i = 0; i < desserts.length; i += 1) {
      var dessert = desserts[i];
      if (dessert.selected) {
        updatedSet.add(i);
      }
    }
    _dessertSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _dessertSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _dessertSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _dessertSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _dessertSelections = value;
  }

  @override
  Object toPrimitives() => _dessertSelections.toList();
}
