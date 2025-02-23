import 'package:admin_pannel/provider/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
class StudentFeesList extends StatefulWidget {
  const StudentFeesList({super.key, required this.stuClass, required this.section});

  final String stuClass;
  final String section;

  @override
  State<StudentFeesList> createState() => _StudentFeesListState();
}

class _StudentFeesListState extends State<StudentFeesList> {
  TextEditingController searchNameController = TextEditingController();
  TextEditingController searchRollController = TextEditingController();

  late List<Map<String, String>> students;
  List<Map<String, String>> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    students = [
      {'name': 'John Doe', 'roll': '1', 'pendingFees': '500', 'totalFees': '2000', 'paidFees': '1500'},
      {'name': 'Jane Smith', 'roll': '2', 'pendingFees': '300', 'totalFees': '2000', 'paidFees': '1700'},
      {'name': 'Sam Wilson', 'roll': '3', 'pendingFees': '0', 'totalFees': '2000', 'paidFees': '2000'},
    ];
    filteredStudents = students;
  }

  void searchStudents() {
    String nameQuery = searchNameController.text.toLowerCase();
    String rollQuery = searchRollController.text.toLowerCase();

    setState(() {
      filteredStudents = students.where((student) {
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
                Expanded(child: filterTextField(title: "Search by Name", control: searchNameController)),
                Expanded(child: filterTextField(title: "Search by Roll Number", control: searchRollController)),
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
                      bool isPaid = student['pendingFees'] == '0';

                      return DataRow(
                        cells: [
                          DataCell(Text(student['roll']!, style: const TextStyle(color:  Colors.black ,))),
                          DataCell(Text(student['name']!, style: const TextStyle(color:  Colors.black ))),
                          DataCell(Text(student['pendingFees']!, style: const TextStyle(fontSize: 16,color: Colors.red, fontWeight: FontWeight.bold))),
                          DataCell(Text(student['totalFees']!, style: const TextStyle(fontSize: 16,color: Colors.blue, fontWeight: FontWeight.bold))),
                          DataCell(Text(student['paidFees']!, style:  TextStyle(fontSize: 16,color: primaryGreenColors, fontWeight: FontWeight.bold))),
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
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              onPressed: () {
                                customNvigation(context, '/fees-updation/sectionWiseFeesUpdation/studentFeesList/studentFeesUpdation?classNumber=${widget.stuClass}&sectionName=${widget.section}&name=${student['name']!}');
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Update Fees', style: TextStyle(fontSize: 14)),
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

  Widget filterTextField({required String title, required TextEditingController control}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: control,
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
