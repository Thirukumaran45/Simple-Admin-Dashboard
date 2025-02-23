import 'package:admin_pannel/provider/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';

class SectionWiseexamResutlPublish extends StatelessWidget {
  final String examName;
  const SectionWiseexamResutlPublish({super.key, required this.examName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [customIconNavigation(context, '/exam-Details-updation'),
              
              ],
            ),
            Column(
              children: List.generate(12, (index) => classRow(index + 1,context)),
            )
          ],
        ),
      ),
    );
  }

  Widget classRow(int index , BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:  8.0,vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow:const [
          BoxShadow(
            blurRadius: 5,
            color:Colors.grey
          )
        ]
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  const  Text(
                      "Publish Exam Result - ",
                      style:  TextStyle(
                        letterSpacing: 1,

                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    Text(
                      "Class $index",
                      style: const TextStyle(
                        letterSpacing: 1,
                          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Row(
              children: List.generate(4, (i) => classSectionExpanded(i,context,index.toString())),
            ),
            const SizedBox(height: 35),
           
          ],
        ),
      ),
    );
  }

  Widget classSectionExpanded(int index, BuildContext context,String stuClass) {
    List<String> sections = ["A", "B", "C", "D"];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:  18),
        child: InkWell(
          onTap: (){
            customNvigation(context, '/exam-Details-updation/sectionWiseResultPublishment/studentOverview?examName=$examName&class=$stuClass&section=${sections[index]}');
           
          },
          child: Container(
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryBlueShadeColrs,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const[
                BoxShadow(
                  offset: Offset(4, 4),
                  color: Colors.grey
                )
              ]
            ),
            child: Text(
              "Section ${sections[index]}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
