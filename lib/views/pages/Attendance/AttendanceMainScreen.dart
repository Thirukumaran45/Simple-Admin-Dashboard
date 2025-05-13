

import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/controller/classControllers/pageControllers/AttendanceController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get, Inst;
import 'package:percent_indicator/linear_percent_indicator.dart';

class AttendanceMainScreen extends StatefulWidget {
  const AttendanceMainScreen({super.key});

  @override
  State<AttendanceMainScreen> createState() => _AttendanceMainScreenState();
}

class _AttendanceMainScreenState extends State<AttendanceMainScreen> {
  final AttendanceController controler = Get.find();
  late Future<Map<int, Map<String, String>>> futureAttendanceData;

  @override
  void initState() {
    super.initState();
    // Fetch the attendance data using the Future provided by the controller.
    futureAttendanceData = controler.totalNumberOfPresentAndAbsent();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<int, Map<String, String>>>(
        future: futureAttendanceData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
        child: AlertDialog(
         
          content: Row(
            children:  [
              Text("Please wait a moment",style: TextStyle(color: Colors.black,fontSize: 20),),
              SizedBox(width: 10),
              CircularProgressIndicator(color: Colors.green,),
            ],
          ),
        ),
      );
    }else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final attendanceData = snapshot.data!;
           
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                int classNumber = index + 1;
                double presentPercentage = 0.0;
                double absentPercentage = 0.0;

                if (attendanceData.containsKey(classNumber)) {
                  int numberOfPresent = int.tryParse(attendanceData[classNumber]?['numberOfPresent'] ?? '0') ?? 0;
                  int numberOfAbsent = int.tryParse(attendanceData[classNumber]?['numberOfAbsent'] ?? '0') ?? 0;
                  int total = numberOfPresent + numberOfAbsent;
                  if (total > 0) {
                    presentPercentage = numberOfPresent / total;
                    absentPercentage = numberOfAbsent / total;
                  }
                }

                String val = classNumber.toString();
                return InkWell(
                  onTap: () {
                    customNvigation(context, '/attendance/class?classNumber=$val');
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shadowColor: Colors.black,
                    borderOnForeground: true,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.withAlpha(120),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Class ${index + 1}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[850],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward,
                                  size: 30,
                                  color: Color.fromARGB(255, 10, 109, 190),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10),
                          child: Text(
                            'Total number of Presents',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[850],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _customeLinearProgressBar(color: Colors.green, percentage: presentPercentage),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 10),
                          child: Text(
                            'Total number of Absents',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[850],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _customeLinearProgressBar(color: Colors.red, percentage: absentPercentage)
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No data found"));
          }
        },
      ),
    );
  }
}

Widget _customeLinearProgressBar({required double percentage, required Color color}) {
  return Row(
    children: [
      LinearPercentIndicator(
        animateToInitialPercent: true,
        animationDuration: 1000,
        animation: true,
        width: 180,
        lineHeight: 13,
        percent: percentage,
        progressColor: color,
      ),
      Text(
        '${(percentage * 100).toStringAsFixed(1)} %',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );
}
