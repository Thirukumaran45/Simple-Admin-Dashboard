import 'dart:developer'show log;
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:admin_pannel/modules/studentModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:get/get.dart';

class StudentController extends GetxController {
  late FirebaseCollectionVariable collectionControler;
  late dynamic snapshot;
  final RxList<Map<String, dynamic>> studentData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    collectionControler = Get.find<FirebaseCollectionVariable>();
    fetchStudentData();
  }

  void fetchStudentData() async {
    try {
  snapshot = await collectionControler.studentLoginCollection.get();
  studentData.value = snapshot.docs.map((doc) {
    return {
      'rollNumber': doc.data()?['Roll.no'] ?? '',
      'name': doc[studentNamefield] ?? '',
      'id': doc[stdentIdField] ?? '',
      'class': doc[classField] ?? '',
      'section': doc[sectionFild] ?? '',
      'parentMobile': doc[motherPhoneNoField] ?? '',
    };
  }).toList().cast<Map<String, dynamic>>(); 
}   catch (e) {
  log(e.toString());
}
  }

Future<StudentdetailsModel?> studentDataRead({required String uid}) async {
  try {
   final  doc = await collectionControler.studentLoginCollection.doc(uid).get();
   final  castedDoc = doc as DocumentSnapshot<Map<String, dynamic>>;
    return StudentdetailsModel.fromSnapshot(castedDoc);
  } catch (e) {
    log('Error fetching student data: $e');
   return null;
    
     }
}
Future<String?> getStudentPhotoUrl(String studentId) async {
  try {
    final ref =collectionControler.firebaseStorageRef.child("Student photo/$studentId");
    final doc = await ref.getDownloadURL();
    return doc;
  } catch (e) {
    log(e.toString());
    return null; // Return null if file does not exist
  }
}

}
