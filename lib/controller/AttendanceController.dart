
import 'package:get/get.dart';

class AttendanceController extends GetxController {
  final List<Map<String, String>> studentData = 
    [{
      'rollNumber': 'R1',
      'name': 'Student 1',
      'attendanceStatus':  'Absent', // Toggle between Present & Absent
      'date':'2025-02-18',
      'month':'February'
    },
    {
      'rollNumber': 'R2',
      'name': 'Student 2',
      'attendanceStatus':  'Absent', // Toggle between Present & Absent
      'date': '2025-02-18',
      'month':'February'
    },
    {
      'rollNumber': 'R3',
      'name': 'Student 2',
      'attendanceStatus': 'Present', // Toggle between Present & Absent
      'date': '2025-02-18',
    
      'month': 'February'
    },
    ].obs; 
}
      
