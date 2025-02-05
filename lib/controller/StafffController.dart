import 'package:get/get.dart';

class StaffController extends GetxController{
  final List<Map<String, String>> staffData = List.generate(
    60,
    (index) => {
      'sNo': '${index + 1}',
      'name': 'Staff ${index + 1}',
      'email': 'Staff${index + 1}@school.com',
      'phone': '987654321${index % 10}'
    },
  );
}