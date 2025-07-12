import 'package:admin_pannel/views/pages/HomePage/widgets/timer.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

Widget _buildChartContainer({required String title, required Widget chart, required IconData icon }) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ]),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
                Icon(icon) ,
               const SizedBox(width: 20,),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          height: 200,
          child: chart,
        )
      ],
    ),
  );
}

Widget buildPieChartData(double teacherAvg, double studentAvg, double workerAvg,double officialAvg,
    {required teacherVal,
    required officialval,
    required studentVal,
    required workerVal,}) {
  return  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildDataOverviewRow(
        '',
        color: Colors.redAccent,
        text: "Teacher",
        val: teacherVal,
        valAvg: teacherAvg,
      ),
      _buildDataOverviewRow(
        color: Colors.blueAccent,
        text: "Student",
        val: studentVal,
        valAvg: studentAvg,
        '',
      ),
      _buildDataOverviewRow(
        color: Colors.orangeAccent,
        text: "Working Staff",
        val: workerVal,
        valAvg: workerAvg,
        '',
      ),_buildDataOverviewRow(
        color: Colors.green,
        text: "Higher Official",
        val: officialval,
        valAvg: officialAvg,
        '',
      ),
      
    ],
  );
}

Widget _buildDataOverviewRow(
  dynamic icon, {
  required Color color,
  required String text,
  required dynamic val,
  required double valAvg,
}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color,boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 4),
                  blurRadius: 8,
                ),
              ],),
              ),
        const SizedBox(width: 10),
        
            Text(
                "$text : $val (${valAvg.toStringAsFixed(1)}%)",
                style:  TextStyle(fontSize: 16, color: Colors.grey[950]),
              ),
      ],
    ),
  );
}
Widget buildPieChart(double teacherAvg, double studentAvg, double workerAvg, double officialAvg,  
{required teacherVal,
required officialval,
    required studentVal,
    required workerVal,}) {
      double totalpeople = teacherVal+studentVal+workerVal+officialval;
  return _buildChartContainer(
    icon: Icons.apartment,
    chart: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0,bottom: 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 60,
                    
                    sections: [
                      PieChartSectionData(
                        radius: 50,
                        value: teacherAvg,
                        color: Colors.redAccent,
                        title: "${teacherAvg.toStringAsFixed(1)}%",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PieChartSectionData(
                        radius: 50,
                        value: studentAvg,
                        color: Colors.blueAccent,
                        title: "${studentAvg.toStringAsFixed(1)}%",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PieChartSectionData(
                        radius: 50,
                        value: workerAvg,
                        color: Colors.orangeAccent,
                        title: "${workerAvg.toStringAsFixed(1)}%",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ), PieChartSectionData(
                        radius: 50,
                        value: officialAvg,
                        color: Colors.green,
                        title: "${officialAvg.toStringAsFixed(1)}%",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                  Text(
      '$totalpeople',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 60),
        Expanded(
          flex: 4,
          child: buildPieChartData(
            officialAvg,
            teacherAvg,
            studentAvg,
            workerAvg,
            officialval: officialval,
            studentVal: studentVal,
            teacherVal: teacherVal,
            workerVal: workerVal,
          ),
        ),
      ],
    ),
    title: 'Total strength in school ',
  );
}



Widget buildLineChart({required void Function() onPressed}) {
  return _buildChartContainer(
    icon: Icons.campaign,
    title: "Alert unpaymnet fees",
    chart:AutomatedButtonWithTimer(onPressed:  onPressed),

  );
}