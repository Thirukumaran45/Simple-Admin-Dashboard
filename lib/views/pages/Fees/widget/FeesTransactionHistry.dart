
import 'package:admin_pannel/controller/classControllers/pageControllers/FessController.dart';
import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/contant/pdfApi/PdfFees/PdfSingleScript.dart';
import 'package:admin_pannel/contant/pdfApi/PdfFees/PdfTotalFeesScript.dart';
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

  String? selectedDate ;
  String? selectedMonth;
  String name = '';
  final FeesController controller = Get.find();
  List<Map<String, dynamic>> filteredData = [];
  List<String> month = [];
  List<String>date=[];bool isLoading = true;

 @override
void initState() {
  super.initState();
  initializeList(); // applyFilters is called after fetching
}

  void applyFilters() {
    String nameQuery = searchNameController.text.toLowerCase();

    setState(() {
      filteredData = controller.feesData.where((fees) {
        final matchesDate = selectedDate == null || fees['paymentDate'] == selectedDate;
        final matchesMonth = selectedMonth == null || fees['paymentMonth'] == selectedMonth;
        final matchesName = name.isEmpty || fees['studentName']!.toLowerCase().contains(nameQuery);
        return matchesDate && matchesMonth && matchesName;
      }).toList();
    });
  }

void initializeList() async {
  List<String> monthVal = await controller.fetchUniqueMonthValuesAll();
  List<String> dateVal = await controller.fetchUniqueDateValuesAll();

  setState(() {
    month = monthVal.toSet().toList();
    date = dateVal.toSet().toList();

    if (month.contains(controller.gettodaymonth())) {
      selectedMonth = controller.gettodaymonth();
    }
    if (date.contains(controller.gettoadayDate())) {
      selectedDate = controller.gettoadayDate();
    }

    filteredData = List.from(controller.feesData);
    isLoading = false; 
    applyFilters();
  });
}

  List<String> getAllDatesInMonth(String month) {
    DateTime now = DateTime.now();
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    List<String> dates = ["All"];
    for (int i = 1; i <= daysInMonth; i++) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime(now.year, now.month, i));
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
              _buildDropdown('Select Date', selectedDate, date, (value) {
                setState(() => selectedDate = value);
                applyFilters();
              }),
              _buildDropdown('Select Month', selectedMonth, month, (value) {
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
              customIconTextButton(primaryGreenColors, icon: Icons.download_sharp, onPressed:(){
               PdfTotalFeesScript.openPdf(fileName: 'Transaction Histry $selectedDate',transactions: filteredData);
               applyFilters();
              } , text: "Download"),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: isLoading
    ? const Center(child: CircularProgressIndicator(color: Colors.green,))
    : filteredData.isEmpty
        ? const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
                  child: Text("Please wait a moment...", style: TextStyle(fontSize: 18),),
                ),
                CircularProgressIndicator( color: Colors.green,),
              ],
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
          TextButton(onPressed: (){

           PdfSinglescript.openPdf(studentName: fees['studentName']??'N/A', studentClass: "${fees['class']} ", section: '${fees['section']}', studentId: fees['studentId'] ?? "N/A", paidAmount: "₹${fees['paidAmount']}", balanceAmount: "₹${fees['balanceAmount']}", totalAllocatedAmount: "₹${fees['totalAmount']}", paymentDate: fees['paymentDate'] ?? "N/A", paymentMonth: fees['paymentMonth'] ?? "N/A", transactionId:  fees['transactionId'] ?? "N/A",);

          }, child: Row(
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

  
Widget _buildDropdown(String hint, String? value, List<String> items, ValueChanged<String?> onChanged) {
  return Container(
    width: 150,
    decoration: BoxDecoration(
      border: Border.all(color: primaryGreenColors, width: 1),
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.white,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: DropdownButton<String>(
      isExpanded: true,
      borderRadius: BorderRadius.circular(20),
      dropdownColor: Colors.white,
      hint: Text(hint, style: const TextStyle(color: Colors.black)),
      value: items.contains(value) ? value : null, // Prevent invalid selections
      onChanged: onChanged,
      items: items.toSet().toList().map((String item) {  // Remove duplicates
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
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
