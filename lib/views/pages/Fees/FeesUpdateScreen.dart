import '../../../contant/CustomNavigation.dart';
import '../peoples/widgets/CustomeProfileCard.dart';
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
              children: [ customProfileCard(true,title: "Bank account Data", assetLink: "assets/images/bank.svg", onpresee: ()  => customNvigation(context, '/fees-updation/bankDetails')), 
               const SizedBox(width: 50), // Space between the cards
             
                customProfileCard(false,title: "Fees Transaction Histry", assetLink:"assets/images/transactionHistry.svg", onpresee: () => customNvigation(context, '/fees-updation/feesTransactionHistry') ),
               const SizedBox(width: 50), // Space between the cards
                customProfileCard(false,title: "Student Fees Updation", assetLink: "assets/images/studentFees.svg", onpresee: () => customNvigation(context, '/fees-updation/sectionWiseFeesUpdation')),
              ],
            ),
          ],
        ),
      ),
    ); 
  }
}
