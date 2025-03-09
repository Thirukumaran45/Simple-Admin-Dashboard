
import 'package:beamer/beamer.dart';
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
            Beamer.of(context).beamToNamed('/auth'); // Navigate to auth check
          },
          child: const Text('Go to Admin Panel'),
        ),
      ),
    );
  }
}
