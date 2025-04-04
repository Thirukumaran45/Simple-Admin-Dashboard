
import 'package:admin_pannel/controller/classControllers/AttendanceController.dart';
import 'package:admin_pannel/controller/classControllers/FessController.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/HigherOfficialController.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/StafffController.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/StudentController.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/StudentListBonafied.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/TeacherController.dart';
import 'package:admin_pannel/controller/classControllers/TimetableController.dart';
import 'package:admin_pannel/controller/classControllers/dashboardController.dart';
import 'package:admin_pannel/controller/classControllers/schoolController/schooldetailsController.dart';
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
}