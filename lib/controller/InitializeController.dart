
import '../services/FireBaseServices/FirebaseAuth.dart';
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
import '../services/FireBaseServices/CollectionVariable.dart';

void initializeGetController() {
    Get.lazyPut(()=>DashboardController(),fenix: true); 
    Get.lazyPut(()=>SchooldetailsController(),fenix: true);
    Get.lazyPut(()=>StudentController(),fenix: true); 
    Get.lazyPut(()=>Teachercontroller(),fenix: true);
    Get.lazyPut(()=>Higherofficialcontroller(),fenix: true);
    Get.lazyPut(()=>StaffController(),fenix: true);
    Get.lazyPut(()=>FeesController(),fenix: true);
    Get.lazyPut(()=>AttendanceController(),fenix: true);
    Get.lazyPut(()=>StudentlistBonafiedController(),fenix: true);
    Get.lazyPut(()=>FirebaseCollectionVariable(),fenix: true);
    Get.lazyPut(()=>TimetableController(),fenix: true);
    Get.lazyPut(()=>ExamUpdationController(),fenix: true);
    Get.lazyPut(()=>SchoolResetYearController(),fenix: true);
    Get.lazyPut(()=>FirebaseAuthUser(),fenix: true);
    Get.lazyPut(()=>PushNotificationControlelr(),fenix: true);
}

