import 'package:admin_pannel/utils/ExceptionDialod.dart';

import '../../../contant/CustomNavigation.dart';
import '../../../controller/classControllers/pageControllers/TimetableController.dart';
import '../../widget/CustomDialogBox.dart';
import '../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart' show Get,Inst;

class SectionWiseTimetable extends StatefulWidget {
  final String stuClass;
  final String stuSec;
  const SectionWiseTimetable({super.key, required this.stuClass, required this.stuSec});

  @override
  State<SectionWiseTimetable> createState() => _SectionWiseTimetableState();
}

class _SectionWiseTimetableState extends State<SectionWiseTimetable> {
  final List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  late TimetableController timetableContrl;

  Map<String, TimeOfDay> startTimes = {};
  Map<String, TimeOfDay> endTimes = {};
  Map<String, Map<String, TextEditingController>> timetable = {};
  Map<String, Map<String, String?>> selectedTeachers = {};
  bool isChanged = false;
  bool _isLoading = true; // New state variable for loading indicator

  @override
  void initState() {
    super.initState();
     timetableContrl=Get.find<TimetableController>();
    for (var day in days) {
      timetable[day] = {};
      selectedTeachers[day] = {};
      for (var period in timetableContrl.periods) {
        timetable[day]![period] = TextEditingController(text: "");
        selectedTeachers[day]![period] = "";
      }
    }
    loadTimetableFromFirestore();
  }

Future<void> loadTimetableFromFirestore() async {
  String classSection = "${widget.stuClass}${widget.stuSec}";

  for (var day in days) {
    for (var period in timetableContrl.periods) {
      
        dynamic snapshot =await ExceptionDialog().handleExceptionDialog(context, ()async=> await timetableContrl.loadTimetableCollection(context,
          classSection: classSection,
          day: day,
          period: period,
        ));

        if (snapshot.exists) {
          var data = snapshot.data();
          if (data != null) {
            setState(() {
              timetable[day]![period]!.text = data["subject"] ?? "";
              selectedTeachers[day]![period] = data["teacher"] ?? "";

              // 🔹 Validate and Parse Start Time
              if (data["startTime"] != null && data["startTime"].contains(":")) {
                List<String> startParts = data["startTime"].split(":");
                if (startParts.length > 1) {
                  startTimes[period] = TimeOfDay(
                    hour: int.tryParse(startParts[0]) ?? 0,
                    minute: int.tryParse(startParts[1].split(" ")[0]) ?? 0,
                  );
                }
              }

              // 🔹 Validate and Parse End Time
              if (data["endTime"] != null && data["endTime"].contains(":")) {
                List<String> endParts = data["endTime"].split(":");
                if (endParts.length > 1) {
                  endTimes[period] = TimeOfDay(
                    hour: int.tryParse(endParts[0]) ?? 0,
                    minute: int.tryParse(endParts[1].split(" ")[0]) ?? 0,
                  );
                }
              }
            });
          }
        }
    
    }
  }
 if (!mounted) return; // Check before updating state
  setState(() {
    _isLoading = false;
  });
}

  Future<void> _selectTime(BuildContext context, String period, bool isStart) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: primaryGreenColors,
            hintColor: primaryGreenColors,
            colorScheme:  ColorScheme.light(primary: primaryGreenColors),
            buttonTheme:  ButtonThemeData(hoverColor: primaryGreenColors),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null &&mounted) {
      setState(() {
        if (isStart) {
          startTimes[period] = pickedTime;
        } else {
          endTimes[period] = pickedTime;
        }
        isChanged = true;
      });
    }
  }


