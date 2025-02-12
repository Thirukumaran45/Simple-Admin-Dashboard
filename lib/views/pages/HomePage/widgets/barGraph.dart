import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

Widget _buildChartContainer({required String title, required Widget chart}) {
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
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 80,
        ),
        SizedBox(
          height: 200,
          child: chart,
        )
      ],
    ),
  );
}

Widget buildPieChartData(double teacherAvg, double studentAvg, double workerAvg,
    {required teacherVal,
    required studentVal,
    required workerVal,
    required double feeAmtVal}) {
  return  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      const SizedBox(height: 8),
      _buildDataOverviewRow(
        '',
        color: Colors.redAccent,
        text: "Teacher",
        val: teacherVal,
        valAvg: teacherAvg,
        isIcon: false,
      ),
      _buildDataOverviewRow(
        color: Colors.blueAccent,
        text: "Student",
        val: studentVal,
        valAvg: studentAvg,
        isIcon: false,
        '',
      ),
      _buildDataOverviewRow(
        color: Colors.orangeAccent,
        text: "Working Staff",
        val: workerVal,
        valAvg: workerAvg,
        isIcon: false,
        '',
      ),
      _buildDataOverviewRow(
        color: Colors.blue,
        text: "Fee Amount ",
        val: feeAmtVal,
        valAvg: workerAvg,
        isIcon: true,
        Icons.show_chart_outlined,
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
  required bool isIcon,
}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        isIcon
            ? Icon(
                icon,
                color: color,
              )
            : Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
        const SizedBox(width: 10),
        isIcon
            ? Text(
                '$text: $val',
                style: TextStyle(fontSize: 16,  color: Colors.grey[950]),
              )
            : Text(
                "$text : $val (${valAvg.toStringAsFixed(1)}%)",
                style:  TextStyle(fontSize: 16, color: Colors.grey[950]),
              ),
      ],
    ),
  );
}
Widget buildPieChart(double teacherAvg, double studentAvg, double workerAvg, double lastAmtVal,  {required teacherVal,
    required studentVal,
    required workerVal,}) {
  return _buildChartContainer(
    chart: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0,bottom: 20),
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 70,
                sections: [
                  PieChartSectionData(
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
                    value: workerAvg,
                    color: Colors.orangeAccent,
                    title: "${workerAvg.toStringAsFixed(1)}%",
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 60),
        Expanded(
          flex: 4,
          child: buildPieChartData(
            teacherAvg,
            studentAvg,
            workerAvg,
            studentVal: studentVal,
            teacherVal: teacherVal,
            workerVal: workerVal,
            feeAmtVal: lastAmtVal,
          ),
        ),
      ],
    ),
    title: 'Number of People Overview',
  );
}

Widget buildLineChart(List<double> monthlyRevenue) {
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  return _buildChartContainer(
    title: "Fees Revenue Overview",
    chart: LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < months.length) {
                  return Text(
                    months[value.toInt()],
                    style:  TextStyle(fontSize: 12, color: Colors.grey[950]),
                  );
                }
                return const SizedBox(); // Prevent index out of range
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40, // Adjusted for wider text
              getTitlesWidget: (value, meta) => Text(
                '₹${(value.toInt())}L', // Display value in lakhs
                style:  TextStyle(fontSize: 12, color: Colors.grey[950]),
              ),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              monthlyRevenue.length,
              (index) => FlSpot(index.toDouble(),
                  monthlyRevenue[index] / 100000), // Convert to lakhs
            ),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withAlpha(60),
            ),
          )
        ],
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchBarSpots) {
              return touchBarSpots.map((barSpot) {
                final flSpot = barSpot;
                return LineTooltipItem(
                  '₹${(flSpot.y * 100000).toStringAsFixed(0)}', // Show exact value in lakhs
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
      ),
    ),
  );
}
