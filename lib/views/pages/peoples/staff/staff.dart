import 'package:admin_pannel/views/pages/peoples/widgets/CustomeProfileCard.dart';
import 'package:beamer/beamer.dart';
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
                customProfileCard(title: "View Details", assetLink: "assets/images/staff.jpg", onpresee: () { Beamer.of(context).beamToNamed('/manage-working-staff/viewStaffDetails');}),
               const SizedBox(width: 50), // Space between the cards
                customProfileCard(title: "Add Working Staff", assetLink: "assets/images/addUser.png", onpresee: () { Beamer.of(context).beamToNamed('/manage-working-staff/addWorkingStaff'); }),
              ],
            ),
          ],
        ),
      ),
    ); 
  }
}