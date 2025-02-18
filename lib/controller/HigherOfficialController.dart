import 'package:get/get.dart';

class Higherofficialcontroller extends GetxController {

  final List<Map<String, String>> officialData = List.generate(
    8,
    (index) => {
      'sNo': '${index + 1}',
      'name': 'Higher Official ${index + 1}',
      'degree': 'Degree ${index % 5 + 1}',
      'email': 'teacher${index + 1}@school.com',
      'phone': '987654321${index % 10}'
    },
  );

}