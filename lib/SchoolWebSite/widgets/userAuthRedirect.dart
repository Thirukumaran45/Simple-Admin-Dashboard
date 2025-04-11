import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/views/pages/HomePage/widgets/Dashboard.dart';
import 'package:admin_pannel/views/pages/LoginPage/LoginScreen.dart';
import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  
  BeamPage langingAuthPage()
  {
    return BeamPage(
  child: StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator(color: Colors.green,)); // Loading state
      }
      if (snapshot.hasData) {
        return const LandingPage(); // Authenticated user
      } else {
        return const LoginPage(); // Unauthenticated user
      }
    },
  ),
  title: 'Dashboard',
  type: BeamPageType.noTransition,
  key: const ValueKey('notfound'),
);
  }

  void authNavigate()
  {
    
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.green,)); // Loading state
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