import 'package:admin_pannel/controller/AttendanceController.dart';
import 'package:admin_pannel/views/widgets/peoples/widgets/CustomeButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceDownloadPage extends StatefulWidget {
  const AttendanceDownloadPage({super.key});

  @override
  State<AttendanceDownloadPage> createState() => _AttendanceDownloadPageState();
}

class _AttendanceDownloadPageState extends State<AttendanceDownloadPage> {
  String? selectedDate;
  String? selectedMonth;
  String rollNumber = '';
  String name = '';

  final AttendanceController controler = Get.find();
  Map<int, bool> showSaveButton = {}; // Track changed attendance
  List<Map<String, String>> filteredData = [];

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    selectedMonth = DateFormat('MMMM').format(now);
    selectedDate = DateFormat('yyyy-MM-dd').format(now);
    filteredData = List.from(controler.studentData);
    applyFilters();
  }

  void applyFilters() {
    setState(() {
      filteredData = controler.studentData.where((student) {
        final matchesDate = selectedDate == null || student['date'] == selectedDate;
        final matchesMonth = selectedMonth == null || student['month'] == selectedMonth;
        final matchesRollNumber = rollNumber.isEmpty || student['rollNumber']!.contains(rollNumber);
        final matchesName = name.isEmpty || student['name']!.toLowerCase().contains(name.toLowerCase());
        return matchesDate && matchesMonth && matchesRollNumber && matchesName;
      }).toList();
    });
  }

  void toggleAttendance(int index) {
    setState(() {
      filteredData[index]['attendanceStatus'] =
          filteredData[index]['attendanceStatus'] == 'Present' ? 'Absent' : 'Present';
      showSaveButton[index] = true; // Show save button only when changed

    });
  }
  void saveAttendance(int index) {
    setState(() {
      showSaveButton[index] = false; // Hide save button after saving
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Filter by Options :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                padding: const EdgeInsets.symmetric(horizontal: 10),

                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(20),
                    dropdownColor: Colors.white,
                    hint: const Text('Select Date', style: TextStyle(color: Colors.black)),
                    value: selectedDate,
                    items: controler.studentData.map((e) => e['date']).toSet().map((date) {
                      return DropdownMenuItem(value: date, child: Text(date!));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDate = value;
                      });
                      applyFilters();
                    },
                  ),
                ),
                Container(
                  width: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1),
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                padding: const EdgeInsets.symmetric(horizontal: 10),

                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(20),
                    dropdownColor: Colors.white,
                    hint: const Text('Select Month', style: TextStyle(color: Colors.black)),
                    value: selectedMonth,
                    items: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value;
                      });
                      applyFilters();
                    },
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Search Name',                     border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                      applyFilters();
                    },
                  ),
                ),
                customIconTextButton(Colors.blue, icon: Icons.search, onPressed: applyFilters, text: "Search"),
                customIconTextButton(Colors.green, icon: Icons.download_sharp, onPressed: applyFilters, text: "Download"),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  width: double.infinity,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Roll Number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      DataColumn(label: Text('Attendance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      DataColumn(label: Text('Edit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                      DataColumn(label: Text('Status',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),

                    ],
                    rows: List.generate(filteredData.length, (index) {
                      return DataRow(
                        cells: [
                          DataCell(Text(filteredData[index]['rollNumber']!)),
                          DataCell(Text(filteredData[index]['name']!)),
                          DataCell(Text(filteredData[index]['attendanceStatus']!,style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold, color:filteredData[index]['attendanceStatus']! =="Present" ? Colors.green:Colors.red ),)),
                          DataCell(
                            Row(
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: ElevatedButton(
                                    onPressed: () => toggleAttendance(index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent
                                    ),
                                    child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                      children: [
                                        Icon(Icons.swap_horiz_sharp,size: 35,color: Colors.white,),
                                        Text('Change',style: TextStyle(
                                          fontSize: 18 , color: Colors.white
                                        ),),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          DataCell(
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              height: 50,width: 120
                                              ,child:                                                 showSaveButton[index] == true?
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: () => saveAttendance(index),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                      child: const Text('Save', style: TextStyle(fontSize: 18, color: Colors.white)),
                                    ),
                                  ): const Center(child: Text("Updated",style: TextStyle(fontSize: 18,color: Colors.grey),)),)

                          ),

                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


