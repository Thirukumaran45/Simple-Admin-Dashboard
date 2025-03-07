import 'dart:developer' show log;
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:admin_pannel/SchoolWebSite/websiteMainScreen.dart';
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
        apiKey: "AIzaSyAVzXALmSlUAxNGUN5A2VlJdZ4ELnggq6I",
        projectId: "school-5b7f0",
        messagingSenderId: "715457715420",
        appId: "1:715457715420:web:b1964a0d8843034d0ea819",
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
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: BeamerDelegate(
        initialPath: '/initialPage', // Start from InitialPage
        notFoundPage: const BeamPage(
          child: LandingPage(),
          title: 'Dashboard',
          type: BeamPageType.noTransition,
          key: ValueKey('landingpage'),
        ),
        locationBuilder: RoutesLocationBuilder(
          routes: {
            '/initialPage': (context, state, data) => const BeamPage(
          child: MainPage(),
          title: 'NAG CBSE ERP',
          type: BeamPageType.scaleTransition,
          key: ValueKey('school web page'),
        ),
            '/auth': (context, state, data) => const AuthWrapper(), // Handles login check
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



class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Loading state
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (snapshot.hasData) {
            customNvigation(context, '/home');
          } else {
            customNvigation(context, '/adminLogin');
          }
        });

        return const SizedBox(); // Avoid unnecessary UI rendering
      },
    );
  }
}

class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      Beamer.of(context).beamToNamed('/adminLogin');
      return const SizedBox(); 
    }
    
    return child;
  }
}

