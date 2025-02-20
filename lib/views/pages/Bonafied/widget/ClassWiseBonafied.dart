import 'package:admin_pannel/controller/StudentListBonafied.dart';
import 'package:admin_pannel/views/widget/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClasswiseBonafied extends StatefulWidget {
  const ClasswiseBonafied({super.key});

  @override
  State<ClasswiseBonafied> createState() => _ClasswiseBonafiedState();
}

class _ClasswiseBonafiedState extends State<ClasswiseBonafied> {
  String? selectedClass = "All";
  String? selectedSection = "All";
  String rollNumber = '';
  String? selectedTypevalue="Out Passing Student";

  final StudentlistBonafiedController controler = Get.find();

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
        return matchesClass &&
            matchesSection &&
            matchesRollNumber ;
      }).toList();
    });
  }

Widget customFilterBox  ( { required String label, required Function(String)?  onfunction })
{
  return  SizedBox(
              width: 150,
              child: TextField(
                decoration:  InputDecoration(
                  labelStyle:const TextStyle(color: Colors.black) ,
                  labelText: label,
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
                onChanged:onfunction
              ),
            );
} 


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
        
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, 
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [ 
              
        customIconNavigation(context, '/bonafied'),
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
                     applyFilters();
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
                     applyFilters();
                  },
                ),
              ),
             customFilterBox(label: "Search by Roll.no", onfunction:  (value) {
                    setState(() {
                      rollNumber = value;
                    });
                     applyFilters();
                  },),
Container(
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
      overflow: TextOverflow.ellipsis,
      'Select Academic Type',
      style: TextStyle(color: Colors.black),
    ),
    value: selectedTypevalue, // Ensure this value is in the dropdown items
    items: ["Current Academic Student", "Out Passing Student"]
        .map((e) => DropdownMenuItem(
            value: e,
            child: Text(
      overflow: TextOverflow.ellipsis,

              e,
              style: const TextStyle(color: Colors.black),
            )))
        .toList(),
    onChanged: (value) {
      setState(() {
        selectedTypevalue = value;
      });
      print("Selected: $value");
      applyFilters();
    },
  ),
),

             
              customIconTextButton(Colors.blue,
                  icon: Icons.search, onPressed: applyFilters, text: "Search"),

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
                        label: Text('Fees Status',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(
                        label: Text('Fees Status',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    ],
                  rows: filteredData.map((student) {
                    return DataRow(
                      cells: [
                        DataCell(Text(student['rollNumber']!, style: const TextStyle(color: Colors.black),)),
                        DataCell(Text(student['name']!,style: const TextStyle(color: Colors.black),)),
                        DataCell(Text(student['class']!,style: const TextStyle(color: Colors.black),)),
                        DataCell(Text(student['section']!,style: const TextStyle(color: Colors.black),)),
                        DataCell(Container(
                              height: 38,
                              width: 80,
                              decoration: BoxDecoration(
                                color: student['feesStatus'] =="Paid" ? primaryGreenColors : Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                
                                child: Text(
                                  "${student['feesStatus']}",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal,letterSpacing: 1),
                                ),
                              ),
                            ),),
                      
                        
                        DataCell(SizedBox(width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
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
                          
                            },
                            child: const Text('Download Bonafied', style: TextStyle(
                              fontSize: 14
                            ),),
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
