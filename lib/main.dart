import 'package:admin_pannel/controller/AttendanceController.dart';
import 'package:admin_pannel/controller/HigherOfficialController.dart';
import 'package:admin_pannel/controller/StafffController.dart';
import 'package:admin_pannel/controller/StudentController.dart';
import 'package:admin_pannel/controller/TeacherController.dart';
import 'package:admin_pannel/controller/dashboardController.dart';
import 'package:admin_pannel/views/pages/HomePage/widgets/Dashboard.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeGetController();
  runApp( MyApp());
}

Future<void> initializeGetController()async{
Get.lazyPut(()=>DashboardController()); 
    Get.lazyPut(()=>StudentController()); 
    Get.lazyPut(()=>Teachercontroller());
    Get.lazyPut(()=>Higherofficialcontroller());
    Get.lazyPut(()=>StaffController());
    Get.lazyPut(()=>AttendanceController());
}
class MyApp extends StatelessWidget {
   MyApp({super.key});


final routeDelegate = BeamerDelegate(transitionDelegate: const  NoAnimationTransitionDelegate(),locationBuilder: 
RoutesLocationBuilder(routes: {
  "/*":(context , state, data)=> const LandingPage(),
}).call);
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: BeamerParser(),
      routerDelegate: routeDelegate,
    );
  }
}

