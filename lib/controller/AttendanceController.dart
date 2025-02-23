
import 'package:get/get.dart';

class AttendanceController extends GetxController {
  final List<Map<String, String>> studentData = 
    // [{
    //   'rollNumber': 'R1',
    //   'name': 'Student 1',
    //   'attendanceStatus':  'Absent', // Toggle between Present & Absent
    //   'date':'2025-02-18',
    //   'month':'February'
    // },
    // {
    //   'rollNumber': 'R2',
    //   'name': 'Student 2',
    //   'attendanceStatus':  'Absent', // Toggle between Present & Absent
    //   'date': '2025-02-18',
    //   'month':'February'
    // },
    // {
    //   'rollNumber': 'R3',
    //   'name': 'Student 2',
    //   'attendanceStatus': 'Present', // Toggle between Present & Absent
    //   'date': '2025-02-18',
    
    //   'month': 'February'
    // },
    // ].obs; 

     List.generate(30, (index) {
    return {
      'rollNumber': 'R${index + 1}',
      'name': 'Student ${index + 1}',
      'attendanceStatus': index % 2 == 0 ? 'Present' : 'Absent', // Alternating attendance
      'date': '18-02-2025',
      'month': 'February',
    };
  }).obs;
}
      
