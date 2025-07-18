import 'package:admin_pannel/utils/AppException.dart';


import '../../../services/FireBaseServices/CollectionVariable.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, Query, SetOptions;
import 'package:get/get.dart' show Get, GetxController, Inst;

class ExamUpdationController extends GetxController{

late FirebaseCollectionVariable collectionController ;
final int _limit = 15;
DocumentSnapshot? _lastDocument;
bool _isFetchingMore = false;
  @override
  void onInit() {
    super.onInit();
    collectionController = Get.find<FirebaseCollectionVariable>();
  }

Future<List<Map<String, dynamic>>> getFilteredStudents(dynamic context,{
  required String className,
  required String section,
}) async {
  if (_isFetchingMore) return [];

  _isFetchingMore = true;
  try {
    Query query = collectionController.studentLoginCollection.limit(_limit);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query
        .where('class', isEqualTo: className)
        .where('section', isEqualTo: section)
        .get();

    _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    List<Map<String, dynamic>> studentList = [];

    for (var data in snapshot.docs) {
      final studentId = data.id;
      final studentData = data.data() as Map<String, dynamic>;

      studentList.add({
        'id': studentId,
        'name': studentData['name'] ?? 'Unknown',
        'roll': studentData['RollNo'] ?? 'N/A',
      });
    }

    return studentList;
  } catch (e) {
    throw CloudDataReadException('Error in getting students for result updation, please try again later !');
  } finally {
    _isFetchingMore = false;
  }
}




Future<Map<String, dynamic>> getTotalAndIndividualSubjectMark(dynamic context,{
  required String examType,
  required String className,
  required String section,
}) async {
  try {
  final studentDocs = await collectionController.studentLoginCollection
      .where('class', isEqualTo: className)
      .where('section', isEqualTo: section)
      .limit(1)
      .get();
  
  if (studentDocs.docs.isEmpty) {
    return {'total_mark': '0', 'outoff_mark': '0'};
  }
  
  final studentId = studentDocs.docs.first.id;
  final examDoc = collectionController.studentLoginCollection
      .doc(studentId)
      .collection('exam_result')
      .doc(examType);
  
  final docSnapshot = await examDoc.get();
  final data = docSnapshot.data() ?? {};
  
  return {
    'total_mark': data['total_mark'] ?? '0',
    'outoff_mark': data['outoff_mark'] ?? '0',
  };
}  catch (e) {
  throw CloudDataReadException('Error in getting total and individual subject mark, please try again later !');
}
}

  
Future<void> addUpdateTotalAndIndividualSubject(dynamic context,{
  required String className, 
  required String section,  
  required String examType,
  required String? totalMark,
  required String? outOffMark,
}) async {
  try {
  final doc = await collectionController.studentLoginCollection
      .where('class', isEqualTo: className)
      .where('section', isEqualTo: section)
      .get();
  
  for (var data in doc.docs) {
    final studentId = data.id;
    final examDoc = collectionController.studentLoginCollection
        .doc(studentId)
        .collection('exam_result')
        .doc(examType);
  
    await examDoc.set({
      'total_mark': totalMark ?? '0',
      'outoff_mark': outOffMark ?? '0',
    }, SetOptions(merge: true));
  }
  }  catch (e) {
  throw CloudDataWriteException("Error in updating the total and individual subject marks, please try again later !");
}
}


Future<void>updateResult(dynamic context,{
  required String studentId,
  required String examType,
  required Map<String, dynamic> resultMark ,
})async{
  try {
  final examDoc = collectionController.studentLoginCollection
      .doc(studentId)
      .collection('exam_result')
      .doc(examType);
  
  Map<String, dynamic> result = {};
  
  for (int i = 1; i <= 6; i++) {
    result['sub$i'] = resultMark['sub$i'] ?? '';
    result['sub${i}_mark'] = resultMark['sub${i}_mark'] ?? '';
    result['sub${i}_grade'] = resultMark['sub${i}_grade'] ?? '';
  }
  result['scored_mark'] = resultMark['scored_mark'] ?? '0';
  result['isView'] = true;
  await examDoc.set(
    result,SetOptions(merge: true)
  );    

}  catch (e) {
  throw CloudDataUpdateException('Error in updating the exam result, please try again later !');
}

}
String getGrade(int marks, int singleSubjectMark) {
  double percentage = (marks / singleSubjectMark) * 100;

  if (percentage >= 90) return 'O';
  if (percentage >= 80) return 'A';
  if (percentage >= 70) return 'B';
  if (percentage >= 60) return 'C';
  if (percentage >= 50) return 'D';
  return 'E'; // If percentage < 50
}

Future<Map<String, dynamic>> getResult(dynamic context,{
  required String studentId,
  required String examType,
}) async {
final List<String> subjects = [
    "Tamil",
    "Maths",
    "English",
    "Social Science",
    "Science",
    "Other"
  ];

  final List<String> markPlaceholders = ["00", "00", "00", "00", "00", "00"];
  
  try {
  final examDoc = collectionController.studentLoginCollection
      .doc(studentId)
      .collection('exam_result')
      .doc(examType);
  
  final docSnapshot = await examDoc.get();
  final data = docSnapshot.data() ?? {}; 
  
  Map<String, dynamic> result = {};
  
  for (int i = 0; i < 6; i++) {  // Fix: Use 0-based index
  result['sub${i + 1}'] = data['sub${i + 1}'] ?? subjects[i];
  result['sub${i + 1}_mark'] = data['sub${i + 1}_mark'] ?? markPlaceholders[i];
  result['sub${i + 1} grade'] = data['sub${i + 1}_grade'] ?? '';
  }
  
  
  result['total_mark'] = data['total_mark'] ?? '0';
  result['scored_mark'] = data['scored_mark'] ?? '0';
  result['outoff_mark'] = data['outoff_mark']??'0';
  
  return result;
}  catch (e) {
  throw CloudDataReadException('Error in getting exam result, please try again later !');
}
}

}