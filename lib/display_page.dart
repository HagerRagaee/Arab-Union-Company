import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'details_page.dart';

class DisplayPage extends StatelessWidget {
  DisplayPage({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> getAllDriversData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('drivers').get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple[100],
        title: const Text(
          "Drivers Data",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAllDriversData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          } else {
            List<Map<String, dynamic>> allData = snapshot.data!;

            // Get unique driver names
            final uniqueDriverNames = <String>{};
            final uniqueDriverData = allData.where((data) {
              return uniqueDriverNames.add(data['driverName']);
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: ListView.builder(
                  itemCount: uniqueDriverData.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = uniqueDriverData[index];
                    String driverName = data['driverName'] ?? 'N/A';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          driverName,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          final driverData = allData
                              .where((d) => d['driverName'] == driverName)
                              .toList();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                data: driverData,
                                driverName: driverName,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
