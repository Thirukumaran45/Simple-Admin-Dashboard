import '../../../../contant/CustomNavigation.dart';
import '../widgets/CustomeProfileCard.dart';
import 'package:flutter/material.dart';



class StudentMainScreen extends StatelessWidget {
  const StudentMainScreen({super.key});

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
                customProfileCard(false,title: "View Student Details", assetLink: "assets/images/studentDetails.svg", onpresee: ()=>customNvigation(context, '/manage-student/viewStudentDetails')), 
               const SizedBox(width: 50), // Space between the cards
                customProfileCard(false,title: "Add Student", assetLink: "assets/images/adduser.svg", onpresee: ()=>customNvigation(context, '/manage-student/addStudent')), 
              ],
            ),
          ],
        ),
      ),
    ); 
  }
}