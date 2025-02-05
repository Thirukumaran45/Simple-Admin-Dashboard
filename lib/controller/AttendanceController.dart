
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceController extends GetxController {
  final List<Map<String, String>> studentData = List.generate(
    60,
    (index) => {
      'rollNumber': 'R${index + 1}',
      'name': 'Student ${index + 1}',
      'attendanceStatus': ['Present', 'Absent'][index % 2], // Toggle between Present & Absent
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: index % 31))),
      'month': DateFormat('MMMM').format(DateTime.now().subtract(Duration(days: index % 31))),
    },
  ).obs;
}
