import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  void _handleNavigation(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final destination = user != null ? '/home' : '/adminLogin';
    Beamer.of(context).beamToNamed(destination,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleNavigation(context),
          child: const Text("Proceed"),
        ),
      ),
    );
  }
} 