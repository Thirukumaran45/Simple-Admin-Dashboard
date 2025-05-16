
import '../FireBaseServices/FirebaseAuth.dart';
import 'classControllers/pageControllers/AttendanceController.dart';
import 'classControllers/pageControllers/DashboardController.dart';
import 'classControllers/pageControllers/ExamUpdationController.dart';
import 'classControllers/pageControllers/FessController.dart';
import 'classControllers/peoplesControlelr/HigherOfficialController.dart';
import 'classControllers/peoplesControlelr/StafffController.dart';
import 'classControllers/peoplesControlelr/StudentController.dart';
import 'classControllers/peoplesControlelr/StudentListBonafiedControlelr.dart';
import 'classControllers/peoplesControlelr/TeacherController.dart';
import 'classControllers/pageControllers/TimetableController.dart';
import 'classControllers/schoolDetailsController/pushNotificationController.dart';
import 'classControllers/schoolDetailsController/schooResetController.dart';
import 'classControllers/schoolDetailsController/schooldetailsController.dart';
import 'package:get/get.dart' show Get,Inst;
import '../FireBaseServices/CollectionVariable.dart';

void initializeGetController() {
    Get.lazyPut(()=>DashboardController()); 
    Get.lazyPut(()=>SchooldetailsController());
    Get.lazyPut(()=>StudentController()); 
    Get.lazyPut(()=>Teachercontroller());
    Get.lazyPut(()=>Higherofficialcontroller());
    Get.lazyPut(()=>StaffController());
    Get.lazyPut(()=>FeesController());
    Get.lazyPut(()=>AttendanceController());
    Get.lazyPut(()=>StudentlistBonafiedController());
    Get.lazyPut(()=>FirebaseCollectionVariable());
    Get.lazyPut(()=>TimetableController());
    Get.lazyPut(()=>ExamUpdationController());
    Get.lazyPut(()=>SchoolResetYearController());
    Get.lazyPut(()=>FirebaseAuthUser());
    Get.lazyPut(()=>PushNotificationControlelr());
}

void disposeAllControllers() {
  Get.delete<DashboardController>();
  Get.delete<SchooldetailsController>();
  Get.delete<StudentController>();
  Get.delete<Teachercontroller>();
  Get.delete<Higherofficialcontroller>();
  Get.delete<StaffController>();
  Get.delete<FeesController>();
  Get.delete<AttendanceController>();
  Get.delete<StudentlistBonafiedController>();
  Get.delete<FirebaseCollectionVariable>();
  Get.delete<TimetableController>();
  Get.delete<ExamUpdationController>();
  Get.delete<SchoolResetYearController>();
  Get.delete<FirebaseAuthUser>();
  Get.delete<PushNotificationControlelr>();
}
