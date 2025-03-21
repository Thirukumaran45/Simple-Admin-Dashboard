import 'package:admin_pannel/provider/CustomNavigation.dart';
import 'package:admin_pannel/views/pages/peoples/widgets/CustomeProfileCard.dart';
import 'package:flutter/material.dart';



class TeacherMainScreen extends StatelessWidget {
  const TeacherMainScreen({super.key});

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
                customProfileCard( true,title: "Class Incharger Details", assetLink: "assets/images/teacher.jpg", onpresee: () => customNvigation(context, '/manage-teacher/classInchargerDetails')), 
               const SizedBox(width: 50), // Space between the cards
                customProfileCard(false,title: "View  Teachers Details", assetLink: "assets/images/teacherpic.jpg", onpresee: () => customNvigation(context, '/manage-teacher/viewTeacherDetails')),
               const SizedBox(width: 50), // Space between the cards
                customProfileCard(false,title: "Add Teacher", assetLink: "assets/images/addUser.png", onpresee: ()=> customNvigation(context, '/manage-teacher/addTeacher')), 
              ],
            ),
          ],
        ),
      ),
    );
  }
}