import 'package:admin_pannel/utils/ExceptionDialod.dart';

import '../../../../contant/CustomNavigation.dart';
import '../../../../controller/classControllers/pageControllers/ExamUpdationController.dart';
import '../../../widget/CustomeButton.dart';
import '../../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst;

class StudentExamResultPublish extends StatefulWidget {
  const StudentExamResultPublish({super.key, required this.examName, required this.stuClass, required this.section});
final  String stuClass;
  final String examName;
  final String section;

  @override
  State<StudentExamResultPublish> createState() => _StudentExamResultPublishState();
}

class _StudentExamResultPublishState extends State<StudentExamResultPublish> {
 late  TextEditingController searchNameController ;
  late TextEditingController searchRollController ;
  late TextEditingController totalSubjectMarkController ;
  late TextEditingController singleSubjectMarkController ;
  bool showTotalSaveButton = false;
  bool showSingleSaveButton = false;
  List<Map<String, dynamic>> students =[];
  List<Map<String, dynamic>> filteredStudents = [];
  late ExamUpdationController controller;
  String? totalMark;
  String? overallMark;
final ScrollController _scrollController = ScrollController();

@override
void initState() {
  super.initState();
  controller = Get.find<ExamUpdationController>();
  // Initialize all controllers before using them
  searchNameController = TextEditingController();
  searchRollController = TextEditingController();
  totalSubjectMarkController = TextEditingController(text: totalMark ?? '0');
  singleSubjectMarkController = TextEditingController(text: overallMark ?? '0');

  // Now add the listeners
  totalSubjectMarkController.addListener(() => checkSaveButtonVisibility(true));
  singleSubjectMarkController.addListener(() => checkSaveButtonVisibility(false));
_scrollController.addListener(()async {
  if (_scrollController.position.pixels ==
      _scrollController.position.maxScrollExtent) {
   await ExceptionDialog().handleExceptionDialog(context,()async=> controller.getFilteredStudents(context,
      className: widget.stuClass,section: widget.section
    ));
  }
});

  // Initialize students and fetch details
  filteredStudents = students;
  initStudent();
  fetchDetails();
}


void initStudent() async {
  List<Map<String, dynamic>>? studentData = await ExceptionDialog().handleExceptionDialog(context,()async=>await controller.getFilteredStudents(context,
    className: widget.stuClass,
    section: widget.section,
  ));

  setState(() {
    students = studentData!;
     filteredStudents = studentData; 
  });
}

Future<void> fetchDetails() async {
  final data = await ExceptionDialog().handleExceptionDialog(context,()async=>await controller.getTotalAndIndividualSubjectMark(context,
    className: widget.stuClass,
    examType: widget.examName,
    section: widget.section,
  ));

  setState(() {
    totalMark = data!["total_mark"];
    overallMark = data["outoff_mark"];
    totalSubjectMarkController.text = totalMark ?? '0';
    singleSubjectMarkController.text = overallMark ?? '0';
  });
}

