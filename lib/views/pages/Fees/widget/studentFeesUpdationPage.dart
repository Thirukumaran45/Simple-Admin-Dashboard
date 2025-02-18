import 'package:admin_pannel/controller/FessController.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:admin_pannel/views/widget/CustomNavigation.dart';
import 'package:get/get.dart';

class StudentFeesUpdationpage extends StatefulWidget {
  const StudentFeesUpdationpage({
    super.key,
    required this.stuName,
    required this.stuClass,
    required this.stuSec,
  });

  final String stuName;
  final String stuClass;
  final String stuSec;

  @override
  State<StudentFeesUpdationpage> createState() => _StudentFeesUpdationPageState();
}

class _StudentFeesUpdationPageState extends State<StudentFeesUpdationpage> {
  List<TextEditingController> feeNameControllers = [];
  List<TextEditingController> feeAmountControllers = [];
  bool isSaveButtonVisible = false;
  final FeesController controller = Get.find();
  List<Map<String, String>> filteredData = [];


  @override
  void initState() {
    super.initState();
    
    filteredData = List.from(controller.feesData);
    List<String> defaultFeeNames = [
      "Tution Fee",
      "Exam Fee",
      "Exam Fee",
      "Other Fee 1",
      "Other Fee 2",
      "Other Fee 3"
    ];

    for (int i = 0; i < 6; i++) {
      feeNameControllers.add(TextEditingController(text: defaultFeeNames[i]));
      feeAmountControllers.add(TextEditingController(text: "${i + 1}"));
    }
  }

  void checkForChanges() {
    setState(() {
      isSaveButtonVisible = true;
    });
  }

  void saveFees() {
    // Implement saving logic here
    setState(() {
      isSaveButtonVisible = false;
    });
  }

  @override
  void dispose() {
    for (var controller in feeNameControllers) {
      controller.dispose();
    }
    for (var controller in feeAmountControllers) {
      controller.dispose();
    }
    super.dispose();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Left Side
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      customIconNavigation(context,
                          '/fees-updation/sectionWiseFeesUpdation/studentFeesList?classNumber=${widget.stuClass}&sectionName=${widget.stuSec}'),
                      Row(
                        children: [
                          Text(
                            widget.stuName,
                            style: const TextStyle(
                              letterSpacing: 1,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              height: 20,
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "${widget.stuClass} - ${widget.stuSec}",
                            style: const TextStyle(
                              letterSpacing: 1,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: saveFees,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSaveButtonVisible ? Colors.red : Colors.grey,
                          foregroundColor: Colors.white,
                          elevation: 10,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.file_upload, color: Colors.white, size: 20),
                            Text("Save", style: TextStyle(color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        
                      ),
                   
                    ],
                  ),
                  const SizedBox(height: 20),
                  for (int i = 0; i < 6; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        children: [
                          // Fees Name TextField (Removed Label)
                          Expanded(
                            child: TextField(
                              controller: feeNameControllers[i],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryGreenColors),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryGreenColors),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryGreenColors),
                                ),
                              ),
                              onChanged: (value) => checkForChanges(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Fees Amount TextField
                          Expanded(
                            child: TextField(
                              controller: feeAmountControllers[i],
                              decoration: InputDecoration(
                                labelText: 'Fees Amount',
                                labelStyle: const TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryGreenColors),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryGreenColors),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryGreenColors),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => checkForChanges(),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // Right Side (Empty)
            // Expanded(flex: 1, child: Container(
            //   height: MediaQuery.of(context).size.height,
            //   width: 5,
            //   color: Colors.black,
            // )),
             Expanded( 
              flex: 1,
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
      ),
    );
  }
}
