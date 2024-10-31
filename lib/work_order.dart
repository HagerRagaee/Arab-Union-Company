// ignore_for_file: use_build_context_synchronously, avoid_print, must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:source_app/stackDateField.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:source_app/stackData.dart';

class WorkOrder extends StatefulWidget {
  Map<String, dynamic>? driverData;
  WorkOrder({super.key, required this.driverData});

  @override
  State<WorkOrder> createState() => _WorkOrderState();
}

class _WorkOrderState extends State<WorkOrder> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 4,
    penColor: Colors.black,
  );

  TextEditingController controllerManagment = TextEditingController();
  TextEditingController controllerUserName = TextEditingController();
  TextEditingController controllerNumber = TextEditingController();
  TextEditingController controllerCarNumber = TextEditingController();
  TextEditingController controllerCarType = TextEditingController();
  TextEditingController controllerDriverName = TextEditingController();
  TextEditingController controllerEscorts = TextEditingController();
  TextEditingController controllerNote = TextEditingController();
  TextEditingController controllerCompanyName = TextEditingController();
  TextEditingController controllerAddress =
      TextEditingController(); // Added this line
  TextEditingController controllerStartDate =
      TextEditingController(); // Updated to TextEditingController
  TextEditingController controllerEndDate =
      TextEditingController(); // Updated to TextEditingController
  TextEditingController controllerLeaveTime = TextEditingController();
  TextEditingController controllerReturnTime = TextEditingController();
  String? signatureBase64;
  final _formKey = GlobalKey<FormState>();

  void _clearFields() {
    controllerManagment.clear();
    controllerUserName.clear();
    controllerNumber.clear();
    controllerCarNumber.clear();
    controllerCarType.clear();
    controllerDriverName.clear();
    controllerEscorts.clear();
    controllerNote.clear();
    controllerCompanyName.clear();
    controllerAddress.clear();
    controllerStartDate.clear();
    controllerEndDate.clear();
    controllerLeaveTime.clear();
    controllerReturnTime.clear();
    _controller.clear();
  }

  Future<String?> _getSignatureAsBase64() async {
    if (_controller.isNotEmpty) {
      final Uint8List? data = await _controller.toPngBytes();
      if (data != null) {
        return base64Encode(data);
      }
    }
    return null;
  }

  Future<void> _updateDriverData() async {
    String? signature = await _getSignatureAsBase64();
    Map<String, dynamic> updatedData = {
      'mangementName': controllerManagment.text,
      'userName': controllerUserName.text,
      'jobNumber': controllerNumber.text,
      'vehicleNumber': controllerCarNumber.text,
      'vehicleType': controllerCarType.text,
      'driverName': controllerDriverName.text,
      'escortsNames': [controllerEscorts.text],
      'notes': controllerNote.text,
      'companyName': controllerCompanyName.text,
      'route': controllerAddress.text,
      'startDate': controllerStartDate.text,
      'endDate': controllerEndDate.text,
      'leaveTime': controllerLeaveTime.text,
      'returnTime': controllerReturnTime.text,
      'signatureText': signature ?? signatureBase64,
    };

    try {
      if (widget.driverData != null) {
        String documentId = widget.driverData!['id'];

        await FirebaseFirestore.instance
            .collection('drivers')
            .doc(documentId)
            .set(updatedData, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data updated successfully')),
        );
        setState(() {
          widget.driverData = updatedData;
        });
      }
    } catch (e) {
      print("Error updating data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update data')),
      );
    }
  }

  @override
  void initState() {
    if (widget.driverData != null) {
      controllerManagment.text = widget.driverData!['mangementName'] ?? '';
      controllerUserName.text = widget.driverData!['userName'] ?? '';
      controllerNumber.text = widget.driverData!['jobNumber'] ?? '';
      controllerCarNumber.text = widget.driverData!['vehicleNumber'] ?? '';
      controllerCarType.text = widget.driverData!['vehicleType'] ?? '';
      controllerDriverName.text = widget.driverData!['driverName'] ?? '';
      controllerEscorts.text = widget.driverData!['escortsNames'][0] ?? '';
      controllerNote.text = widget.driverData!['notes'] ?? '';
      controllerCompanyName.text = widget.driverData!['companyName'] ?? '';
      controllerAddress.text = widget.driverData!['route'] ?? '';
      controllerStartDate.text = widget.driverData!['startDate'] ?? '';
      controllerEndDate.text = widget.driverData!['endDate'] ?? '';
      controllerLeaveTime.text = widget.driverData!['leaveTime'] ?? '';
      controllerReturnTime.text = widget.driverData!['returnTime'] ?? '';
      signatureBase64 = widget.driverData!['signatureText'];
    }

    super.initState();
  }

  Image _getImageFromBase64(String base64String) {
    final Uint8List bytes = base64Decode(base64String);
    return Image.memory(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple[100],
        title: const Center(
          child: Text(
            "Work Order",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ListTile(
                  trailing: const Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: "المصرية",
                        style: TextStyle(
                            color: Color.fromARGB(255, 123, 30, 139),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "للاتصالات",
                        style: TextStyle(
                            fontSize: 19,
                            color: Color.fromARGB(255, 123, 30, 139)),
                      )
                    ]),
                    style: TextStyle(fontSize: 14),
                  ),
                  leading: Image.asset(
                    "images/we.jpg",
                  ),
                ),
                const SizedBox(height: 10),
                const Column(
                  children: [
                    Text(
                      " الشركه المصرية للاتصالات وشركاتها التابعة ",
                      style: TextStyle(
                          decoration: TextDecoration.underline, fontSize: 20),
                    ),
                    Text(
                      "امر شغل تحركات السيارات المؤجرة",
                      style: TextStyle(
                          decoration: TextDecoration.underline, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StackData(
                        label: ":  الأدارة الطالبة ",
                        controller: controllerManagment,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Field is required'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      StackData(
                        label: ": اسم مستخدم المركبة",
                        controller: controllerUserName,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Field is required'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      StackData(
                        label: ": الرقم الوظيفي",
                        controller: controllerNumber,
                        numberType: true,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Field is required'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Table(
                        border: TableBorder.all(),
                        children: <TableRow>[
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                label: ": نوعها",
                                controller: controllerCarType,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Field is required'
                                        : null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                label: ": رقم المركبة",
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Field is required'
                                        : null,
                                controller: controllerCarNumber,
                                numberType: true,
                              ),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: StakeDateField(
                                label: ": تاريخ انتهاء المأمورية",
                                controller: controllerEndDate,
                                showDate: true,
                                size: 13,
                                numberType: true,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Field is required'
                                        : null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: StakeDateField(
                                label: ": تاريخ بدء المأمورية",
                                controller: controllerStartDate,
                                showDate: true,
                                size: 13,
                                numberType: true,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Field is required'
                                        : null,
                              ),
                            ),
                          ]),
                        ],
                      ),
                      Table(
                        border: TableBorder.all(),
                        children: <TableRow>[
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                label: ": توقيت العودة",
                                controller: controllerReturnTime,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Field is required'
                                        : null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                label: ": توقيت الخروج",
                                controller: controllerLeaveTime,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Field is required'
                                        : null,
                              ),
                            ),
                          ])
                        ],
                      ),
                      Table(
                        border: TableBorder.all(),
                        children: <TableRow>[
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                label: ": اسم السائق",
                                controller: controllerDriverName,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Field is required'
                                        : null,
                              ),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                label: ": خط السير بالتفصيل",
                                controller: controllerAddress,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Field is required'
                                        : null,
                              ),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                  label: ": اسم المرافقين",
                                  controller: controllerEscorts,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field is required';
                                    }
                                    return null;
                                  }),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                  label: ": ملاحظات",
                                  controller: controllerNote,
                                  validator: (value) {
                                    return null;
                                  }),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        if (signatureBase64 != null)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: _getImageFromBase64(
                                                signatureBase64!),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "توقيع مستخدم المركبة",
                                    style: TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                label: ": اسم الشركة المنفذة",
                                controller: controllerCompanyName,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Field is required'
                                        : null,
                              ),
                            ),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _updateDriverData();
                              // _clearFields();
                            }
                          },
                          child: const Text(
                            " حفظ و ارسال",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
