
import 'package:admin_pannel/provider/CustomNavigation.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

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
