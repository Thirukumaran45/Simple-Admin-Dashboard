
import 'package:admin_pannel/contant/constant.dart';
import 'package:admin_pannel/controller/classControllers/pageControllers/AttendanceController.dart';
import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/contant/pdfApi/PdfAttendance.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceDownloadPage extends StatefulWidget {
  final String section;
  final String classNUmber;
   const AttendanceDownloadPage({super.key, required this.section, required this.classNUmber});

  @override
  State<AttendanceDownloadPage> createState() => _AttendanceDownloadPageState();
}

class _AttendanceDownloadPageState extends State<AttendanceDownloadPage> {
  String? selectedDate;
  String? selectedMonth;
  String rollNumber = '';
  String name = '';
  String teacherName='';
  bool isLoading = true; 

  final AttendanceController controler = Get.find();

  Map<int, bool> showSaveButton = {}; 
 // Track changed attendance
  List<Map<String, dynamic>> filteredData = [];
  List<Map<String, dynamic>> studentData = [];
  AttendanceController controller = Get.find();
  List<String> month = [];
  List<String>date=[];
  @override
  void initState() { 
    super.initState();
    initializeList();
    selectedMonth = controler.gettodaymonth();
    selectedDate = controler.gettoadayDate();
    
 
   } 

void initializeList() async {
  List<String> monthVal = await controller.fetchUniqueMonthValuesAll();
  List<String> dateVal = await controller.fetchUniqueDateValuesAll();
  String name = await controler.getTeacherName(sec: widget.section,stuClass: widget.classNUmber);
  setState(() {
    date=dateVal;
    teacherName=name;
    month = monthVal;
  });

  final data = await controller.fetchStudentData();

  // Ensure the class number and section exist before accessing them
  if (data.containsKey(int.parse(widget.classNUmber)) &&
      data[int.parse(widget.classNUmber)]!.containsKey(widget.section)) {
    setState(() {
      studentData = data[int.parse(widget.classNUmber)]![widget.section]!;
      applyFilters();
    });
  } else {
    setState(() {
      studentData = [];
      applyFilters();
    });
  }

  setState(() {
    isLoading = false; // Stop loading after fetching data
  });
}


 void applyFilters() {
    setState(() {
      filteredData = studentData.where((student) {
        final matchesDate = selectedDate == null || student['date'] == selectedDate;
        final matchesMonth = selectedMonth == null || student['month'] == selectedMonth;
        final matchesName = name.isEmpty || student['name']!.toLowerCase().contains(name.toLowerCase());
        return matchesDate && matchesMonth  && matchesName;
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Padding(
            padding: const EdgeInsets.all(8.0),
            child: customIconNavigation(context, '/attendance/class?classNumber=${widget.classNUmber}')   ),
              const Text("Filter by Options :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
             
               _buildDropdown('Select Date', selectedDate,date, (value) {
                setState(() => selectedDate = value);
                applyFilters();
              }),
             
                 // Month Dropdown
              _buildDropdown('Select Month', selectedMonth, month, (value) {
                setState(() => selectedMonth = value);
                applyFilters();
              }),
              SizedBox(
                width: 150,
                child: TextField(
                  decoration:  InputDecoration(labelText: 'Search Name', 
                  labelStyle: const TextStyle(color: Colors.black,fontSize: 16),   
                     border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
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
              customIconTextButton(primaryGreenColors, icon: Icons.download_sharp, onPressed:()async{
                  await customSnackbar(context: context, text: "Donloaded Succesfully");
                await PdfAttendance.openPdf(absentCount: 30,date: selectedDate!,presentCount: 50,section: widget.section,
                studentClass: widget.classNUmber,students:filteredData,teacherName: teacherName  );
                applyFilters();
              } , text: "Download"),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
           child: isLoading
      ? const AlertDialog(         
          content: Row(
            children:  [
              Text("Please wait a moment",style: TextStyle(color: Colors.black,fontSize: 20),),
              SizedBox(width: 10),
              CircularProgressIndicator(),
            ],
          ),
        )
      :  SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Roll.Number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(label: Text('Attendance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(label: Text('Edit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(label: Text('Status',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      
                  ],
                  rows: List.generate(filteredData.length, (index) {
                    return DataRow(
                      cells: [
                        DataCell(Text(filteredData[index]['rollNumber']!,style: TextStyle(fontSize: 15,
                        
                        color: Colors.grey[850],
                      

                        ),)),
                        DataCell(Text(filteredData[index]['name']!, style: TextStyle(fontSize: 15,
                        
                        color: Colors.grey[850],
                      

                        ))),
                        DataCell(Text(filteredData[index]['attendanceStatus']!,style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold, color:filteredData[index]['attendanceStatus']! =="Present" ? const Color.fromARGB(255, 38, 153, 42):Colors.red ),)),
                        DataCell(
                          Row(
                            children: [
                              SizedBox(
                                height: 38,
                                width: 170,
                                child: ElevatedButton(
                                  onPressed: () => toggleAttendance(index),
                                  style: ElevatedButton.styleFrom(
                                      elevation: 10, // Elevation for shadow effect
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12), // Button padding
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                            ),
                                    backgroundColor: Colors.red
                                  ),
                                  child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      
                                    children: [
                                      Icon(Icons.swap_horiz_sharp,size: 27,color: Colors.white,),
                                      Text('Change',style: TextStyle(
                                        fontSize: 15 , color: Colors.white
                                      ),),
                                    ],
                                  ),
                                ),
                              ),
      
                            ],
                          ),
                        ),
                        DataCell(Container(
                                            padding: const EdgeInsets.all(5),
                                            height: 50,width: 120
                                            ,child:showSaveButton[index] == true?
                                SizedBox(
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () async{
                                      saveAttendance(index);
                                      await controler.updateAttendance(stuClass: widget.classNUmber
                                      , sec: widget.section, status: 
                                      filteredData[index]['attendanceStatus']);
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor:const Color.fromARGB(255, 38, 153, 42)),
                                    child: const Text('Save', style: TextStyle(fontSize: 16, color: Colors.white)),
                                  ),
                                ):  Center(child: Text("Updated",style: TextStyle(fontSize: 15,color: Colors.grey[850]),)),)
      
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
    );
  }

  
  Widget _buildDropdown(String hint, String? value, List<String?> items, ValueChanged<String?> onChanged) {
    return Container(
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
        hint: Text(hint, style: const TextStyle(color: Colors.black)),
        value: value,
        items: items.where((e) => e != null).map((date) {
                    return DropdownMenuItem(value: date, child: Text(date!));
                  }).toList(),
        onChanged: onChanged,
      ),
    );
  }

}


