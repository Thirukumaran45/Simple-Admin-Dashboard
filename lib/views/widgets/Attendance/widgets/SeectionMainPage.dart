import 'package:admin_pannel/views/widgets/Attendance/widgets/AttendanceDownloadPage.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:math';

class ClassPage extends StatelessWidget {
  final int classNumber;

  const ClassPage({
    required this.classNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Class $classNumber Attendance',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttendanceCard(context, "Section A","Completed"),
                  _buildAttendanceCard(context, "Section B","UnCompleted"),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttendanceCard(context, "Section C","Completed"),
                  _buildAttendanceCard(context, "Section D","UnCompleted"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context, String title, String attendacneStatus) {
    final random = Random();
    double presentPercentage = random.nextDouble() * 100;
    double absentPercentage = 100 - presentPercentage;
    int totalPresent = (presentPercentage * 5).round();
    int totalAbsent = (absentPercentage * 5).round();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AttendanceDownloadPage()),
        );
      },
      child: Card(                color: const Color.fromARGB(255, 250, 224, 184),

        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: 500,
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularPercentIndicator(
                animation: true,
                animateToInitialPercent: true,
                animationDuration: 1000,
                radius: 100,
                lineWidth: 30,
                percent: presentPercentage / 100,
                center: Text(
                  "${presentPercentage.toStringAsFixed(1)}%",
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                progressColor: Colors.green,
                backgroundColor: Colors.red,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Present -  $totalPresent",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    "Absent -  $totalAbsent",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
 const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      boxShadow: const [BoxShadow(
                        offset: Offset(0, 4)
                        ,color: Colors.grey
                      )],
                      borderRadius: BorderRadius.circular(18),
                                               color:Colors.white,

                    ),
                    child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          attendacneStatus,
                          style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: attendacneStatus=="Completed"? Colors.green: Colors.red),
                        ),Icon(attendacneStatus=="Completed"?Icons.done_all:Icons.pending , color: attendacneStatus=="Completed"? Colors.green: Colors.red,size: 20,)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


