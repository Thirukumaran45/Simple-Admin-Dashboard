// ignore_for_file: use_build_context_synchronously

import 'package:admin_pannel/utils/ExceptionDialod.dart';

import '../../../contant/CustomNavigation.dart';
import '../../../controller/classControllers/schoolDetailsController/schooResetController.dart';
import '../../widget/CustomDialogBox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst;

class SectionWiseResetData extends StatefulWidget {
final String stuClass;
 const   SectionWiseResetData({super.key, required this.stuClass});

  @override
  State<SectionWiseResetData> createState() => _SectionWiseResetDataState();
}

class _SectionWiseResetDataState extends State<SectionWiseResetData> {

late SchoolResetYearController controller;
@override
  void initState() {
    super.initState();
        controller = Get.find<SchoolResetYearController>();
        
  }

  final List<String> historyItems = [
    "Reset Attendance History",
    "Reset Remainder Chat History",
    "Reset Exam Publish History",
    "Reset Student Assignment History",
    "Reset Leave Submission History",
    "Reset Teacher Assignment Uploads",
    "Reset Class Time Table ",
    "Reset School Chat History",
    "Reset Fees Transaction Histry "
  ];

// Define a function that returns a Map<int, Future<void> Function()>
// This allows you to create a mapping where, e.g., key 0 corresponds to the first deletion method.
Map<int, Future<void> Function()> getDeletionFunctionsMap({
  required String stuClass,
  required String section,
}) {
  return {
    0: () async => await ExceptionDialog().handleExceptionDialog(context, ()async=> controller.deleteAttendanceDataByClassSection(context,stuClass, section)),
    1: () async => await ExceptionDialog().handleExceptionDialog(context, ()async=> controller.deleteRemainderChatDataByClassSection(context,
          stuClass: stuClass,
          stuSec: section,
        )),
    2: () async => await ExceptionDialog().handleExceptionDialog(context, ()async=> controller.deleteExamDataByClassSection(context,
          stuClass: stuClass,
          stuSec: section,
        )),
    3: () async => await ExceptionDialog().handleExceptionDialog(context, ()async=> controller.deleteAssignmentByClassSection(context,
          stuClass: stuClass,
          stuSec: section,
        )),
    4: () async => await ExceptionDialog().handleExceptionDialog(context, ()async=> controller.deleteLeaveHistrytByClassSection(context,
          stuClass: stuClass,
          stuSec: section,
        )),
    5: () async => await ExceptionDialog().handleExceptionDialog(context, ()async=> controller.deleteAssignmentByTeacherClassSection(context,
          stuClass: stuClass,
          stuSec: section,
        )),
    6: () async => await ExceptionDialog().handleExceptionDialog(context, ()async=> controller.deleteTimeTableDataByClassSection(context,
          stuClass: stuClass,
          sec: section,
        )),
    7: () async => await ExceptionDialog().handleExceptionDialog(context, ()async=> controller.deleteSchoolChatData(context,)),
    8:() async =>await ExceptionDialog().handleExceptionDialog(context, ()async=> controller.deleteFeesTransactionByClassSection(context,stuClass: stuClass, stuSec: section)),
  };
}

@override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      backgroundColor: Colors.white,
        
    leading: customIconNavigation(context, "/schoolYear-data-updation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: 4, // Sections A to B
          itemBuilder: (context, index) {
            String sectionTitle = "Section ${String.fromCharCode(65 + index)}";
            return  Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow:  const [
                      BoxShadow(                     
                         color: Colors.grey,

                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sectionTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      Column(
                        children: historyItems.map((item) {
                          return ListTile(
                            leading: const Icon(Icons.history, color: Colors.blue),
                            title: Text(item),
                            trailing: ElevatedButton(
                              
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                backgroundColor: Colors.red
                                ,foregroundColor: Colors.white
                              ),
                             onPressed: () async {
  final bool val = await CustomDialogs().showCustomConfirmDialog(
      context: context,
      text: "Are you sure about to delete and reset ?");
  if (!context.mounted) return;
  if (val) {
    CustomDialogs().showLoadingDialogInSec(context, 10,"Reset is on progress please wait a moment...");
 
  int historyIndex = historyItems.indexOf(item);
  var deletionFunctions = getDeletionFunctionsMap(
    stuClass: widget.stuClass,
    section: String.fromCharCode(65 + index),
  );
  // Call the respective function if exists
  if (deletionFunctions.containsKey(historyIndex)) {
    await deletionFunctions[historyIndex]!();
  }
   if (Navigator.of(context, rootNavigator: true).canPop()) {
     Navigator.of(context, rootNavigator: true).pop();
}
  await  CustomDialogs().showCustomDialog(context,"✅ Succesfully the data as been deleted");
  }

},

                              child: const Text('Reset Histry'),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
