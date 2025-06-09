import 'package:fl_chart/fl_chart.dart';
import 'package:admin_pannel/SchoolWebSite/widgets/customWebcolor.dart';
import 'package:flutter/material.dart';

class ExamScoreSection extends StatelessWidget {
  const ExamScoreSection({super.key});

  Widget buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Text(
          label,
          style:AppTextStyles.headers
        ),
        const SizedBox(height: 37,)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Average Board Exam Results',
            style: AppTextStyles.aboutUsStyle,
          ),
          const SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 10th Grade Result Card
              Expanded(
                child: Card(
          color: Colors.grey.shade200,

                  shadowColor: Colors.orange,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                         Text('10th Grade Results', style: AppTextStyles.headers),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 40), // Left gap
                            SizedBox(
                              height: 300,
                              width: 300,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(value: 10,title:'20 %' ,  color: AppTextStyles().primaryGreenColors, radius: 70,titleStyle:  const TextStyle(fontWeight:FontWeight.bold ,color: Colors.white)),
                                    PieChartSectionData(value: 20,title:'20 %' ,   color: Colors.orange, radius: 70,titleStyle:  const TextStyle(fontWeight:FontWeight.bold ,color: Colors.white)),
                                    PieChartSectionData(value: 30,title:'30 %' ,   color: Colors.blue, radius: 70,titleStyle:  const TextStyle(fontWeight:FontWeight.bold ,color: Colors.white)),
                                    PieChartSectionData(value: 40,title:'30 %' ,   color: Colors.purple, radius: 70,titleStyle:  const TextStyle(fontWeight:FontWeight.bold ,color: Colors.white)),
                                  ],
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 70,
                                ),
                              ),
                            ),
                            const SizedBox(width: 50,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildLegend(AppTextStyles().primaryGreenColors, 'Scored above 450'),
                                const SizedBox(height: 8),
                                buildLegend(Colors.orange, 'Scored above 400'),
                                const SizedBox(height: 8),
                                buildLegend(Colors.blue, 'Scored above 350'),
                                const SizedBox(height: 8),
                                buildLegend(Colors.purple, 'Scored above 300'),
                              ],
                            ),
                            const SizedBox(width: 16), // Right gap
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 20),

              // 12th Grade Result Card
              Expanded(
                child: Card(
                  elevation: 20,
               color: Colors.grey.shade200,
                  shadowColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                         Text('12th Grade Results', style:AppTextStyles.headers),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 40), // Left gap
                            SizedBox(
                              height: 300,
                              width: 300,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(value: 20,title:'20 %' ,  color: AppTextStyles().primaryGreenColors, radius: 70,titleStyle:  const TextStyle(fontWeight:FontWeight.bold ,color: Colors.white)),
                                    PieChartSectionData(value: 20,title:'20 %' ,   color: Colors.orange, radius: 70,titleStyle:  const TextStyle(fontWeight:FontWeight.bold ,color: Colors.white)),
                                    PieChartSectionData(value: 30,title:'30 %' ,   color: Colors.blue, radius: 70,titleStyle:  const TextStyle(fontWeight:FontWeight.bold ,color: Colors.white)),
                                    PieChartSectionData(value: 30,title:'30 %' ,   color: Colors.purple, radius: 70,titleStyle:  const TextStyle(fontWeight:FontWeight.bold ,color: Colors.white)),
                                 ],
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 70,
                                ),
                              ),
                            ),
                            const SizedBox(width: 50,),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildLegend(AppTextStyles().primaryGreenColors, 'Scored above 450'),
                                const SizedBox(height: 8),
                                buildLegend(Colors.orange, 'Scored above 400'),
                                const SizedBox(height: 8),
                                buildLegend(Colors.blue, 'Scored above 350'),
                                const SizedBox(height: 8),
                                buildLegend(Colors.purple, 'Scored above 300'),
                              ],
                            ),
                            const SizedBox(width: 16), // Right gap
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

