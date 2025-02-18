import 'package:get/get.dart';

class StudentController extends GetxController {
  final List<Map<String, String>> studentData = List.generate(
    8,
    (index) => {
      'rollNumber': 'R${index + 1}',
      'name': 'Student ${index + 1}',
      'class': '${(index % 12) + 1}',
      'section': ['A', 'B', 'C', 'D'][index % 4],
      'parentMobile': '987654321$index'
    },
  );
}
