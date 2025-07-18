import '../../../../contant/CustomNavigation.dart';
import '../widgets/CustomeProfileCard.dart';
import 'package:flutter/material.dart';



class StaffMainScreen extends StatelessWidget {
  const StaffMainScreen({super.key});

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
                customProfileCard(false,title: "View Staff Details", assetLink: "assets/images/staff.svg", onpresee: ()=> customNvigation(context, '/manage-working-staff/viewStaffDetails')), 
               const SizedBox(width: 50), // Space between the cards
                customProfileCard(false,title: "Add Working Staff", assetLink: "assets/images/adduser.svg", onpresee: ()=>customNvigation(context, '/manage-working-staff/addWorkingStaff')), 
              ],
            ),
          ],
        ),
      ),
    ); 
  }
}