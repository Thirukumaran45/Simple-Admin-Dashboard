
import 'package:admin_pannel/views/widget/CustomNavigation.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:math';

class ClassPage extends StatefulWidget {
  final String classNumber;

  const ClassPage({
    required this.classNumber,
    super.key,
  });

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: customIconNavigation(context, '/attendance')
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttendanceCard(context, {widget.classNumber :"A"},"Completed"),
                const SizedBox(width: 20),

                    _buildAttendanceCard(context, {widget.classNumber :"B"},"UnCompleted"),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAttendanceCard(context, {widget.classNumber :"C"},"Completed"),
                const SizedBox(width: 20),

                    _buildAttendanceCard(context,{widget.classNumber :"D"},"UnCompleted"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context, Map<String,String> title, String attendacneStatus) {
    final random = Random();
    double presentPercentage = random.nextDouble() * 100;
    double absentPercentage = 100 - presentPercentage;
    int totalPresent = (presentPercentage * 5).round();
    int totalAbsent = (absentPercentage * 5).round();

    return InkWell(
      onTap: () {
        Beamer.of(context).beamToNamed( '/attendance/class/section?classNumber=${widget.classNumber}&sectionName=${title[widget.classNumber]}');
      

      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 153, 201, 241),
          borderRadius:BorderRadius.circular(30),
         boxShadow: const  [
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 10,
            color: Colors.grey
          )
        ]
          ),
                        
        width: 500,
        height: 250,
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
                 '${widget.classNumber} - ${title[widget.classNumber]}' ,
                  style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                Text(
                  "Present -  $totalPresent",
                  style: const TextStyle(fontSize:16, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 10),
      
                Text(
                  "Absent -  $totalAbsent",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
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
                        style:  TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: attendacneStatus=="Completed"? Colors.green: Colors.red),
                      ),Icon(attendacneStatus=="Completed"?Icons.done_all:Icons.pending , color: attendacneStatus=="Completed"? Colors.green: Colors.red,size: 20,)
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


