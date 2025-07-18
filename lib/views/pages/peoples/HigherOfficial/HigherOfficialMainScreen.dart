import '../../../../contant/CustomNavigation.dart';
import '../widgets/CustomeProfileCard.dart';
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
                customProfileCard(false,title: "View Officials Details", assetLink: "assets/images/official.svg", onpresee: ()=> customNvigation(context, '/manage-higher-official/viewHigherOfficailDetails')), 
               const SizedBox(width: 50), // Space between the cards
                customProfileCard(false,title: "Add Higher Officials", assetLink: "assets/images/adduser.svg", onpresee: () => customNvigation(context, '/manage-higher-official/addOfficial') ),
              ],
            ),
          ],
        ),
      ),
    ); 
  }
}