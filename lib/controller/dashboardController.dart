import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {

  late FirebaseCollectionVariable collectionControler;
  @override
  void onInit() {
    super.onInit();
    collectionControler = FirebaseCollectionVariable();
  }
  
  final List<String> navItems =['Home','Attendance','Fees Update','Exam Updates','Manage Students','Manage Teachers','Manage Officials','Manage Staffs','Time table','School Details', 'Bonafied','Live Bus','Reset Year'];
  final List<String> navs=['/home','/attendance','/fees-updation','/exam-Details-updation','/manage-student','/manage-teacher','/manage-higher-official','/manage-working-staff','/school-timeTable','/school-details-updation','/bonafied','/live-bus-operation','/schoolYear-data-updation'];
  final List<IconData> navIcons =[Icons.home,Icons.show_chart,Icons.currency_rupee,Icons.grade,Icons.person,Icons.school,Icons.business,Icons.people_alt_rounded ,  Icons.calendar_month,Icons.info_outline, Icons.approval_rounded ,Icons.directions_bus,Icons.restore];
  



}