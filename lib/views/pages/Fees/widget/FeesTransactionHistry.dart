
import 'package:admin_pannel/controller/FessController.dart';
import 'package:admin_pannel/views/widget/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Feestransactionhistry extends StatefulWidget {
  
  const Feestransactionhistry({super.key});

  @override
  State<Feestransactionhistry> createState() => _FeesDetailsPageState();
}

class _FeesDetailsPageState extends State<Feestransactionhistry> {
  TextEditingController searchNameController = TextEditingController();

  String? selectedDate = "All";
  String? selectedMonth = "All";
  String name = '';
  final FeesController controller = Get.find();
  List<Map<String, String>> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = List.from(controller.feesData);
    applyFilters();
  }

  void applyFilters() {
    String nameQuery = searchNameController.text.toLowerCase();

    setState(() {
      filteredData = controller.feesData.where((fees) {
        final matchesDate = selectedDate == "All" || fees['paymentDate'] == selectedDate;
        final matchesMonth = selectedMonth == "All" || fees['paymentMonth'] == selectedMonth;
        final matchesName = name.isEmpty || fees['studentName']!.toLowerCase().contains(nameQuery);
        return matchesDate && matchesMonth && matchesName;
      }).toList();
    });
  }

  List<String> getAllDatesInMonth(String month) {
    DateTime now = DateTime.now();
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    List<String> dates = ["All"];
    for (int i = 1; i <= daysInMonth; i++) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, i));
      dates.add(formattedDate);
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: customIconNavigation(context, '/fees-updation'),
              ),
              const Text("Filter by Options :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _buildDropdown('Select Date', selectedDate, getAllDatesInMonth(selectedMonth!), (value) {
                setState(() => selectedDate = value);
                applyFilters();
              }),
              _buildDropdown('Select Month', selectedMonth, ["All", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"], (value) {
                setState(() => selectedMonth = value);
                applyFilters();
              }),
              SizedBox(
                width: 150,
                child: TextField(
                  controller: searchNameController,
                  decoration: InputDecoration(
                    labelText: 'Search by name',
                    labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
                    border: OutlineInputBorder(borderSide: BorderSide(color: primaryGreenColors)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryGreenColors)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryGreenColors)),
                  ),
                  onChanged: (value) {
                    setState(() => name = value);
                    applyFilters();
                  },
                ),
              ),
              customIconTextButton(Colors.blue, icon: Icons.search, onPressed: applyFilters, text: "Search"),
              customIconTextButton(primaryGreenColors, icon: Icons.download_sharp, onPressed: applyFilters, text: "Download"),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: filteredData.isEmpty
                ? Center(
                    child: Text(
                      'No Transaction History as Found yet !',
                      style: TextStyle(fontSize: 18, color: Colors.grey[850]),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final fees = filteredData[index];
                      return Card(
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFeesRow("Student Name:", fees['studentName'] ?? "N/A", Colors.black),
                              _buildFeesRow("Class & Section:", "${fees['class']} - ${fees['section']}", Colors.black),
                              _buildFeesRow("Paid Amount:", "₹${fees['paidAmount']}", primaryGreenColors),
                              _buildFeesRow("Student ID:", fees['studentId'] ?? "N/A", Colors.black),
                              _buildFeesRow("Balance Amount:", "₹${fees['balanceAmount']}", Colors.red),
                              _buildFeesRow("Total Allocated Amount:", "₹${fees['totalAmount']}", Colors.blue),
                              _buildFeesRow("Payment Date:", fees['paymentDate'] ?? "N/A", Colors.black),
                              _buildFeesRow("Payment Month:", fees['paymentMonth'] ?? "N/A", Colors.black),
                              _buildFeesRow("Transaction ID:", fees['transactionId'] ?? "N/A", Colors.black),
                         Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
       const   Text("Download Fees Recipt", style:  TextStyle(fontSize: 15, color: Colors.black)),
          TextButton(onPressed: (){}, child: Row(
            children: [Icon(Icons.download, color: primaryGreenColors,size: 25,), Text(" Download", style:  TextStyle(fontSize: 16, color:primaryGreenColors, fontWeight: FontWeight.bold) ,)],
          ))
         ],
      ),
    ),
                          ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, String? value, List<String?> items, ValueChanged<String?> onChanged) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(color: primaryGreenColors, width: 1),
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<String>(
        borderRadius: BorderRadius.circular(20),
        dropdownColor: Colors.white,
        hint: Text(hint, style: const TextStyle(color: Colors.black)),
        value: value,
        items: items.where((e) => e != null).map((date) {
                    return DropdownMenuItem(value: date, child: Text(date!));
                  }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildFeesRow(String title, String value , Color color1) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style:  const TextStyle(fontSize: 15, color: Colors.black)),
          Text(value, style: TextStyle(fontSize: 15, color: color1,fontWeight: FontWeight.bold,)),
        ],
      ),
    );
  }
}
