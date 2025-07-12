import '../../../contant/CustomNavigation.dart';
import '../peoples/widgets/CustomeProfileCard.dart';

import 'package:flutter/material.dart';

class Bonafied extends StatelessWidget {
  const Bonafied({super.key});

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
                customProfileCard(false,title: "Generate Bonafied", assetLink: "assets/images/certi_2.svg", onpresee: ()=>  customNvigation(context, '/bonafied/studentBonafied')),
               const SizedBox(width: 50), // Space between the cards
                customProfileCard(false,title: "ClassWise Bonafied", assetLink: "assets/images/certi_1.svg", onpresee: ()=>customNvigation(context, '/bonafied/classWiseBonafied'))
              ],
            ),
          ],
        ),
      ),
    ); 
  }
}