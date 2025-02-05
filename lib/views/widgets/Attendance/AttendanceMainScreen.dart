import 'package:admin_pannel/views/widgets/Attendance/widgets/SeectionMainPage.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AttendanceMainScreen extends StatelessWidget {
  const AttendanceMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            double presentPercentage = 0.7; // Example data
            double absentPercentage = 0.3;
            
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassPage(classNumber: index + 1),
                  ),
                );
              },
              child: Card(
                color: const Color.fromARGB(255, 250, 224, 184),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                      child: Container(
                        decoration: BoxDecoration(
                          color:const Color.fromARGB(255, 107, 188, 255),
                          borderRadius: BorderRadius.circular(15)
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Class ${index + 1}',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20,),
                            const Icon(Icons.arrow_forward,size: 30,)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    const Padding(
                      padding: EdgeInsets.only(right: 150),
                      child: Text('Total number of Presents' ,style:  TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),),
                    ),
                    const SizedBox(height:  15,),
                              
                    Row(
                      children: [
                        LinearPercentIndicator(
                            animateToInitialPercent: true,
                            animationDuration: 1000,
                          animation: true,
                          width: 280,
                          lineHeight: 13,
                          percent: presentPercentage,
                          progressColor: Colors.green,
                        ),
                        Text( '${presentPercentage*10} %' ,style:  const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),),
                      ],
                    ),
                    const SizedBox(height: 40), 
                    const Padding(
                      padding: EdgeInsets.only(right: 150),
                      child: Text('Total number of Absents' ,style:  TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),),
                    ),
                    const SizedBox(height:  15,),
                              
                    Row(
                      children: [
                        LinearPercentIndicator(animateToInitialPercent: true,
                            animationDuration: 1000,
                          animation: true,
                          width: 280,
                          lineHeight: 13,
                          percent: absentPercentage,
                          progressColor: Colors.red,
                        ), Text( '${absentPercentage*10} %' ,style:  const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
