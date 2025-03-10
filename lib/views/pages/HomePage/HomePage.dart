import 'package:admin_pannel/views/pages/HomePage/widgets/barGraph.dart';
import 'package:flutter/material.dart';
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:get/get.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late FirebaseCollectionVariable collectionControler;
  Map<String, dynamic> numberOfPeopleMap = {}; // Store results here

  @override
  void initState() {
    super.initState();
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

    print("Fetched Data: $numberOfPeopleMap"); // Debugging purpose
  }

  @override
  Widget build(BuildContext context) {
    List<double> monthFeesAmt = [
      2000000, // ₹20L
      3500000, // ₹35L
      4000000, // ₹40L
      5500000, // ₹55L
      6000000, // ₹60L
      7200000, // ₹72L
      8500000, // ₹85L
      9000000, // ₹90L
      10200000, // ₹102L
      11000000, // ₹110L
      12500000, // ₹125L
      13000000, // ₹130L
    ];
    double lastAmtVal = monthFeesAmt[monthFeesAmt.length - 1];
  // Parse numberOfPeople values to double, ensuring they are not null or empty
  double teacherPercentage = double.tryParse(numberOfPeopleMap["teachers"] ?? "0") ?? 0;
  double studentPercentage = double.tryParse(numberOfPeopleMap["students"] ?? "0") ?? 0;
  double workerPercentage = double.tryParse(numberOfPeopleMap["staffs"] ?? "0") ?? 0;
  
  // Calculate the total
  double total = teacherPercentage + studentPercentage + workerPercentage;

  // Prevent division by zero error
  double teacherAvg = total > 0 ? (teacherPercentage / total) * 100 : 0;
  double studentAvg = total > 0 ? (studentPercentage / total) * 100 : 0;
  double workerAvg = total > 0 ? (workerPercentage / total) * 100 : 0;


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
                    flex: 1, child: buildLineChart(monthFeesAmt)),
                const SizedBox(width: 20),
                Expanded(
                    flex: 1,
                    child: buildPieChart(teacherAvg, studentAvg, workerAvg,
                        lastAmtVal,
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
              color: color.withAlpha(80),
              borderRadius: BorderRadius.circular(15)),
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
                          color: Colors.black),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  value ?? "0", // Ensure it is always a String
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )
              ],
            ),
          ),
        ));
  }
}