  void checkSaveButtonVisibility(bool isTotal) {
    setState(() {
      if (isTotal) {
        showTotalSaveButton = totalSubjectMarkController.text != totalMark;
      } else {
        showSingleSaveButton = singleSubjectMarkController.text !=  overallMark;
      }
    }); 
  }

void applyFilters()
{
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

Future<void> addAndUpdateTotalandSingleMark()async{
  
}
@override
void dispose() {
  filteredStudents.clear();
  searchNameController.dispose();
  searchRollController.dispose();
  totalSubjectMarkController.dispose();
  singleSubjectMarkController.dispose();
  _scrollController.dispose();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                     customIconNavigation(context, '/exam-Details-updation/sectionWiseResultPublishment?examName=${widget.examName}'),
                  const  SizedBox( width: 20,),
                   const Text(" Filter Student by :", style:  TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      ),),
                    Expanded(
                      child: filterTextField(title: "Search by Name", control: searchNameController,  onChanged: (String? value) => applyFilters())
                    ),
                   
                    Expanded(
                      child: filterTextField(title: "Search by Roll Number", control: searchRollController, onChanged: (String? value) => applyFilters())
                    ),
                    const SizedBox(width: 8),
                    customIconTextButton(Colors.blue,
                    icon: Icons.search, onPressed: applyFilters, text: "Search"),
                           
                    
                  ],
                ),
               const SizedBox(height: 10),
                Row(
                  children: [
                 const    SizedBox(width: 70),
                  const  SizedBox(
                      width: 100,
                      child: Text('Total subject mark :', overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                         markFied(control: totalSubjectMarkController),
                          if (showTotalSaveButton)
                            ElevatedButton(
                              onPressed: ()async {
                             await ExceptionDialog().handleExceptionDialog(context,()async=>   await controller.addUpdateTotalAndIndividualSubject(context,
                                  className: widget.stuClass,
                                  examType: widget.examName,
                                  outOffMark: singleSubjectMarkController.text.toString(),
                                  section: widget.section,
                                  totalMark:totalSubjectMarkController.text.toString(), 
                                ));
                                setState(() {
                                  showTotalSaveButton = false;
                                });

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white
                              ),
                              child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.save, size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text("Save", style: TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                            ),
                        ],
                      ),
                    ),
                   const SizedBox(width: 8),
                   const SizedBox(
                      width: 100,
                      child: Text('Individual subject Total mark :', overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),)),
                
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                         markFied(control: singleSubjectMarkController),
                          if (showSingleSaveButton)
                             ElevatedButton(
                              onPressed: ()async {
                               await ExceptionDialog().handleExceptionDialog(context,()async=> await controller.addUpdateTotalAndIndividualSubject(context,
                                  className: widget.stuClass,
                                  examType: widget.examName,
                                  outOffMark: singleSubjectMarkController.text.toString(),
                                  section: widget.section,
                                  totalMark:totalSubjectMarkController.text.toString(), 
                               ));
                                setState(() {
                                  showSingleSaveButton = false;
                                });

                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white
                              ),
                              child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.save, size: 16, color: Colors.white),
                          SizedBox(width: 4),
                          Text("Save", style: TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                            ),
                        ],
                      ),
                    ),
                  const   SizedBox(width: 70),

                  ],
                ),
                
         const   SizedBox(height: 30),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                    controller: _scrollController, 
                child: Container(
                    padding: const EdgeInsets.all(8),
             width: MediaQuery.of(context).size.width ,
                  child: DataTable(
                    columns:const [
                      
                      DataColumn(label: Text('Roll No.', style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                      DataColumn(label: Text('Name', style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                      DataColumn(label: Text('Class', style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                      DataColumn(label: Text('Section', style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                      DataColumn(label: Text('Action', style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    ],
                    rows: filteredStudents.map((student) {
                      return DataRow(cells: [
                        
                        DataCell(SizedBox( 
                          width: MediaQuery.sizeOf(context).width*0.07,
                          child: Text(student['roll']!,style:const TextStyle(color: Colors.black)))),
                        DataCell(SizedBox(
                          width: MediaQuery.sizeOf(context).width*0.25,
                          child: Text(student['name']!,style: const TextStyle(color: Colors.black)))),
                        DataCell(Text(widget.stuClass,style:const TextStyle(color: Colors.black))),
                        DataCell(Text(widget.section,style:const TextStyle(color: Colors.black))),
                         DataCell(Padding(
                           padding: const EdgeInsets.all(5.0),
                           child: ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               backgroundColor: primaryGreenColors,
                               foregroundColor: Colors.white,
                                elevation: 10, // Elevation for shadow effect
                               padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 12), // Button padding
                               shape: RoundedRectangleBorder(
                                 borderRadius:
                                     BorderRadius.circular(20), // Rounded corners
                               ),
                             ),
                             onPressed: () {
                               customNvigation(
                                 context, '/exam-Details-updation/sectionWiseResultPublishment/studentOverview/student?examName=${widget.examName}&class=${widget.stuClass}&section=${widget.section}&name=${student['name']!}&id=${student["id"]}&singleSubjectMark=${singleSubjectMarkController.text.toString()}');
                                                 
                             },
                             child:const Row(
                               children: [
                                  Text('Publish Result', style: TextStyle(
                                   fontSize: 14
                                 ),),
                                 Padding(
                                   padding: EdgeInsets.all(8.0),
                                   child: Icon(Icons.arrow_forward,color: Colors.white,),
                                 )
                               ],
                             ),
                           ),
                         )),
                      ]);
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

  Widget filterTextField(  {required title , required TextEditingController control ,required ValueChanged<String?> onChanged })
  {
 return  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged:onChanged ,
                      controller: control,
                      decoration:  InputDecoration(
                  labelText: title,
                  labelStyle:const TextStyle(
                    color: Colors.black
                  ),
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
                    ),
                  );
  }

Widget markFied({required TextEditingController control})
{
  return  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: control,
                          keyboardType: TextInputType.number,
                                       decoration:  InputDecoration(
                                         
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
                        ),
                      );
}

}


