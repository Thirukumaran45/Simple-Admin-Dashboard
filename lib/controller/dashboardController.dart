import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {

  
  final List<String> navItems =['Home','Attendance','Fees Update','Exam Updates','Manage Students','Manage Teachers','Manage Officials','Manage Staffs','Time table','School Details', 'Bonafied','Live Bus','Reset Year'];
  final List<String> navs=['/home','/attendance','/fees-updation','/exam-Details-updation','/manage-student','/manage-teacher','/manage-higher-official','/manage-working-staff','/school-timeTable','/school-details-updation','/bonafied','/live-bus-operation','/schoolYear-data-updation'];
  final List<IconData> navIcons =[Icons.home,Icons.show_chart,Icons.currency_rupee,Icons.calendar_today,Icons.person,Icons.school,Icons.business,Icons.people_alt_rounded ,  Icons.calendar_month,Icons.info, Icons.computer ,Icons.directions_bus,Icons.restore];
  

}