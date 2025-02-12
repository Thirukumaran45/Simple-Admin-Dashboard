import 'package:admin_pannel/controller/StudentController.dart';
import 'package:admin_pannel/views/widget/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentDetailsTab extends StatefulWidget {
  const StudentDetailsTab({super.key});

  @override
  State<StudentDetailsTab> createState() => _StudentDetailsTabState();
}

class _StudentDetailsTabState extends State<StudentDetailsTab> {
  String? selectedClass = "All";
  String? selectedSection = "All";
  String rollNumber = '';
  String name = '';

  final StudentController controler = Get.find();

  List<Map<String, String>> filteredData = [];
 
  @override
  void initState() {
    super.initState();
    filteredData = List.from(controler.studentData);
  }

  void applyFilters() {
    setState(() {
      filteredData = controler.studentData.where((student) {
        final matchesClass =
            selectedClass == "All" || student['class'] == selectedClass;
        final matchesSection =
            selectedSection == "All" || student['section'] == selectedSection;
        final matchesRollNumber =
            rollNumber.isEmpty || student['rollNumber']!.contains(rollNumber);
        final matchesName = name.isEmpty ||
            student['name']!.toLowerCase().contains(name.toLowerCase());
        return matchesClass &&
            matchesSection &&
            matchesRollNumber &&
            matchesName;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      
        Row(
          crossAxisAlignment: CrossAxisAlignment.center, 
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [ 
            
      customIconNavigation(context, '/manage-student'),
            const
            Text(" Filter by : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
            Container(
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: primaryGreenColors, width: 1),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(20),
                dropdownColor: Colors.white,
                hint: const Text(
                  'Select Class',
                  style: TextStyle(color: Colors.black),
                ),
                value: selectedClass,
                items: [
                  "All",
                  ...List.generate(12, (index) => (index + 1).toString())
                ]
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e == "All" ? "All Classes" : "Class $e",
                          style: const TextStyle(color: Colors.black),
                        )))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedClass = value;
                  });
                },
              ),
            ),
            Container(
              width: 150,
              decoration: BoxDecoration(
                border: Border.all(color: primaryGreenColors, width: 1),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(20),
                dropdownColor: Colors.white,
                hint: const Text(
                  'Select Section',
                  style: TextStyle(color: Colors.black),
                ),
                value: selectedSection,
                items: ["All", 'A', 'B', 'C', 'D']
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e == "All" ? "All Sections" : "Section $e",
                          style: const TextStyle(color: Colors.black),
                        )))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSection = value;
                  });
                },
              ),
            ),
            SizedBox(
              width: 150,
              child: TextField(
                decoration:  InputDecoration(
                  labelText: 'Search by Roll.No',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    rollNumber = value;
                  });
                },
              ),
            ),
            SizedBox(
              width: 150,
              child: TextField(
                decoration:  InputDecoration(
                  labelText: 'Search by Name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
            ),
            customIconTextButton(Colors.blue,
                icon: Icons.search, onPressed: applyFilters, text: "Search"),
            customIconTextButton(primaryGreenColors,
                icon: Icons.download_sharp,
                onPressed: applyFilters,
                text: "Download"),
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
                  DataColumn(
                      label: Text(
                    'Roll Number',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                  DataColumn(
                      label: Text('Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                  DataColumn(
                      label: Text('Class',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                  DataColumn(
                      label: Text('Section',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                  DataColumn(
                      label: Text('Parent Mobile',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                  DataColumn(
                      label: Text('Update',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                  DataColumn(
                      label: Text('Delete',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))),
                ],
                rows: filteredData.map((student) {
                  return DataRow(
                    cells: [
                      DataCell(Text(student['rollNumber']!)),
                      DataCell(Text(student['name']!)),
                      DataCell(Text(student['class']!)),
                      DataCell(Text(student['section']!)),
                      DataCell(Text(student['parentMobile']!)),
                      DataCell(SizedBox(width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreenColors,
                            foregroundColor: Colors.white,
                             elevation: 10, // Elevation for shadow effect
                            padding: const EdgeInsets.symmetric(
                                 horizontal: 16, vertical: 12), // Button padding
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                            ),
                          ),
                          onPressed: () {
                         Beamer.of(context).beamToNamed('/manage-student/viewStudentDetails/editStudentDetails');
    
                          },
                          child: const Text('View More', style: TextStyle(
                            fontSize: 14
                          ),),
                        ),
                      )),
                      DataCell(SizedBox(width:150 ,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Colors.red, // Button background color
                            elevation: 10, // Elevation for shadow effect
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12), // Button padding
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                            ),
                          ),
                          onPressed: () {
                            // Implement view more functionality
                          },
                          child: const Row(
                            children: [ Icon(Icons.delete_sharp , color: Colors.white,),
                               Text(' Delete', style: TextStyle(fontSize: 14),),
                            ],
                          ),
                        ),
                      )),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
