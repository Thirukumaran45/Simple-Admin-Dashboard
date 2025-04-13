import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart' show SetOptions;
import 'package:get/get.dart';
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:flutter/material.dart' show TextEditingController;

class FeesController extends GetxController {
  
late FirebaseCollectionVariable collectionVariable;

@override
  void onInit() {
    super.onInit();
    collectionVariable = Get.find();
  }
Future<List<Map<String, String>>> fetchAllBankDetails() async {
  try {
    final snapshot = await collectionVariable.schoolDetails.collection('feeDetails').doc('bankDetails').get();
    final data = snapshot.data() ?? {};

    // Map of document keys to user-friendly classRange names
    final Map<String, String> classRangeMap = {
      'class_1_3': 'Class 1 to 3',
      'class_4_6': 'Class 4 to 6',
      'class_7_8': 'Class 7 to 8',
      'class_9_10': 'Class 9 to 10',
      'class_11_12': 'Class 11 to 12',
    };

    List<Map<String, String>> result = [];

    for (var key in classRangeMap.keys) {
      final entry = data[key] ?? {};
      result.add({
        'bankName': entry['bankName'] ?? '',
        'apiKey': entry['apiKey'] ?? '',
        'classRange': classRangeMap[key]??'',
      });
    }

    return result;
  } catch (e) {
    log('Error fetching all bank details: $e');
    return [];
  }
}


Future<void> addAndUpdateBankDetailsToFirestore(
  {
  required  List<TextEditingController> bankControllers,
  required  List<TextEditingController> apiControllers,}
) async {
  try {
      
     List<String> classRange = ['class_1_3','class_4_6','class_7_8','class_9_10','class_11_12'];
            
       for(int i = 0;i<5;i++)
       {
       await collectionVariable.schoolDetails.collection('feeDetails').doc('bankDetails').set({
        classRange[i]:{
        'bankName': bankControllers[i].text,
        'apiKey': apiControllers[i].text,
        },
      } , SetOptions(merge: true) );
     }
     
    update(); 
  } catch (e) {
    log("Error updating bank details: $e");
  }
}


  List<Map<String, String>> feesData = [
    {
      'studentName': 'John Doe',
      'class': '10',
      'section': 'A',
      'paidAmount': '5000',
      'balanceAmount': '2000',
      'totalAmount': '7000',
      'paymentDate': '18-02-2025',
      'paymentMonth': 'February',
      'transactionId': 'TXN12345',
      'studentId': 'STD001',
    },
    {
      'studentName': 'Thiru kumaran',
      'class': '10',
      'section': 'A',
      'paidAmount': '5000',
      'balanceAmount': '2000',
      'totalAmount': '7000',
      'paymentDate': '18-02-2025',
      'paymentMonth': 'February',
      'transactionId': 'TXN12345',
      'studentId': 'STD001',
    },
     {
      'studentName': 'Thiru kumaran',
      'class': '10',
      'section': 'A',
      'paidAmount': '5000',
      'balanceAmount': '2000',
      'totalAmount': '7000',
      'paymentDate': '18-02-2025',
      'paymentMonth': 'February',
      'transactionId': 'TXN12345',
      'studentId': 'STD001',
    },
    {
      'studentName': 'Raj',
      'class': '10',
      'section': 'A',
      'paidAmount': '5000',
      'balanceAmount': '2000',
      'totalAmount': '7000',
      'paymentDate': '18-02-2025',
      'paymentMonth': 'February',
      'transactionId': 'TXN12345',
      'studentId': 'STD001',
    },
    {
      'studentName': 'John Doe',
      'class': '10',
      'section': 'A',
      'paidAmount': '5000',
      'balanceAmount': '2000',
      'totalAmount': '7000',
      'paymentDate': '18-02-2025',
      'paymentMonth': 'December',
      'transactionId': 'TXN12345',
      'studentId': 'STD001',
    },
  ];

  
  
}
 