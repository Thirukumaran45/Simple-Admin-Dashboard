import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {

  
  final List<String> navItems =['Home','Attendance','Fees Update','Exam Updates','Manage Students','Manage Teachers','Manage Officials','Manage Staffs','School Updates','Live Bus','Reset Year'];
  final List<String> navs=['/home','/attendance','/fees-updation','/exam-Details-updation','/manage-student','/manage-teacher','/manage-higher-official','/manage-working-staff','/school-details-updation','/live-bus-operation','/schoolYear-data-updation'];
  final List<IconData> navIcons =[Icons.home,Icons.show_chart,Icons.currency_rupee,Icons.calendar_month,Icons.person,Icons.school,Icons.business,Icons.people_alt_rounded , Icons.info,Icons.directions_bus,Icons.delete];
  

}