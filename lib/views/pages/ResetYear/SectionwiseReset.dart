import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomDialogBox.dart';
import 'package:flutter/material.dart';

class SectionWiseResetData extends StatelessWidget {
  final List<String> historyItems = [
    "Rest Attendance History",
    "School Chat History",
    "Remainder Chat History",
    "Exam Publish History",
    "Assignment History",
    "Class Time Table Reset"
  ];

   SectionWiseResetData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      backgroundColor: Colors.white,
        
    leading: customIconNavigation(context, "/schoolYear-data-updation"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: 4, // Sections A to B
          itemBuilder: (context, index) {
            String sectionTitle = "Section ${String.fromCharCode(65 + index)}";
            return  Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow:  const [
                      BoxShadow(                     
                         color: Colors.grey,

                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sectionTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(),
                      Column(
                        children: historyItems.map((item) {
                          return ListTile(
                            leading: const Icon(Icons.history, color: Colors.blue),
                            title: Text(item),
                            trailing: ElevatedButton(
                              
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                backgroundColor: Colors.red
                                ,foregroundColor: Colors.white
                              ),
                              onPressed: () {
                            showCustomDialog(context, "Data as been Reseted");

                              },
                              child: const Text('Reset Histry'),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
