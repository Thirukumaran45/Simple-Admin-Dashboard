
import '../../../../contant/constant.dart';
import '../../../../controller/classControllers/peoplesControlelr/StudentListBonafiedControlelr.dart';
import '../../../../contant/CustomNavigation.dart';
import '../../../../contant/pdfApi/PdfBonafied.dart';
import '../../../widget/CustomeButton.dart';
import '../../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst,ever;

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

  late StudentlistBonafiedController controler ;
final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> filteredData = [];
 
 @override
void initState() {
  super.initState();
  controler = Get.find<StudentlistBonafiedController>();
  
   setState(() {
      filteredData = List.from(controler.studentData);
    });
    _scrollController.addListener(() {
  if (_scrollController.position.pixels ==
      _scrollController.position.maxScrollExtent) {
    controler.fetchStudentData();
  }
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
void dispose() {
  filteredData.clear();
  controler.dispose();
  _scrollController.dispose();
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
    items: ["Current Academic", "Out Passing Student"]
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
                        DataCell(SizedBox(
                          width: MediaQuery.sizeOf(context).width*0.07,
                          child: Text(student['rollNumber']!, style: const TextStyle(color: Colors.black),))),
                        DataCell(SizedBox(
                          width: MediaQuery.sizeOf(context).width*0.14,
                          child: Text(student['name']!,style: const TextStyle(color: Colors.black),))),
                        DataCell(Text(student['class']!,style: const TextStyle(color: Colors.black),)),
                        DataCell(Text(student['section']!,style: const TextStyle(color: Colors.black),)),
                         DataCell(Container(
                              height: 38,
                              width: 80,
                              decoration: BoxDecoration(
                                color: student['feeStatus'] =="Paid" ? primaryGreenColors : Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                
                                child: Text(
                                  "${student['feeStatus']}",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal,letterSpacing: 1),
                                ),
                              ),
                            ),),
                      
                        
                        DataCell(ElevatedButton(
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
                          onPressed: () async{
                          await customSnackbar(context: context, text: "Donloaded Succesfully");
                         await PdfApi().openPdf(academicYear:'2024',fileName:student['name']!, studentName: student['name']!,parentName:'Raman.K', studentClass: '${student['class']!} - ${student['section']!}', dob: '04/12/2003', academicType:selectedTypevalue! );
                         
                        
                          },
                          child: const Text('Download Bonafied', style: TextStyle(
                            fontSize: 14
                          ),),
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
