import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/controller/classControllers/pageControllers/FessController.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst,Worker,ever;
class StudentFeesList extends StatefulWidget {
  const StudentFeesList({super.key, required this.stuClass, required this.section});

  final String stuClass;
  final String section;

  @override 
  State<StudentFeesList> createState() => _StudentFeesListState();
}

class _StudentFeesListState extends State<StudentFeesList> {
  late TextEditingController searchNameController ;
  late TextEditingController searchRollController ;
late Worker studentDataWorker;
  List<Map<String, dynamic>> filteredStudents = [];
  late FeesController controller;
  @override
  void initState() {
    super.initState();
      searchNameController = TextEditingController();
   searchRollController = TextEditingController();
    controller=Get.find<FeesController>();
   initializeData();
  }

void initializeData() async {
  await controller.fetchStudentData(stuClass: widget.stuClass, stuSec: widget.section);
  
  if (mounted) {
    setState(() {
      filteredStudents = List.from(controller.studentData);
    });
  }

  studentDataWorker  = ever(controller.studentData, (_) {
    if (mounted) {
      setState(() {
        filteredStudents = List.from(controller.studentData);
      });
    }
  });
}

@override
void dispose() {
     searchNameController .dispose();
   searchRollController.dispose();
   filteredStudents.clear();
  studentDataWorker.dispose(); // dispose your `ever` listener
  super.dispose();
}
  void searchStudents() {
    String nameQuery = searchNameController.text.toLowerCase();
    String rollQuery = searchRollController.text.toLowerCase();

    setState(() {
      filteredStudents = controller.studentData.where((student) {
        bool matchesName = nameQuery.isEmpty || student['name']!.toLowerCase().contains(nameQuery);
        bool matchesRoll = rollQuery.isEmpty || student['roll']!.toLowerCase().contains(rollQuery);
        return matchesName && matchesRoll;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                customIconNavigation(context, '/fees-updation/sectionWiseFeesUpdation'),
                const SizedBox(width: 20),
                const Text("Filter Student by :", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
                Expanded(child: filterTextField(title: "Search by Name", control: searchNameController, onChanged: (val ) =>searchStudents())),
                Expanded(child: filterTextField(title: "Search by Roll Number", control: searchRollController,onChanged: (val ) =>searchStudents())),
                const SizedBox(width: 8),
                customIconTextButton(Colors.blue, icon: Icons.search, onPressed: searchStudents, text: "Search"),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Roll No.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      DataColumn(label: Text('Pending Fees', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      DataColumn(label: Text('Total Fees', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      DataColumn(label: Text('Paid Fees', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      DataColumn(label: Text('Fees Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))), // New column
                      DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    ],
                    rows: filteredStudents.map((student) {
                      bool isPaid = student['status'] == 'Paid';

                      return DataRow(
                        cells: [
                          DataCell(SizedBox(
                            width: MediaQuery.sizeOf(context).width*0.05,child: Text(student['roll']!, style: const TextStyle(color:  Colors.black ,)))),
                          DataCell(SizedBox(
                            width: MediaQuery.sizeOf(context).width*0.09,child: Text(student['name']!, style: const TextStyle(color:  Colors.black )))),
                          DataCell(Text("₹${student['pendingFees']!}", style: const TextStyle(fontSize: 16,color: Colors.red, fontWeight: FontWeight.bold))),
                          DataCell(Text("₹${student['totalFees']!}", style: const TextStyle(fontSize: 16,color: Colors.blue, fontWeight: FontWeight.bold))),
                          DataCell(Text("₹${student['paidFees']!}", style:  TextStyle(fontSize: 16,color: primaryGreenColors, fontWeight: FontWeight.bold))),
                          DataCell(
                            Container(
                              height: 38,
                              width: 80,
                              decoration: BoxDecoration(
                                color: isPaid ? primaryGreenColors : Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                
                                child: Text(
                                  isPaid ? 'Paid' : 'Unpaid',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold,letterSpacing: 1),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreenColors,
                                foregroundColor: Colors.white,
                                elevation: 10,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () {
                                customNvigation(context, '/fees-updation/sectionWiseFeesUpdation/studentFeesList/studentFeesUpdation?classNumber=${widget.stuClass}&sectionName=${widget.section}&name=${student['name']}&id=${student['id']}');
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Update Fees',),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.arrow_forward, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterTextField({required String title, required TextEditingController control, required Function(String)?  onChanged}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: control,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: const TextStyle(color: Colors.black),
          border: OutlineInputBorder(borderSide: BorderSide(color: primaryGreenColors)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryGreenColors)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryGreenColors)),
        ),
      ),
    );
  }
}
