import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomDialogBox.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:math';

class SectionWiseTimetable extends StatefulWidget {
  final String stuClass;
  final String stuSec;
  const SectionWiseTimetable({super.key, required this.stuClass, required this.stuSec});

  @override
  State<SectionWiseTimetable> createState() => _SectionWiseTimetableState();
}

class _SectionWiseTimetableState extends State<SectionWiseTimetable> {
  final List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  final List<String> periods = ["Period 1", "Period 2", "Period 3", "Period 4", "Period 5", "Period 6", "Period 7", "Period 8"];
  List<String> teachers = ["Mr. Smith", "Ms. Johnson", "Dr. Brown", "Prof. Davis", "Mrs. Wilson","Mr. Smith", "Ms. Johnson", "Dr. Brown", "Prof. Davis", "Mrs. Wilson",];

  Map<String, TimeOfDay> startTimes = {};
  Map<String, TimeOfDay> endTimes = {};
  Map<String, Map<String, TextEditingController>> timetable = {};
  Map<String, Map<String, String?>> selectedTeachers = {};
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    final random = Random();
    for (var day in days) {
      timetable[day] = {};
      selectedTeachers[day] = {};
      for (var period in periods) {
        timetable[day]![period] = TextEditingController(text: "null");
        selectedTeachers[day]![period] = teachers[random.nextInt(teachers.length)];
      }
    }
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

    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          startTimes[period] = pickedTime;
        } else {
          endTimes[period] = pickedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                onPressed: () {
                  isChanged?showCustomDialog(context, "Time Table as been Updated"):null;
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
         const SizedBox(height: 20,),
          Expanded(
            child: SizedBox(
              width: screenWidth * 1.2,
              height: screenHeight * 0.8,
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 100,),
                      ...periods.map((period) {
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
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis, // Prevent overflow by showing '...'
                        color: Colors.red,
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
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis, // Prevent overflow by showing '...'
                      color: Colors.red,
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: days.map((day) {
                          return Row(
                            children: [
                              SizedBox(width: 100, child: Text(day, style: const TextStyle(fontWeight: FontWeight.bold))),
                              ...periods.map((period) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: timetable[day]![period],
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(color: timetable[day]![period]?.text=='null'?Colors.red:primaryGreenColors),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: timetable[day]![period]?.text=='null'?Colors.red:primaryGreenColors),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: timetable[day]![period]?.text=='null'?Colors.red:primaryGreenColors),
                                            ),
                                            hintText: "Subject",
                                          ),
                                          onChanged: (value) => setState(() => isChanged = true),
                                        ),
                                        const SizedBox(height: 5),
                                      DropdownSearch<String>(
                                        
                                        
                       items: (filter, infiniteScrollProps) => teachers,
                    selectedItem: selectedTeachers[day]![period],
                      onChanged: (value) => setState(() {
                               selectedTeachers[day]![period] = value;
                         isChanged = true;
                          }),
                       decoratorProps:  DropDownDecoratorProps(
                         decoration: InputDecoration(
                             border: OutlineInputBorder(
                                              borderSide: BorderSide(color: timetable[day]![period]?.text=='null'?Colors.red:primaryGreenColors),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: timetable[day]![period]?.text=='null'?Colors.red:primaryGreenColors),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: timetable[day]![period]?.text=='null'?Colors.red:primaryGreenColors),
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
