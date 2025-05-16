import '../../../../../contant/constant.dart';
import '../../../../../controller/classControllers/peoplesControlelr/StudentController.dart';
import '../../../../../contant/CustomNavigation.dart';
import '../../../../../contant/pdfApi/PdfStudent/PdfTotalStudent.dart';
import '../../widgets/CustomeTextField.dart';
import '../../../../widget/CustomDialogBox.dart';
import '../../../../widget/CustomeButton.dart';
import '../../../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst,ever;

class StudentDetailsTab extends StatefulWidget {
  const StudentDetailsTab({super.key,});
 
  @override
  State<StudentDetailsTab> createState() => _StudentDetailsTabState();
}

class _StudentDetailsTabState extends State<StudentDetailsTab> {
  String? selectedClass = "All";
  String? selectedSection = "All";
  String rollNumber = '';
  String name = ''; 
final ScrollController _scrollController = ScrollController();

  late StudentController controler ;
 
  List<Map<String, dynamic>> filteredData = [];
 @override
void initState() {
  super.initState();
   controler = Get.find<StudentController>();
  _scrollController.addListener(() {
  if (_scrollController.position.pixels ==
      _scrollController.position.maxScrollExtent) {
    controler.fetchStudentData();
  }
});

   setState(() {
      filteredData = List.from(controler.studentData);
    });
  ever(controler.studentData, (_) {
    if (mounted) {
  setState(() {
    filteredData = List.from(controler.studentData);
  });
}
  });
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
void dispose() {        // Properly dispose of the GetX Worker
  filteredData.clear();     
   
   _scrollController.dispose();   // Clear the filtered list
  super.dispose();
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
              customFilterBox(label: "Search by name", onfunction: (value) {
                    setState(() {
                      name = value;
                    });
      
                 applyFilters();
                  },),
              customIconTextButton(Colors.blue,
                  icon: Icons.search, onPressed: applyFilters, text: "Search"),
              customIconTextButton(primaryGreenColors,
                  icon: Icons.download_sharp,
                  onPressed: ()async{
                    applyFilters();
                  await   customSnackbar(context: context, text: "Donloaded Succesfully");
                    
                   await  PdfTotalStudentDetails.openPdf(fileName:"Total Student Details - (${DateTime.now()})", students: filteredData);
                    
                  },
                  text: "Download"),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
                controller: _scrollController, 
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
                        DataCell(SizedBox(
                          width: MediaQuery.sizeOf(context).width*0.06,
                        
                          child: Text(student['rollNumber']!, style: const TextStyle(color: Colors.black),overflow: TextOverflow.ellipsis,))),
                        DataCell(SizedBox(
                          width: MediaQuery.sizeOf(context).width*0.14,
                          child: Text(student['name']!,style: const TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,),
                        )),
                        DataCell(Text(student['class']!,style: const TextStyle(color: Colors.black),)),
                        DataCell(Text(student['section']!,style: const TextStyle(color: Colors.black),)),
                        DataCell(Text(student['parentMobile']!,style: const TextStyle(color: Colors.black),)),
                      DataCell( 
  ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryGreenColors,
      foregroundColor: Colors.white,
      elevation: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    onPressed: () {
      customNvigation(context, '/manage-student/viewStudentDetails/editStudentDetails?uid=${student['id']!}');
    },
    child: const Text('View More', style: TextStyle(fontSize: 14)),
  ),
),

DataCell(
  ElevatedButton(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.red,
      elevation: 10,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
   onPressed: () async {
  bool val = await showCustomConfirmDialog(context: context, text: "Sure about to delete?");
  if (val) {
    await controler.deleteStudent(studentId: student['id']!, stuClass: student['class'], stuSec: student['section']);
   ever(controler.studentData, (_) {
    setState(() {
      filteredData = List.from(controler.studentData);
    });
  });
  }
},
    child: const Row(
      mainAxisSize: MainAxisSize.min, // Prevents Row overflow
      children: [
        Icon(Icons.delete_sharp, color: Colors.white),
        SizedBox(width: 5), // Adds space between icon and text
        Text('Delete', style: TextStyle(fontSize: 14)),
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
    );
  }
}


