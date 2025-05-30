import 'package:admin_pannel/controller/classControllers/schoolDetailsController/pushNotificationController.dart';
import 'package:admin_pannel/utils/ExceptionDialod.dart';

import 'widgets/barGraph.dart';
import 'package:flutter/material.dart';
import '../../../services/FireBaseServices/CollectionVariable.dart';
import 'package:get/get.dart' show Get, Inst;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late FirebaseCollectionVariable collectionControler;
  Map<String, dynamic> numberOfPeopleMap = {}; // Store results here
  late PushNotificationControlelr notificationControlelr;
  @override
  void initState() {
    super.initState();
    notificationControlelr = Get.find<PushNotificationControlelr>();
    collectionControler = Get.find<FirebaseCollectionVariable>();
    fetchData();
  }

  Future<void> fetchData() async {
    List<String> categories = ['officials', 'staffs', 'teachers', 'students'];

    for (String category in categories) {
      final  docSnapshot =
          await collectionControler.loginCollection.doc(category).get();

      if (docSnapshot.exists) {
        setState(() {
          // Ensure numberOfPeople is always stored as a String
          var data = docSnapshot['numberOfPeople'];
          numberOfPeopleMap[category] = (data is String) ? data : data.toString();
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {

  // Parse numberOfPeople values to double, ensuring they are not null or empty
  double teacherPercentage = double.tryParse(numberOfPeopleMap["teachers"] ?? "0") ?? 0;
  double studentPercentage = double.tryParse(numberOfPeopleMap["students"] ?? "0") ?? 0;
  double workerPercentage = double.tryParse(numberOfPeopleMap["staffs"] ?? "0") ?? 0;
  double officialsPercentage = double.tryParse(numberOfPeopleMap["officials"] ?? "0") ?? 0;
  
  // Calculate the total
  double total = teacherPercentage + studentPercentage + workerPercentage + officialsPercentage;

  // Prevent division by zero error
  double teacherAvg = total > 0 ? (teacherPercentage / total) * 100 : 0;
  double studentAvg = total > 0 ? (studentPercentage / total) * 100 : 0;
  double workerAvg = total > 0 ? (workerPercentage / total) * 100 : 0;
  double officialAvg = total > 0 ? (officialsPercentage / total) * 100 : 0;


    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDashboardcards(),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                    flex: 1, child: buildLineChart(onPressed: () async{
                    await ExceptionDialog().handleExceptionDialog(context, ()async=>  notificationControlelr.feeUpdationPushNotificationToAll(context));
                    },)),
                const SizedBox(width: 20),
                Expanded(
                    flex: 2,
                    child: buildPieChart(teacherAvg, studentAvg, workerAvg,
                    officialval:officialsPercentage,
                    officialAvg,
                        teacherVal: teacherPercentage,
                        studentVal: studentPercentage,
                        workerVal: workerPercentage)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardcards() {
    return Row(
      children: [
        _buildCard("Number of Students", numberOfPeopleMap["students"], Icons.people, Colors.blue),
        _buildCard("Number of Teachers ", numberOfPeopleMap["teachers"], Icons.school, Colors.red),
        _buildCard("Number of Staffs", numberOfPeopleMap["staffs"], Icons.business_center,
            Colors.orange),
        _buildCard(
            "Number of Officials", numberOfPeopleMap["officials"], Icons.star, Colors.green),
      ],
    );
  }
Widget _buildCard(String title, String? value, IconData icon, Color color) {
  return Expanded(
    flex: 4,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).toInt()), // softer background
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha((0.3 * 255).toInt()),
            offset: const Offset(0, 4),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: color.withAlpha((0.4 * 255).toInt()), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value ?? "0",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: color.darken(0.2), // subtle dark shade of main color
              ),
            )
          ],
        ),
      ),
    ),
  );
}

}
extension ColorUtils on Color {
  /// Darkens the color by the given [amount] (between 0 and 1).
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
