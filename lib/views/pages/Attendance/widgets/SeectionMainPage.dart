
import '../../../../contant/CustomNavigation.dart';
import '../../../../controller/classControllers/pageControllers/AttendanceController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst;
import 'package:percent_indicator/circular_percent_indicator.dart';

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
  late AttendanceController controler ;
  late Future<Map<String, Map<String, String>>> futureAttendanceData;

@override
  void initState() {
    super.initState();
   controler = Get.find<AttendanceController>();
    futureAttendanceData = controler.getSectionWiseTotalPresentAndAbsent(context,stuClass: widget.classNumber);
   
  }
@override
  void dispose() {
      controler.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
      body: FutureBuilder(
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
           
        return SingleChildScrollView(
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
                      _buildAttendanceCard(context, 
                      numberOfPresnet:attendanceData['A']?["numberOfPresent"] ??'0',
                      numberOfAbsent:attendanceData['A']?["numberOfAbsent"] ??'0' ,
                       {widget.classNumber :"A"},
                       attendanceData['A']?["status"] ??'Not Taken'),
                  const SizedBox(width: 20),
        
                      _buildAttendanceCard(context,
                       numberOfPresnet:attendanceData['B']?["numberOfPresent"] ??'0',
                      numberOfAbsent:attendanceData['B']?["numberOfAbsent"] ??'0' ,
                      
                       {widget.classNumber :"B"},attendanceData['B']?["status"] ??'Not Taken'
                       ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAttendanceCard(context,
                         numberOfPresnet:attendanceData['C']?["numberOfPresent"] ??'0',
                      numberOfAbsent:attendanceData['C']?["numberOfAbsent"] ??'0' ,
                      {widget.classNumber :"C"},
                      attendanceData['C']?["status"] ??'Not Taken'),
                  const SizedBox(width: 20),
        
                      _buildAttendanceCard(
                           numberOfPresnet:attendanceData['D']?["numberOfPresent"] ??'0',
                      numberOfAbsent:attendanceData['D']?["numberOfAbsent"] ??'0' ,
                     
                        context,{widget.classNumber :"D"},
                      attendanceData['D']?["status"] ??'Not Taken'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
        } else {
            return const Center(child: Text("No data found"));
          }
        },
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context, 
  Map<String,String> title, String attendacneStatus,
  {
    required String numberOfPresnet,
     required String numberOfAbsent,
  }) {
  
   double presentPercentage =0.0;
    int totalPresent = int.tryParse(numberOfPresnet) ?? 0;
    int totalAbsent = int.tryParse(numberOfAbsent) ?? 0;
    int total = totalPresent + totalAbsent;
                  if (total > 0) {
                    presentPercentage = totalPresent / total;
                    }
    return InkWell(
      onTap: () {
        customNvigation(context, '/attendance/class/section?classNumber=${widget.classNumber}&sectionName=${title[widget.classNumber]}');
    

      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius:BorderRadius.circular(30),
           boxShadow: const  [
            BoxShadow(
              blurRadius: 6,
              color: Colors.grey
            )
          ]
            ),
                          
          width: 460,
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
                percent: presentPercentage ,
                center: Text(
                  "${(presentPercentage * 100).toStringAsFixed(1)}%",
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
                      color:attendacneStatus=="Taken"?Colors.green:Colors.red,
                      boxShadow: const [BoxShadow(
                        blurRadius: 4
                        ,color: Colors.blue
                      )],
                      borderRadius: BorderRadius.circular(18),
                                              
        
                    ),
                    child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          attendacneStatus,
                          style: const  TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(attendacneStatus=="Taken"?Icons.done_all:Icons.pending , color: Colors.white,size: 20,),
                        )
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


