
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
import 'package:get/get.dart';
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';

Future<void> initializeGetController()async{
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
}