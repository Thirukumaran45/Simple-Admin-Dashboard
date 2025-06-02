import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

class BusUpdateMainScreen extends StatelessWidget {
  const BusUpdateMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
                     placeholderBuilder: (context) => const CircularProgressIndicator(color: Colors.green,), 
              'assets/images/bus.svg', // Replace with your image path
              width: 350, // Adjust size as needed
              height: 350,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 25),
            const Text(
              'Currently, no live bus service is provided !',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
