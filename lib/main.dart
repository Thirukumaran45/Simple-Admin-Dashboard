import 'dart:developer' show log;
import 'package:admin_pannel/SchoolWebSite/websiteMainScreen.dart';
import 'package:admin_pannel/SchoolWebSite/widgets/userAuthRedirect.dart';
import 'package:admin_pannel/controller/InitializeController.dart';
import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/views/pages/HomePage/widgets/Dashboard.dart';
import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:admin_pannel/views/pages/LoginPage/LoginScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await initializeGetController();

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


