import 'package:admin_pannel/views/pages/peoples/widgets/CustomeProfileCard.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class HigherOfficialMainScreen extends StatelessWidget {
  const HigherOfficialMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center( // Center the Column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
              children: [
                customProfileCard(title: "View Details", assetLink: "assets/images/official.png", onpresee: () { Beamer.of(context).beamToNamed('/manage-higher-official/viewHigherOfficailDetails');},color: primaryGreenShadeColors),
               const SizedBox(width: 50), // Space between the cards
                customProfileCard(title: "Add Higher Officials", assetLink: "assets/images/splash.png", onpresee: () { Beamer.of(context).beamToNamed('/manage-higher-official/addOfficial'); },color: primaryGreenShadeColors),
              ],
            ),
          ],
        ),
      ),
    ); 
  }
}