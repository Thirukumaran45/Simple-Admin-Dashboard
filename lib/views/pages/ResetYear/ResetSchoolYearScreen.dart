// ignore_for_file: use_build_context_synchronously

import '../../../contant/CustomNavigation.dart';
import '../../../controller/classControllers/schoolDetailsController/schooResetController.dart';
import '../../widget/CustomDialogBox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst;

class ResetSchoolYearScreen extends StatefulWidget {
  const ResetSchoolYearScreen({super.key});

  @override
  State<ResetSchoolYearScreen> createState() => _ResetSchoolYearScreenState();
}

class _ResetSchoolYearScreenState extends State<ResetSchoolYearScreen> {

late SchoolResetYearController controller;

@override
  void initState() {
    super.initState();
    controller = Get.find<SchoolResetYearController>();
  }

Future<void> deleteAllData(BuildContext context,String stuClass) async {

await controller.deleteAttendanceDataByClass(context,stuClass);
await controller.deleteRemainderChatDataByClass(context,stuClass: stuClass);
await controller.deleteExamDataByClass(context,stuClass: stuClass);
await controller.deleteAssignmentByClass(context,stuClass: stuClass);
await controller.deleteLeaveHistryByClass(context,stuClass: stuClass);
await controller.deleteAssignmentByTeacherClass(context,stuClass: stuClass);
await controller.deleteTimeTableDataByClass(context,stuClass: stuClass);
await controller.deleteSchoolChatData(context,);

}

@override
  void dispose() {
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(12, (index) {
            return InkWell(
              onTap: (){
                customNvigation(context, '/schoolYear-data-updation/sectionWiseResetHistry?class=${index + 1}');
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Class ${index + 1}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white
                          ),
                          onPressed: ()async{
                           final bool val = await CustomDialogs().showCustomConfirmDialog(context: context, text: "Are you sure about to delete and reset ?");
                            if(!context.mounted)return;
                          if(val)CustomDialogs().showLoadingDialogInSec(context,15);
                            await deleteAllData(context,'${index + 1}');
                        

                          }, child: const Row(
                          children: [
                            Icon(Icons.restart_alt,color: Colors.white,size: 20,),
                            Text("Reset Data", style: TextStyle( fontWeight: FontWeight.w500),)
                          ],
                        ))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                       subtitle("Attendance Histry Reset"),
                       subtitle("Remainder and School Chat Histry Reset"),
                       subtitle("Exam Publish Histry Reset"),
                       subtitle("Assigment Histry Reset"),
                       subtitle("TimeTable Reset"),

                      ],
                    ),
                  
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

Widget subtitle(String subtitle)
{
  return Row(
    children: [
      
       Text(
        subtitle,
        textAlign: TextAlign.center,
        style:  TextStyle(fontSize: 14, color: Colors.grey[850]),
      ),
        Padding(
        padding: const EdgeInsets.symmetric(horizontal:  8.0),
        child: Container(
          height: 20,
          width: 2,
          color: Colors.grey,
        ),
      ),
    ],
  );
}