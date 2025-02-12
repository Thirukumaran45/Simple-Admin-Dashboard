import 'package:admin_pannel/views/pages/HomePage/widgets/barGraph.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    List<double> monthFeesAmt = [
      2000000, // ₹20L
      3500000, // ₹35L
      4000000, // ₹40L
      5500000, // ₹55L
      6000000, // ₹60L
      7200000, // ₹72L
      8500000, // ₹85L
      9000000, // ₹90L
      10200000, // ₹102L
      11000000, // ₹110L
      12500000, // ₹125L
      13000000, // ₹130L
    ];
    double lastAmtVal = monthFeesAmt[monthFeesAmt.length - 1];
    // Parse the string values to double
    double teacherPercentage = double.parse("80");
    double studentPercentage = double.parse("1000");
    double workerPercentage = double.parse("50");

    // Calculate the total
    double total = teacherPercentage + studentPercentage + workerPercentage;

    // Calculate the percentages for the pie chart
    double teacherAvg = (teacherPercentage / total) * 100;
    double studentAvg = (studentPercentage / total) * 100;
    double workerAvg = (workerPercentage / total) * 100;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            _buildDashboardcards(),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: buildLineChart(monthFeesAmt)),
                 const SizedBox(width: 20,),
                Expanded(
                  flex: 1,
                  child: buildPieChart(teacherAvg, studentAvg, workerAvg, lastAmtVal, teacherVal: teacherPercentage,studentVal: studentPercentage,workerVal: workerPercentage)),
               
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardcards() {
    return Row(
      children: [
        _buildCard("Number of Students", "1000", Icons.people, Colors.blue),
        _buildCard("Number of Teachers ", "80", Icons.school, Colors.red),
        _buildCard("Number of Staffs", "50", Icons.business_center,
            Colors.orange),
        _buildCard(
            "Number of Vechiles", "10", Icons.directions_bus, Colors.green),
      ],
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      flex: 4,
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: color.withAlpha(80),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style:const  TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )
          ],
        ),
      ),
    ));
  }
}
