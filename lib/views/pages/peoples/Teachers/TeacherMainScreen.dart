import 'package:admin_pannel/views/pages/peoples/widgets/CustomeProfileCard.dart';
import 'package:beamer/beamer.dart';
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
                customProfileCard(title: "Class Incharger", assetLink: "assets/images/teacher.png", onpresee: () { Beamer.of(context).beamToNamed('/manage-teacher/classInchargerDetails');},),
               const SizedBox(width: 50), // Space between the cards
                customProfileCard(title: "View Details", assetLink: "assets/images/teacherpic.jpg", onpresee: () { Beamer.of(context).beamToNamed('/manage-teacher/viewTeacherDetails');},),
               const SizedBox(width: 50), // Space between the cards
                customProfileCard(title: "Add Teacher", assetLink: "assets/images/addUser.png", onpresee: () { Beamer.of(context).beamToNamed('/manage-teacher/addTeacher'); },),
              ],
            ),
          ],
        ),
      ),
    );
  }
}