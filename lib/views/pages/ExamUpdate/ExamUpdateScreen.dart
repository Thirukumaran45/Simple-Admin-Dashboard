
import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:flutter/material.dart';

class ExamUpdateScreen extends StatelessWidget {
  const ExamUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
          
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildExamCard('First Revision Exam',  Colors.orange,context),
                  ),
                  Expanded(
                    child: _buildExamCard('Second Revision Exam', Colors.blue,context),
                  ),
                  Expanded(
                    child: _buildExamCard('Third Revision Exam', Colors.pink,context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildExamCard('Quarterly Exam', Colors.purple,context),
                  ),
                  Expanded(
                    child: _buildExamCard('Half yearly Exam', Colors.red,context),
                  ),
                  Expanded(
                    child: _buildExamCard('Annual Exam', Colors.teal,context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamCard(String title, Color color,BuildContext context) {
    return InkWell(
      onTap: (){
        customNvigation(context, '/exam-Details-updation/sectionWiseResultPublishment?examName=$title');
        },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow:  const [
            BoxShadow(
              color:Colors.grey,
              blurRadius: 10,
              offset:   Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
          const   Padding(
               padding:  EdgeInsets.all(8.0),
               child:  Icon(
                  Icons.school , color: Colors.white,
                ),
             ),
              Text(
                title,
                style: const TextStyle(
                 letterSpacing: 1,
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
