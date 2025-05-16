import 'dart:developer' show log;
import '../../../contant/ConstantVariable.dart';
import '../../../FireBaseServices/CollectionVariable.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, Query;
import 'package:get/get.dart' ;


class StudentlistBonafiedController extends GetxController {
late FirebaseCollectionVariable collectionControler;
  late dynamic snapshot;
  final RxList<Map<String, dynamic>> studentData = <Map<String, dynamic>>[].obs;
final int _limit = 18;
DocumentSnapshot? _lastDocument;
bool _isFetchingMore = false;

  @override
  void onInit() {
    super.onInit();
    collectionControler = Get.find<FirebaseCollectionVariable>();
    fetchStudentData();
  }
 
  void fetchStudentData() async {
     if (_isFetchingMore) return;

  _isFetchingMore = true;
    try {
 Query query = collectionControler.studentLoginCollection.limit(_limit);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

  snapshot = await query.get();
  _lastDocument = snapshot.docs.last;
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

 