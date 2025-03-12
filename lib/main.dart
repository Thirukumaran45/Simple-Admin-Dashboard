import 'dart:developer' show log;
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:admin_pannel/SchoolWebSite/websiteMainScreen.dart';
import 'package:admin_pannel/SchoolWebSite/widgets/userAuthRedirect.dart';
import 'package:admin_pannel/controller/AttendanceController.dart';
import 'package:admin_pannel/controller/FessController.dart';
import 'package:admin_pannel/controller/HigherOfficialController.dart';
import 'package:admin_pannel/controller/StafffController.dart';
import 'package:admin_pannel/controller/StudentController.dart';
import 'package:admin_pannel/controller/StudentListBonafied.dart';
import 'package:admin_pannel/controller/TeacherController.dart';
import 'package:admin_pannel/controller/dashboardController.dart';
import 'package:admin_pannel/provider/CustomNavigation.dart';
import 'package:admin_pannel/views/pages/HomePage/widgets/Dashboard.dart';
import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:admin_pannel/views/pages/LoginPage/LoginScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  initializeGetController();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
      apiKey: "AIzaSyA_TZd03d0e_JhU3SIAdgvVch2-NnxnGYc",
      authDomain: "school-5b7f0.firebaseapp.com",
      projectId: "school-5b7f0",
      storageBucket: "school-5b7f0.appspot.com",
      messagingSenderId: "715457715420",
      appId: "1:715457715420:web:953fb67940b828e00ea819",
  measurementId: "G-GGQVTBJGYG"
      ),
    );
    log("Firebase initialized successfully");
  } catch (e) {
    log("Error initializing Firebase: $e");
  }

  runApp(const MyApp());
}

Future<void> initializeGetController()async{
Get.lazyPut(()=>DashboardController()); 
    Get.lazyPut(()=>StudentController()); 
    Get.lazyPut(()=>Teachercontroller());
    Get.lazyPut(()=>Higherofficialcontroller());
    Get.lazyPut(()=>StaffController());
    Get.lazyPut(()=>FeesController());
    Get.lazyPut(()=>AttendanceController());
    Get.lazyPut(()=>StudentlistBonafiedController());
    Get.lazyPut(()=>FirebaseCollectionVariable());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
AuthWrapper authController =  const AuthWrapper();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: BeamerDelegate(
        initialPath: '/', // Start from InitialPage
       notFoundPage:authController.langingAuthPage(),
        locationBuilder: RoutesLocationBuilder(
          routes: {
            '/': (context, state, data) => const BeamPage(
          child: InitialPage(),
          title: 'NAG CBSE ERP',
          type: BeamPageType.scaleTransition,
          key: ValueKey('school web page'),
        ),
            '/auth': (context, state, data) => authController.authNavigate(), // Handles login check
            '/adminLogin': (context, state, data) => const BeamPage(
          child: LoginPage(),
          title: 'Admin Login',
          type: BeamPageType.slideRightTransition,
          key: ValueKey('admin-login'),
        ),
            '/home': (context, state, data) => const AuthGuard(child: LandingPage()),
          },
        ).call,
      ),
      routeInformationParser: BeamerParser(),
    );
  }
}



class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser == null) {
        customNvigation(context, '/adminLogin');
      }
    });

    return FirebaseAuth.instance.currentUser == null ? const SizedBox() : child;
  }
}


