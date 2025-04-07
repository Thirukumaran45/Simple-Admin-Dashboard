import 'dart:developer' show log;

import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:get/get.dart';

class StudentlistBonafiedController extends GetxController {
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
      'rollNumber': doc[rollNofield] ?? '',
      'name': doc[studentNamefield] ?? '',
      'id': doc[studentIdField] ?? '',
      'class': doc[classField] ?? '',
      'section': doc[sectionFild] ?? '',
      'parentMobile': doc[motherPhoneNoField] ?? '',
      'feeStatus':doc[feesStatusField]??''
    };
  }).toList().cast<Map<String, dynamic>>(); 
}   catch (e) {
  log('error in fetching the data $e');
        update(); // Notify GetX listeners
}
  }
}

 