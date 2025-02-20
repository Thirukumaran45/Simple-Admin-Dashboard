import 'package:get/get.dart';

class StudentlistBonafiedController extends GetxController {
  final List<Map<String, String>> studentData = List.generate(
    5,
   (index) => {
      'rollNumber': 'R${index + 1}',
      'name': 'Student ${index + 1}',
      'class': '${(index % 12) + 1}',
      'section': ['A', 'B', 'C', 'D'][index % 4],
      'feesStatus': index % 2 == 0 ? 'Paid' : 'Unpaid',
    },
  );
}

