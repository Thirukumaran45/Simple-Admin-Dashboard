
import '../../../../contant/constant.dart';
import '../../../../controller/classControllers/pageControllers/AttendanceController.dart';
import '../../../../contant/CustomNavigation.dart';
import '../../../../contant/pdfApi/PdfAttendance.dart';
import '../../../widget/CustomeButton.dart';
import '../../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get, Inst;

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

  late AttendanceController controler ;

  Map<int, bool> showSaveButton = {}; 
 // Track changed attendance
  List<Map<String, dynamic>> filteredData = [];
  List<Map<String, dynamic>> studentData = [];
  final ScrollController _scrollController = ScrollController();

  List<String> month = [];
  List<String>date=[];
  @override
  void initState() { 
    super.initState();
  controler = Get.find<AttendanceController>();   
    initializeList();
    selectedMonth = controler.gettodaymonth();
    selectedDate = controler.gettoadayDate();
    
  _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 20) {
        _loadMoreStudents();
      }
    });
   } 
// load more when scrolling:
Future<void> _loadMoreStudents() async {
  final more = await controler.fetchPagedStudents(
    stuClass    : widget.classNUmber,
    stuSec      : widget.section,
  dateFilter  : selectedDate!,
  monthFilter : selectedMonth!,
    reset: false,
  );
  if (more.isNotEmpty) {
    setState(() {
      studentData.addAll(more);
      applyFilters(); // you can even remove this now if you trust Firestore to give only filtered data
    });
  }
}

 
void initializeList() async {
  List<String> monthVal = await controler.fetchUniqueMonthValuesAll();
  List<String> dateVal = await controler.getAttendanceDates();
  String name = await controler.getTeacherName(sec: widget.section, stuClass: widget.classNUmber);

  setState(() {
    month = monthVal.toSet().toList(); // Remove duplicates
    date = dateVal.toSet().toList();
    teacherName = name;

    // Ensure default selection exists
    if (month.contains(controler.gettodaymonth())) {
      selectedMonth = controler.gettodaymonth();
    }
    if (date.contains(controler.gettoadayDate())) {
      selectedDate = controler.gettoadayDate();
    }
  });
final data = await controler.fetchPagedStudents(
  stuClass    : widget.classNUmber,
  stuSec      : widget.section,
  dateFilter  : selectedDate!,
  monthFilter : selectedMonth!,
  reset       : true,            // <-- reset pagination on a new filter
);

setState(() {
  // Assuming the data is a List<Map<String, dynamic>>, you can directly assign it to studentData
  studentData = data;  // Assign the fetched data directly without checking for containsKey
  applyFilters();
});

setState(() {
  isLoading = false;
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
  void dispose() {
    filteredData.clear();
    controler.dispose();
    _scrollController.dispose();
    super.dispose();
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
             
              // Date dropdown
_buildDropdown(
  'Select Date',
  selectedDate,
  date,
  (value) async {
    // 1️⃣ update the filter
    setState(() => selectedDate = value);

    // 2️⃣ fetch fresh data from Firestore (reset pagination!)
    final fresh = await controler.fetchPagedStudents(
      stuClass    : widget.classNUmber,
      stuSec      : widget.section,
      dateFilter  : selectedDate!,
      monthFilter : selectedMonth!,
      reset       : true,
    );

    // 3️⃣ update state + re-apply your in-memory filter
    setState(() {
      studentData = fresh;
      applyFilters();
    });
  },
),
  
// Month dropdown
_buildDropdown(
  'Select Month',
  selectedMonth,
  month,
  (value) async {
    setState(() => selectedMonth = value);
    final fresh = await controler.fetchPagedStudents(
      stuClass    : widget.classNUmber,
      stuSec      : widget.section,
      dateFilter  : selectedDate!,
      monthFilter : selectedMonth!,
      reset       : true,
    );
    setState(() {
      studentData = fresh;
      applyFilters();
    });
  },
),

              
               
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
             customIconTextButton(
  Colors.blue,
  icon: Icons.search,
  onPressed: () async {
    setState(() {});

    final fresh = await controler.fetchPagedStudents(
      stuClass    : widget.classNUmber,
      stuSec      : widget.section,
      dateFilter  : selectedDate!,
      monthFilter : selectedMonth!,
      reset       : true,
    );

    setState(() {
      studentData = fresh;
      applyFilters();
    });
  },
  text: "Search",
),
 customIconTextButton(primaryGreenColors, icon: Icons.download_sharp, onPressed:()async{
                  await customSnackbar(context: context, text: "Donloaded Succesfully");
                await PdfAttendance().openPdf(absentCount: 30,date: selectedDate!,presentCount: 50,section: widget.section,
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
              CircularProgressIndicator(color: Colors.green,),
            ],
          ),
        )
      :  SingleChildScrollView(
        controller: _scrollController, 
              child: Container(
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                child: DataTable(
                  columns:  [
                    DataColumn(label: SizedBox(
                          width: MediaQuery.sizeOf(context).width*0.08,
                      
                      child: const Text('Roll.Number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),overflow: TextOverflow.ellipsis,))),
                    const DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    const DataColumn(label: Text('Attendance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    const DataColumn(label: Text('Edit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                    const DataColumn(label: Text('Status',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      
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
                              ElevatedButton(
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

  
Widget _buildDropdown(String hint, String? value, List<String> items, ValueChanged<String?> onChanged) {
  return Container(
    width: 150,
    decoration: BoxDecoration(
      border: Border.all(color: primaryGreenColors, width: 1),
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.white,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: DropdownButton<String>(
      isExpanded: true,
      borderRadius: BorderRadius.circular(20),
      dropdownColor: Colors.white,
      hint: Text(hint, style: const TextStyle(color: Colors.black)),
      value: items.contains(value) ? value : null, // Prevent invalid selections
      onChanged: onChanged,
      items: items.toSet().toList().map((String item) {  // Remove duplicates
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    ),
  );
}

}


