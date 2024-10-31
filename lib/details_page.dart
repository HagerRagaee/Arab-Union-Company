import 'package:flutter/material.dart';
import 'package:source_app/work_order.dart';

class DetailsPage extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final String driverName;

  const DetailsPage({Key? key, required this.data, required this.driverName})
      : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool loaded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topRight,
          child: Text('${widget.driverName} '),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder.all(color: Colors.grey),
                columnSpacing: 20,
                columns: _buildColumns(),
                rows: _buildRows(context),
              ),
            ),
          ),
          if (loaded)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  // Helper method for defining columns
  List<DataColumn> _buildColumns() {
    const columnNames = [
      'No.',
      'Start Date',
      'End Date',
      'Route',
      'Vehicle Number'
    ];
    return columnNames
        .map(
          (name) => DataColumn(
            label: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  // Helper method for building rows
  List<DataRow> _buildRows(BuildContext context) {
    return widget.data.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> rowData = entry.value;

      return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            return index.isEven ? Colors.white : Colors.grey[100];
          },
        ),
        cells: [
          _buildDataCell((index + 1).toString()), // Row Number
          _buildDataCell(rowData['startDate'] ?? 'N/A'),
          _buildDataCell(rowData['endDate'] ?? 'N/A'), // Start Date
          _buildDataCell(rowData['route'] ?? 'N/A'), // Route
          _buildDataCell(rowData['vehicleNumber'] ?? 'N/A'), // Vehicle Number
        ],
        onLongPress: () async {
          setState(() {
            loaded = true;
          });
          await Future.delayed(const Duration(seconds: 2)); // Add a delay
          setState(() {
            loaded = false;
          });

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WorkOrder(
                    driverData: rowData,

                    // startDate: rowData['startDate'],
                    // endDate: rowData['endDate'],
                    // route: rowData['route'],
                    // vehicleNumber: rowData['vehicleNumber'],
                    // mangementName: rowData['mangementName'],
                    // userName: rowData['userName'],
                    // companyName: rowData['companyName'],
                    // numberJobNumber: rowData['numberJobNumber'],
                    // notes: rowData['notes'],
                    // driverName: widget.driverName,
                    // escortsNames: rowData['escortsNames'],
                    // vehicleType: rowData['vehicleType'],
                    // signatureText: rowData['signatureText'],
                  )));
        },
      );
    }).toList();
  }

  // Helper method for creating a DataCell with styling and alignment
  DataCell _buildDataCell(String text) {
    return DataCell(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          text,
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
