import 'package:admin_pannel/provider/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';

class StudentExamResultPublish extends StatefulWidget {
  const StudentExamResultPublish({super.key, required this.examName, required this.stuClass, required this.section});
final  String stuClass;
  final String examName;
  final String section;

  @override
  State<StudentExamResultPublish> createState() => _StudentExamResultPublishState();
}

class _StudentExamResultPublishState extends State<StudentExamResultPublish> {
  TextEditingController searchNameController = TextEditingController();
  TextEditingController searchRollController = TextEditingController();
  TextEditingController totalSubjectMarkController = TextEditingController(text: '0.0');
  TextEditingController singleSubjectMarkController = TextEditingController(text: '0.0');
  bool showTotalSaveButton = false;
  bool showSingleSaveButton = false;
  late List<Map<String, String>> students;
  List<Map<String, String>> filteredStudents = [];

  @override
  void initState() {
    super.initState();
     students = [
{'name': 'John Doe', 'roll': '1', 'class': widget.stuClass, 'section': widget.section},
    {'name': 'Jane Smith', 'roll': '2', 'class': widget.stuClass, 'section': widget.section},
    {'name': 'Sam Wilson', 'roll': '3', 'class': widget.stuClass, 'section': widget.section},
  ];
    filteredStudents = students;
    totalSubjectMarkController.addListener(() => checkSaveButtonVisibility(true));
    singleSubjectMarkController.addListener(() => checkSaveButtonVisibility(false));
  }

  void checkSaveButtonVisibility(bool isTotal) {
    setState(() {
      if (isTotal) {
        showTotalSaveButton = totalSubjectMarkController.text != '0.0';
      } else {
        showSingleSaveButton = singleSubjectMarkController.text != '0.0';
      }
    }); 
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
                      child: filterTextField(title: "Search by Name", control: searchNameController, )
                    ),
                   
                    Expanded(
                      child: filterTextField(title: "Search by Roll Number", control: searchRollController)
                    ),
                    const SizedBox(width: 8),
                    customIconTextButton(Colors.blue,
                    icon: Icons.search, onPressed: searchStudents, text: "Search"),
                           
                    
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
                              onPressed: () {
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
                        children: [
                         markFied(control: singleSubjectMarkController),
                          if (showSingleSaveButton)
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showSingleSaveButton = false;
                                });
                              },
                              child:  const Text('Save'),
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
                        
                        DataCell(Text(student['roll']!,style:const TextStyle(color: Colors.black))),
                        DataCell(Text(student['name']!,style: const TextStyle(color: Colors.black))),
                        DataCell(Text(student['class']!,style:const TextStyle(color: Colors.black))),
                        DataCell(Text(student['section']!,style:const TextStyle(color: Colors.black))),
                         DataCell(SizedBox(width: 170,
                          child: Padding(
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
                                customNvigation(context, '/exam-Details-updation/sectionWiseResultPublishment/studentOverview/student?examName=${widget.examName}&class=${widget.stuClass}&section=${widget.section}&name=${student['name']!}');
                                                  
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

  Widget filterTextField(  {required title , required TextEditingController control  })
  {
 return  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
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


