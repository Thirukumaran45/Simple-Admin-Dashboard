import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show SetOptions;
import 'package:get/get.dart';

class ExamUpdationController extends GetxController{

late FirebaseCollectionVariable collectionController ;

  @override
  void onInit() {
    super.onInit();
    collectionController = Get.find<FirebaseCollectionVariable>();
  }

Future<List<Map<String, dynamic>>> getFilteredStudents({
  required String className,
  required String section,
}) async {
  final querySnapshot = await collectionController.studentLoginCollection
      .where('class', isEqualTo: className)
      .where('section', isEqualTo: section)
      .get();

  List<Map<String, dynamic>> studentList = [];

  for (var data in querySnapshot.docs) {

    
    final studentId = data.id;
    final studentData = data.data() as Map<String, dynamic>;

    studentList.add({
      'id': studentId,
      'name': studentData['name'] ?? 'Unknown',
      'roll': studentData['RollNo'] ?? 'N/A',
    });
  }

  return studentList;
  
}



Future<Map<String, dynamic>> getTotalAndIndividualSubjectMark({
  required String examType,
  required String className,
  required String section,
}) async {
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
}

  
Future<void> addUpdateTotalAndIndividualSubject({
  required String className, 
  required String section,  
  required String examType,
  required String? totalMark,
  required String? outOffMark,
}) async {
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
}


Future<void>updateResult({
  required String studentId,
  required String examType,
  required Map<String, dynamic> resultMark ,
})async{
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

  await examDoc.set(
    result,SetOptions(merge: true)
  );    

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

Future<Map<String, dynamic>> getResult({
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
}

}