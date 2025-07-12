 import 'package:admin_pannel/utils/ExceptionDialod.dart';

import '../../../../contant/CustomNavigation.dart';
import '../../../../controller/classControllers/pageControllers/ExamUpdationController.dart';
import '../../../../controller/classControllers/schoolDetailsController/pushNotificationController.dart';
import '../../../widget/CustomDialogBox.dart';
import '../../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst;

class StudentResult extends StatefulWidget {
  final String stuname;
  final String stuClass;
  final String stuSec;
  final String examName;
 final String id;
 final String singleSubjectMark;
  const StudentResult({
    super.key,
    required this.stuname,
    required this.examName,
    required this.stuClass,
    required this.stuSec, required this.id,
    required this.singleSubjectMark
  });

  @override
  _StudentResultState createState() => _StudentResultState();
}

class _StudentResultState extends State<StudentResult> {
  final Map<String, TextEditingController> _subjectControllers = {};
  final Map<String, TextEditingController> _marksControllers = {};
  bool _isEdited = false;
  late ExamUpdationController controller ;
  late PushNotificationControlelr notificationControlelr;
  final List<String> subjects = [
    "Tamil",
    "Maths",
    "English",
    "Social Science",
    "Science",
    "Other"
  ];

  final List<String> markPlaceholders = ["00", "00", "00", "00", "00", "00"];

  @override
  void initState() {
    super.initState();
    notificationControlelr = Get.find<PushNotificationControlelr>();
   controller = Get.find<ExamUpdationController>();
    // Initialize all controllers with default values and add listeners.
    for (int i = 0; i < subjects.length; i++) {
      _subjectControllers['sub${i + 1}'] = 
          TextEditingController(text: subjects[i]);
      _marksControllers['mark${i + 1}'] = 
          TextEditingController(text: markPlaceholders[i]);

      _subjectControllers['sub${i + 1}']!.addListener(_onFieldChanged);
      _marksControllers['mark${i + 1}']!.addListener(_onFieldChanged);
    }

    // Fetch exam results and update controllers.
    _fetchExamResult();
  }

  // This method calls the async getResult function,
  // updates each subject and mark controller from the returned result,
  // but intentionally leaves out assigning any grade fields.
Future<void> _fetchExamResult() async {
  final result =await ExceptionDialog().handleExceptionDialog(context,()async=> await controller.getResult(
    studentId: widget.id,context,
    examType: widget.examName,
  ));

  if (!mounted) return; // Prevent calling setState on a disposed widget

  setState(() {
    for (int i = 1; i <= subjects.length; i++) {
      _subjectControllers['sub$i']!.text =
          result!['sub$i'] ?? subjects[i - 1];
      _marksControllers['mark$i']!.text =
          result['sub${i}_mark'] ?? markPlaceholders[i - 1];
    }
  });
}



 void _onFieldChanged() {
  if (!mounted) return;
  setState(() {
    _isEdited = true;
  });
}

@override
void dispose() {
  for (int i = 0; i < subjects.length; i++) {
    _subjectControllers['sub${i + 1}']?.removeListener(_onFieldChanged);
    _marksControllers['mark${i + 1}']?.removeListener(_onFieldChanged);
    _subjectControllers['sub${i + 1}']?.dispose();
    _marksControllers['mark${i + 1}']?.dispose();

  }
  notificationControlelr.dispose();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(children: [customIconNavigation(context, '/exam-Details-updation/sectionWiseResultPublishment/studentOverview?examName=${widget.examName}&class=${widget.stuClass}&section=${widget.stuSec}')],),
            Center(
              child: Container(
                width: 900,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.examName,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.stuname,
                              style: TextStyle(fontSize: 18, color: Colors.grey[850]),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                color: Colors.black,
                                height: 25,
                                width: 2,
                              ),
                            ),
                            Text(
                              "${widget.stuClass} - ${widget.stuSec}",
                              style: const TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: List.generate(subjects.length, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      style: const TextStyle(
                                        
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16
                                      ),
                                      controller: _subjectControllers['sub${index + 1}'],
                                      decoration: InputDecoration(
                                        labelText: 'Subject${index+1}',
                                        labelStyle: TextStyle(
                                          color: primaryGreenColors
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
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 1,
                                    child: TextField(
                                       style:const  TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16
                                      ),
                                      controller: _marksControllers['mark${index + 1}'],
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Marks ${index + 1}',
                                        labelStyle: TextStyle(
                                          color: primaryGreenColors
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
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Positioned(
                      top: 20,
                      right: 30,
                      child: Visibility(
                        visible: _isEdited,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreenColors,
                            foregroundColor: Colors.white,
                            elevation: 10,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                         onPressed: () async {
                           
                             
  if (_isEdited) {
    // Calculate the total scored marks
    int scoredMark = 0;
    for (int i = 1; i <= subjects.length; i++) {
      scoredMark += int.tryParse(_marksControllers['mark$i']!.text) ?? 0;
    }

   // Define the single subject mark (fixed across exams)
int singleSubjectMark = int.tryParse(widget.singleSubjectMark)??0;

// Create resultMark map
Map<String, dynamic> resultMark = {};
for (int i = 1; i <= subjects.length; i++) {
  // Get subject marks
  int subjectMark = int.tryParse(_marksControllers['mark$i']!.text) ?? 0;

  // Calculate grade
  String grade =  controller. getGrade(subjectMark, singleSubjectMark);

  // Update resultMark map
  resultMark['sub$i'] = _subjectControllers['sub$i']!.text;
  resultMark['sub${i}_mark'] = subjectMark.toString();
  resultMark['sub${i}_grade'] = grade;
}

    resultMark['scored_mark'] = scoredMark.toString();
    // Show dialog and update the result
    
    CustomDialogs().showLoadingDialogInSec(context,10,"Please wait a moment ...", onlyText: true);
   await ExceptionDialog().handleExceptionDialog(context,()async=> await controller.updateResult(context,
      studentId: widget.id,
      examType: widget.examName,
      resultMark: resultMark,
    ));
       await ExceptionDialog().handleExceptionDialog(context,()async=> 
         await notificationControlelr.examFeesUpdationPushNotification(context,id: widget.id));
     
    await CustomDialogs().showCustomDialog(context,"✅ Exam result published succesfully.");
    if(!context.mounted)return;
     if (Navigator.of(context, rootNavigator: true).canPop()) {
     Navigator.of(context, rootNavigator: true).pop();
}
    setState(() {
      _isEdited = false;
    });
  }
}
,
                          child: const Row(
                            children: [
                              Text(
                                'Upload Result',
                                style: TextStyle(fontSize: 14),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.upload,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
                           const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
