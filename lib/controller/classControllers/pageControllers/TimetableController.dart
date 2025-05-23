

import 'dart:developer' show log;

import 'package:admin_pannel/contant/constant.dart' show customSnackbar;
import 'package:admin_pannel/utils/AppException.dart';


import '../../../services/FireBaseServices/CollectionVariable.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show SetOptions,DocumentSnapshot;
import 'package:get/get.dart' ;


class TimetableController extends GetxController{

final List<String> periods = ["Period 1", "Period 2", "Period 3", "Period 4", "Period 5", "Period 6", "Period 7", "Period 8"];
  

  late FirebaseCollectionVariable collectionControler;
  late dynamic snapshot;
  final RxList<String> teachers = <String>[].obs ;
 var _context;
  @override
  void onInit() {
    super.onInit();
    collectionControler = Get.find<FirebaseCollectionVariable>(); 
    fetchTeachers(_context);
  }

Future<void> fetchTeachers(dynamic context,) async {
  try {
  final docs = await collectionControler.teacherLoginCollection.get();
  teachers.clear(); 
  
  for (var doc in docs.docs) {
    final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?; 
    if (data != null && data.containsKey('name')) {
      teachers.add(data['name'] as String);
    }
  }
  update(); 
}  catch (e) {
  log("error in fetching the teacher details: $e");
        throw CloudDataReadException("Error in getting teacher details, please try again later !");

}
}


Future<void> saveTimetableToFirestore(dynamic context,{
  required String stuClaa,
  required String stuSec,
  required String? subject,
  required String? teacher,
  required String? startTime,
  required String? endTime,
  required String? day,
  required String? period,
}) async {
  String classSection = "$stuClaa$stuSec";


        
    try {
  await collectionControler.timetableCollection
      .doc(classSection)
      .collection(day!)
      .doc(period)
      .set({
        "subject": subject,
        "teacher": teacher,
        "startTime": startTime,
        "endTime": endTime,
      }, SetOptions(merge: true)); 
      update();
        if(!context.mounted)return;
   await   customSnackbar(context: context, text: "Time table have been changed !");
}  catch (e) {
  log("erorr in add and update funtion $e");
        throw CloudDataWriteException("Error in updating class timetable, please try again later !");

}
  

}


Future<DocumentSnapshot<Map<String, dynamic>> >loadTimetableCollection(dynamic context,{required String classSection,
required String day,
required String period
})async{
  try {
  final docData= await collectionControler.timetableCollection
      .doc(classSection)
      .collection(day)
      .doc(period)
          .get();
          return docData;
}  catch (e) {
      throw CloudDataReadException("Error in getting the class timetable, please try again later !");
  
}
}



}