
import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            customNvigation(context, "/adminLogin");
          },
          child: const Text('Go to Admin Panel'),
        ),
      ),
    );
  }
}
