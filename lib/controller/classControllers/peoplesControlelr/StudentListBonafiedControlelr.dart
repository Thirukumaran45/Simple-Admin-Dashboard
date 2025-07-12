import 'package:admin_pannel/utils/AppException.dart' show CloudDataReadException;
import '../../../contant/ConstantVariable.dart';
import '../../../services/FireBaseServices/CollectionVariable.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, Query;
import 'package:get/get.dart' ;


class StudentlistBonafiedController extends GetxController {
late FirebaseCollectionVariable collectionControler;
  late dynamic snapshot;
  final RxList<Map<String, dynamic>> studentData = <Map<String, dynamic>>[].obs;
final int _limit = 15;
DocumentSnapshot? _lastDocument;
bool _isFetchingMore = false;
var _context;
  @override
  void onInit() {
    super.onInit();
    collectionControler = Get.find<FirebaseCollectionVariable>();
    fetchStudentData(_context);
  }
 
  void fetchStudentData(dynamic context,) async {
     if (_isFetchingMore) return;

  _isFetchingMore = true;
    try {
 Query query = collectionControler.studentLoginCollection.limit(_limit);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

  snapshot = await query.get();
  if (snapshot.docs.isNotEmpty) {
  _lastDocument = snapshot.docs.last;
  studentData.value = snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return {
      'rollNumber': data[rollNofield] ?? '',
      'name': data[studentNamefield] ?? '',
      'id': data[studentIdField] ?? '',
      'class': data[classField] ?? '',
      'section': data[sectionFild] ?? '',
      'parentName': data[fatherNameField] ?? data[motherNameField] ?? '',
      'feeStatus':data[feesStatusField]??''
    };
  }).toList().cast<Map<String, dynamic>>(); 
  }
}   catch (e) {
    throw CloudDataReadException("Error in loading student details, please try again later !");

}
  }
}

 