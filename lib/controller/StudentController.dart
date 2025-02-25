import 'package:get/get.dart';

class StudentController extends GetxController {
  final List<Map<String, String>> studentData = List.generate(
    30,
    (index) => {
      'rollNumber': 'R${index + 1}',
      'name': 'Student ${index + 1}',
      'class': '${(index % 12) + 1}',
      'section': ['A', 'B', 'C', 'D'][index % 4],
      'parentMobile': '987654321$index',
      'totalFees':"30000",
      "dateOfBirth":"04-12-2003",
      'parentName':'Raman.k'

    },
  );
}
