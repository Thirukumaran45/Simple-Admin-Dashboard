
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AttendanceMainScreen extends StatefulWidget {
  const AttendanceMainScreen({super.key});

  @override
  State<AttendanceMainScreen> createState() => _AttendanceMainScreenState();
}

class _AttendanceMainScreenState extends State<AttendanceMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GridView.builder(
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
          int classNumber = index+1;
          String val = classNumber.toString();
          return GestureDetector(
            onTap: () {
            Beamer.of(context).beamToNamed('/attendance/class?classNumber=$val');

            

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
                        color:Colors.blue.withAlpha(120),
                        borderRadius: BorderRadius.circular(15)
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row( 
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Class ${index + 1}',
                            style:  TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[850],
                            ),
                          ),
                          const Icon(Icons.arrow_forward,size: 30,color: Color.fromARGB(255, 10, 109, 190),)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                   Padding(
                    padding:const EdgeInsets.only( top: 10,left: 10),
                    child: Text('Total number of Presents' ,style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[850],
                      ),),
                  ),
                  const SizedBox(height:  8,),
                            
                 _customeLinearProgressBar(color: Colors.green,percentage: presentPercentage),
                   Padding(
                    padding: const EdgeInsets.only(top: 20,left: 10),
                    child: Text('Total number of Absents' ,style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[850],
                      ),),
                  ),
                  const SizedBox(height:  8,),
                            
                  _customeLinearProgressBar(color: Colors.red,percentage: absentPercentage)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


Widget _customeLinearProgressBar( {required percentage, required Color color })
{

  return    Row(
                    children: [
                      LinearPercentIndicator(animateToInitialPercent: true,
                      
                          animationDuration: 1000,
                        animation: true,
                        width: 200,
                        lineHeight: 13,
                        percent: percentage,
                        progressColor:color,
                      ), Text( '${percentage*10} %' ,style:   TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),),
                    ],
                  );
}