@override
void dispose() {
  for (var day in days) {
    for (var period in timetableContrl.periods) {
      timetable[day]![period]?.dispose();
    }
  }
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
     if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Almost there please wait a second ... ", style: TextStyle(color: Colors.black,fontSize: 18),),
              const SizedBox(width: 30,),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(primaryGreenColors),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
     
      body: Column(
        children: [
         Row(
          children: [
                        customIconNavigation(context, '/school-timeTable'),
                        const SizedBox(width: 100,),
                          const  Text(
                      "Update Time Table - ",
                      style:  TextStyle(
                        letterSpacing: 1,

                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:  10),
                      child: Container(
                        color: Colors.black,
                        height: 20,
                        width: 2,
                      ),
                    ),
                    Text(
                      "${widget.stuClass} - ${widget.stuSec}",
                      style:  TextStyle(
                        letterSpacing: 1,
                          fontSize: 16, fontWeight: FontWeight.bold, color: primaryGreenColors),
                    ),
            const Spacer(),
            SizedBox(
              height: 40,
              width: 140,
              child: ElevatedButton(
              onPressed: () async{
      if (isChanged) {
        CustomDialogs().showLoadingDialogInSec(context, 7);

        // Print timetable details
       for (var period in timetableContrl.periods) {
  String? startTime = startTimes[period]?.format(context) ?? '';
  String? endTime = endTimes[period]?.format(context) ?? '';

  for (var day in days) {
    String? subject = timetable[day]![period]?.text ?? '';
    String teacher = selectedTeachers[day]![period] ?? '';

   await ExceptionDialog().handleExceptionDialog(context, ()async=> await timetableContrl.saveTimetableToFirestore(context,
      stuClaa: widget.stuClass,
      stuSec: widget.stuSec,
      subject: subject,
      teacher: teacher,
      startTime: startTime,  // ✅ Same for all days per period
      endTime: endTime,      // ✅ Same for all days per period
      day: day,
      period: period,
    ));
  }
}

      }
      setState(() {
      isChanged = false;
    });
    },
                style: ElevatedButton.styleFrom(
                                backgroundColor: isChanged?Colors.blue:Colors.grey,
                                foregroundColor: Colors.white,
                                 elevation: 10, // Elevation for shadow effect
                                padding: const EdgeInsets.symmetric(
                                     horizontal: 18, vertical: 12), // Button padding
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20), // Rounded corners
                                ),
                              ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.upload,size: 25,color: Colors.white,),
                     Text("Save", style: TextStyle(letterSpacing: 2),),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            )
          ],
         ),
         const SizedBox(height: 40,),
          Expanded(
            child: SizedBox(
              width: screenWidth * 1.2,
              height: screenHeight * 0.8,
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 100,),
                      ...timetableContrl.periods.map((period) {
                        final ired = startTimes[period]?.format(context)==null;
                        return Expanded(
                          child: Column(
                            children: [
                              Text(period, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: ()=>_selectTime(context, period, true),
                  child: SizedBox(
                                
                    child: Text(
                      startTimes[period]?.format(context) ?? "Start",
                      style:  TextStyle(
                        overflow: TextOverflow.ellipsis, // Prevent overflow by showing '...'
                        color:ired? Colors.red:Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize:13 ,
                      ),
                    ),
                  ),
                ),
                const Text(" - "),
                InkWell(
                  onTap: ()=>_selectTime(context, period, false),
                  child: Text(
                    endTimes[period]?.format(context) ?? "End",
                    style:  TextStyle(
                      overflow: TextOverflow.ellipsis, // Prevent overflow by showing '...'
                      color: ired? Colors.red:Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            
                            ],
                          ),
                        );
                      })
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: days.map((day) {
                          return Row(
                            children: [
                              SizedBox(width: 100, child: Text(day, style: const TextStyle(fontWeight: FontWeight.bold))),
                              ...timetableContrl.periods.map((period) {
                                
                          final isRed = timetable[day]![period]?.text=="";
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: timetable[day]![period],
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: isRed?Colors.red:primaryGreenColors),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: isRed?Colors.red:primaryGreenColors),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: isRed?Colors.red:primaryGreenColors),
                                            ),
                                            hintText: "Subject",
                                          ),
                                          onChanged: (value) => setState(() => isChanged = true),
                                        ),
                                        const SizedBox(height: 5),
                                      DropdownSearch<String>(
                                        
                                        
                   items: (filter, infiniteScrollProps) => timetableContrl.teachers,
  selectedItem: selectedTeachers[day]![period], // Make sure this is setting the value correctly
  onChanged: (value) => setState(() {
    selectedTeachers[day]![period] = value;
    isChanged = true;
  }),
                       decoratorProps:  DropDownDecoratorProps(
                         decoration: InputDecoration(
                             border: OutlineInputBorder(
                                              borderSide: BorderSide(color: isRed?Colors.red:primaryGreenColors),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: isRed?Colors.red:primaryGreenColors),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: isRed?Colors.red:primaryGreenColors),
                                            ),
                  hintText: "Teacher",
                ),
              ),
              popupProps: const PopupProps.menu(
                fit: FlexFit.loose,
                constraints: BoxConstraints(
                  
                ),
                showSearchBox: true, // Enables search functionality
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: "Search Teacher",
                    border: OutlineInputBorder(),
                  ),
                ),
                menuProps: MenuProps(
                  backgroundColor: Colors.white, // White background for list items
                ),
              ),
            ),
            
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}