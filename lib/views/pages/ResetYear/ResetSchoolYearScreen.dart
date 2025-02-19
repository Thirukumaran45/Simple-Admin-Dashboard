import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class ResetSchoolYearScreen extends StatelessWidget {
  const ResetSchoolYearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: List.generate(12, (index) {
            return InkWell(
              onTap: (){
                Beamer.of(context).beamToNamed('/schoolYear-data-updation/sectionWiseResetHistry');
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Class ${index + 1}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 10,
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white
                          ),
                          onPressed: (){}, child: const Row(
                          children: [
                            Icon(Icons.restart_alt,color: Colors.white,size: 20,),
                            Text("Reset Data", style: TextStyle( fontWeight: FontWeight.w500),)
                          ],
                        ))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                       subtitle("Attendance Histry Reset"),
                       subtitle("Remainder Chat Histry Reset"),
                       subtitle("School Chat Histry Reset"),
                       subtitle("Exam Publish Histry Reset"),
                       subtitle("Assigment Histry Reset"),

                      ],
                    ),
                  
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

Widget subtitle(String subtitle)
{
  return Row(
    children: [
      
       Text(
        subtitle,
        textAlign: TextAlign.center,
        style:  TextStyle(fontSize: 14, color: Colors.grey[850]),
      ),
        Padding(
        padding: const EdgeInsets.symmetric(horizontal:  8.0),
        child: Container(
          height: 20,
          width: 2,
          color: Colors.grey,
        ),
      ),
    ],
  );
}