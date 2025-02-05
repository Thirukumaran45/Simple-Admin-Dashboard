import 'package:admin_pannel/controller/StudentController.dart';
import 'package:admin_pannel/views/widgets/peoples/Students/Widgets/StudentEditDownload.dart';
import 'package:admin_pannel/views/widgets/peoples/widgets/CustomeButton.dart';
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [ const
              Text(" Filter by Options : ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
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
                  border: Border.all(color: Colors.green, width: 1),
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
                  decoration: const InputDecoration(
                    labelText: 'Search by Roll.No',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
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
                  decoration: const InputDecoration(
                    labelText: 'Search by Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
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
              customIconTextButton(Colors.green,
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
                            onPressed: () {
                            showDialog(
  context: context,
  builder: (BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Main content of the dialog
          Container(
            width: MediaQuery.of(context).size.width * 0.6, // 80% of the screen width
            height: MediaQuery.of(context).size.height * 1, // 80% of the screen height
            padding: const EdgeInsets.all(20
            ),
            child: const StudentEditDownload(),
          ),
          // Close button at the top-right corner
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  },
);

                            },
                            child: const Text('View More'),
                          ),
                        )),
                        DataCell(SizedBox(width:150 ,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
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
                                 Text(' Delete'),
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
      ),
    );
  }
}
