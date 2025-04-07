import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:get/get.dart';

class SchoolResetYearController extends GetxController
{
late FirebaseCollectionVariable collectionVariable;
@override
  void onInit() {
    super.onInit();
    collectionVariable = Get.find();
  }

  Future<void>deleteAttendanceData()async{}
  Future<void>deleteRemainderChatData()async{}
  Future<void>deleteSchoolChatData()async{}
  Future<void>deleteExamData()async{}
  Future<void>deleteAssignmentData()async{}
  Future<void>deleteTimeTableData()async{}
  
}