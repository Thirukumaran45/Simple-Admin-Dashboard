import 'package:admin_pannel/views/pages/peoples/widgets/CustomeProfileCard.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class FeesUpdateScreen extends StatelessWidget {
  const FeesUpdateScreen({super.key});

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
              children: [ customProfileCard(title: "Bank account Data", assetLink: "assets/images/bank.jpg", onpresee: () { Beamer.of(context).beamToNamed('/fees-updation/bankDetails');}),
               const SizedBox(width: 50), // Space between the cards
             
                customProfileCard(title: "Fees Transaction Histry", assetLink: "assets/images/feeHistry.jpg", onpresee: () { Beamer.of(context).beamToNamed('/fees-updation/feesTransactionHistry');}),
               const SizedBox(width: 50), // Space between the cards
                customProfileCard(title: "Student Fees Updation", assetLink: "assets/images/feeUpdate.jpg", onpresee: () { Beamer.of(context).beamToNamed('/fees-updation/sectionWiseFeesUpdation'); }),
              ],
            ),
          ],
        ),
      ),
    ); 
  }
}
