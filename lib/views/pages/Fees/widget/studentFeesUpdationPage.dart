

import 'package:admin_pannel/controller/classControllers/pageControllers/FessController.dart';
import 'package:admin_pannel/contant/pdfApi/PdfFees/PdfSingleScript.dart';
import 'package:admin_pannel/views/widget/CustomDialogBox.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:get/get.dart';

class StudentFeesUpdationpage extends StatefulWidget {
  const StudentFeesUpdationpage({
    super.key,
    required this.stuName,
    required this.stuClass,
    required this.stuSec, required this.id,
  });
 final String id;
  final String stuName;
  final String stuClass;
  final String stuSec;

  @override
  State<StudentFeesUpdationpage> createState() => _StudentFeesUpdationPageState();
}

class _StudentFeesUpdationPageState extends State<StudentFeesUpdationpage> {
  List<TextEditingController> feeNameControllers = [];
  List<TextEditingController> feeAmountControllers = [];
  late TextEditingController allocatedFeeController;
  bool isSaveButtonVisible = false;
  final FeesController controller = Get.find();
  List<Map<String, String>> filteredData = [];
late Future<List<Map<String, dynamic>>> matchedFeesFuture;


@override
void initState() {
  super.initState();

  List<String> defaultFeeNames = [
    "Tution Fee",
    "Exam Fee",
    "Other Fee 1",
    "Other Fee 2",
    "Other Fee 3",
    "Other Fee 4",
    "Other Fee 5",
    "Other Fee 6"
  ];
  allocatedFeeController = TextEditingController();

  for (int i = 0; i < 8; i++) {
    feeNameControllers.add(TextEditingController(text: defaultFeeNames[i]));
    feeAmountControllers.add(TextEditingController(text: "${i*0}"));
  }

  // Fetch existing data
  fetchStudentFees();
  matchedFeesFuture = getMatchedFees();
}

void fetchStudentFees() async {
  final data = await controller.getStudentFeesDetails(id: widget.id);

  allocatedFeeController.text = data['allocatedAmount'];

  List<TextEditingController> nameCtrls = data['feeNameControllers'];
  List<TextEditingController> amountCtrls = data['feeAmountControllers'];

  for (int i = 0; i < nameCtrls.length && i < 8; i++) {
    feeNameControllers[i].text = nameCtrls[i].text;
    feeAmountControllers[i].text = amountCtrls[i].text;
  }
}


 Future<List<Map<String, dynamic>>> getMatchedFees() async {
  await Future.delayed(const Duration(seconds: 15));
  final filteredData = List<Map<String, dynamic>>.from(controller.feesData);
  return filteredData.where((fees) => fees['studentId'] == widget.id).toList();
}

  void checkForChanges() {
    setState(() {
      isSaveButtonVisible = true;
    });
  }

void saveFees() async {
  await controller.addAndUpdateStudentFeesDetails(
    id: widget.id,
    allocateddAmount: allocatedFeeController.text,
    feeNameControllers: feeNameControllers,
    feeAmountControllers: feeAmountControllers,
  );
  await controller.fetchStudentData(stuClass: widget.stuClass, stuSec: widget.stuSec);

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
    allocatedFeeController.dispose();
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
              child: SingleChildScrollView(
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
                        const SizedBox(width: 20,),
                         Expanded(
                              child: TextField(
                                 style:const  TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16
                                        ),
                                controller: allocatedFeeController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.currency_rupee),
                                  hintText: "Enter total allocated Fees",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryGreenColors),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: allocatedFeeController.text.isEmpty?Colors.red: primaryGreenColors),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryGreenColors),
                                  ),
                                ),
                                onChanged: (value) => checkForChanges(),
                              ),
                            ),
                        const SizedBox(width: 20,),
                        
                        ElevatedButton(
                          onPressed: ()
                        async  {
                          
                         isSaveButtonVisible? await showCustomDialog(context, "Student Fees details Updated Succecfully"):null;
                            saveFees();
                          },
                         style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    isSaveButtonVisible?Colors.blue:Colors.grey, // Button background color
                                elevation: 10, // Elevation for shadow effect
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12), // Button padding
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20), // Rounded corners
                                ),
                              ),
                          child: const Padding(
                      padding:  EdgeInsets.symmetric(vertical:  8.0),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.upload_sharp , color: Colors.white,size: 20,),
                           SizedBox(width: 5,),
                           Text("Save", style: TextStyle(color: Colors.white, fontSize: 17,)),
                        ],
                      ),
                    ),
                          
                        ),
                       
                     
                      ],
                    ),
                    const SizedBox(height: 60),
                    for (int i = 0; i < 8; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            // Fees Name TextField (Removed Label)
                            Expanded(
                              child: TextField(  
                                style:const  TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16
                                        ),
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
                                style:const  TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16
                                        ),
                                controller: feeAmountControllers[i],
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.currency_rupee),
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
            ),
         
             Expanded( 
              flex: 1,
            child: FutureBuilder<List<Map<String, dynamic>>>(
        future: matchedFeesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
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
          );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          } else {
            final matchedFees = snapshot.data ?? [];

            if (matchedFees.isEmpty) {
              return Center(
                child: Text(
                  'No Transaction History Found!',
                  style: TextStyle(fontSize: 18, color: Colors.grey[850]),
                ),
              );
            }

               return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: matchedFees.length,
                    itemBuilder: (context, index) {
                    final fees = matchedFees[index];
              
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
                              // Added rows for feeamount and fee_amount lists
                                 if (fees['fee_amount'] != null &&
    fees['feeAmount'] != null &&
    fees['fee_amount'] is List &&
    fees['feeAmount'] is List)
  ...List.generate((fees['fee_amount'] as List).length, (index) {
    final fee1 = (fees['fee_amount'] as List)[index];
    final fee2 = index < (fees['feeAmount'] as List).length
        ? (fees['feeAmount'] as List)[index]
        : '';
    return _buildFeesRow("Subject of payment Amount ","$fee1 - ₹$fee2", primaryGreenColors);
  })
else
  _buildFeesRow("Subject of payment to ", "N/A", primaryGreenColors),
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

             PdfSinglescript.openPdf(studentName: fees['studentName']??'N/A', studentClass: "${fees['class']} ", section: '${fees['section']}', studentId: fees['studentId'] ?? "N/A", paidAmount: "₹${fees['paidAmount']}", balanceAmount: "₹${fees['balanceAmount']}", totalAllocatedAmount: "₹${fees['totalAmount']}", paymentDate: fees['paymentDate'] ?? "N/A", paymentMonth: fees['paymentMonth'] ?? "N/A", transactionId:  fees['transactionId'] ?? "N/A", fees: fees,);

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
                  );
          }
        }
        )
          ),
          ],
        ),
      ),
    );
  }
}
