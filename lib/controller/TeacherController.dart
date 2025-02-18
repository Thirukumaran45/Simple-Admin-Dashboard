import 'package:get/get.dart';

class Teachercontroller extends GetxController{
  final List<Map<String, String>> teacherData = List.generate(
    8,
    (index) => {
      'sNo': '${index + 1}',
      'name': 'Teacher ${index + 1}',
      'degree': 'Degree ${index % 5 + 1}',
      'email': 'teacher${index + 1}@school.com',
      'phone': '987654321${index % 10}'
    },
  );
}