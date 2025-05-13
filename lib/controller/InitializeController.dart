
import 'package:admin_pannel/FireBaseServices/FirebaseAuth.dart';
import 'package:admin_pannel/controller/classControllers/pageControllers/AttendanceController.dart';
import 'package:admin_pannel/controller/classControllers/pageControllers/DashboardController.dart';
import 'package:admin_pannel/controller/classControllers/pageControllers/ExamUpdationController.dart';
import 'package:admin_pannel/controller/classControllers/pageControllers/FessController.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/HigherOfficialController.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/StafffController.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/StudentController.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/StudentListBonafiedControlelr.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/TeacherController.dart';
import 'package:admin_pannel/controller/classControllers/pageControllers/TimetableController.dart';
import 'package:admin_pannel/controller/classControllers/schoolDetailsController/schooResetController.dart';
import 'package:admin_pannel/controller/classControllers/schoolDetailsController/schooldetailsController.dart';
import 'package:get/get.dart' show Get,Inst;
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';

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
}
