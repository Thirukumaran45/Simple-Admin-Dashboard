import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart' show  SetOptions;
import 'package:get/get.dart';
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:flutter/material.dart' show TextEditingController;
import 'package:intl/intl.dart' show DateFormat;

class FeesController extends GetxController {
  
 FirebaseCollectionVariable collectionVariable = Get.find<FirebaseCollectionVariable>();
final RxList<Map<String, dynamic>> feesData = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> studentData = <Map<String, dynamic>>[].obs;

@override
  void onInit() {
    super.onInit();
    fetchTransactionHistry();
  }

    Future<void> fetchStudentData({required String stuClass,required String stuSec}) async {
    try {
 final  snapshot = await collectionVariable.studentLoginCollection.
 where('class', isEqualTo: stuClass).where('section',isEqualTo: stuSec).
 get();
  studentData.value = snapshot.docs.map((doc) {
  final data = doc.data() as Map<String, dynamic>;

  int allocated = int.tryParse("${data['allocatedAmount'] ?? '0'}") ?? 0;
  int pending = int.tryParse("${data[totalFees] ?? '0'}") ?? 0;
  int paid = allocated - pending;

  return {
    'roll': '${data[rollNofield] ?? ''}',
    'name': '${data[studentNamefield] ?? ''}',
    'pendingFees': '${data[totalFees] ?? '0'}',
    'totalFees': '${data['allocatedAmount']?? '0'}',
    'paidFees': paid.toString(),
    'status': '${data[feesStatusField] ?? 'Unpaid'}',
    'id':'${data[studentIdField] ?? ''}'
  };
}).toList().cast<Map<String, dynamic>>();

}   catch (e) {
  log('error in fetching the data $e');
        update(); 
}
  }

    String gettoadayDate() {
    final currentDate = DateTime.now();
    return DateFormat('dd-MM-yyyy').format(currentDate);
  }

  String gettodaymonth() {
    final currentMonth = DateTime.now();
    return DateFormat('MMMM yyyy').format(currentMonth);
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
  update();
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


Future<void> fetchTransactionHistry() async {
  List<Map<String, dynamic>> tempList = [];

  for (int i = 1; i < 13; i++) {
    for (String sec in ['A', 'B', 'C', 'D']) {
      final snapshot = await collectionVariable.feesDocCollection.collection('$i$sec').get();
     
      final currentList = snapshot.docs.map((doc) {
        final data = doc.data();
        String paymentDate = data['paymentDate'];
        String onlyDate = paymentDate.split(' ')[0];
        
        return {

          'studentName': '${data['studentName'] ?? ''}',
          'class': '${data['class'] ?? ''}',
          'section': '${data['section'] ?? ''}',
          'paidAmount': '${data['paidAmount'] ?? ''}',
          'balanceAmount': '${data['balanceAmount'] ?? ''}',
          'totalAmount': '${data['totalAmount'] ?? ''}',
          'paymentDate': onlyDate,
          'paymentMonth': '${data['paymentMonth'] ?? ''}',
          'transactionId': '${data['transactionId'] ?? ''}',
          'studentId': '${data['studentId'] ?? ''}',         
           'fee_amount': data['fee_amount'] ?? [],
           'feeAmount': data['feeAmount'] ?? [],


        };
      }).toList();
      tempList.addAll(currentList);
    }
  }

final dateFormat = DateFormat('dd-MM-yyyy');
tempList.sort((a, b) =>
  dateFormat.parse(b['paymentDate']!).compareTo(dateFormat.parse(a['paymentDate']!)));
  feesData.value = tempList;
  update();
}

 
Future<List<String>> fetchUniqueMonthValuesAll() async {
  // Use a Set to avoid duplicates.

  Set<String> monthValues = {};
  List<String> sections = ['A', 'B', 'C', 'D'];

  for (int i = 1; i <= 12; i++) {
    for (String sec in sections) {
      try {
        var snapshot = await collectionVariable.feesDocCollection.collection("${i.toString()}$sec")
            .get();

        for (var doc in snapshot.docs) {
          final data = doc.data() ;
          if (data.containsKey('paymentMonth') && data['paymentMonth'] != null) {
            monthValues.add(data['paymentMonth']);
          }
        }
      } catch (e) {
        log('Error in fetching month values for class $i section $sec: $e');
      }
    }
  }
  update();
  return monthValues.toList();
}
  
Future<List<String>> fetchUniqueDateValuesAll() async {
  Set<String> dateValues = {};
  List<String> sections = ['A', 'B', 'C', 'D'];

  for (int i = 1; i <= 12; i++) {
    for (String sec in sections) {
      try {
        var snapshot = await collectionVariable.feesDocCollection.collection("${i.toString()}$sec")
            .get();

        for (var doc in snapshot.docs) {
          final data = doc.data() ;
          if (data.containsKey('paymentDate') && data['paymentDate'] != null) {
          
            String paymentDate = data['paymentDate'];
            String onlyDate = paymentDate.split(' ')[0];
            dateValues.add(onlyDate);
          }
        }
      } catch (e) {
        log('Error in fetching date values for class $i section $sec: $e');
      }
    }
  }  update();
  log(dateValues.toString() );
  return dateValues.toList();
}

Future<Map<String, String>> getFeesSummary({
  required String sectedClass,
  required String section,
}) async {
  final studentSnapshot = await collectionVariable.studentLoginCollection
      .where('class', isEqualTo: sectedClass.trim().toUpperCase())
      .where('section', isEqualTo: section.trim().toUpperCase())
      .get();

  int paidCount = 0;
  int unpaidCount = 0;

  for (var doc in studentSnapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    final feeStatus = data['Fess Status']?.toString().trim().toLowerCase();
    if (feeStatus == 'pending') {
      unpaidCount++;
    } else if (feeStatus == 'paid') {
      paidCount++;
    }
  }
  return {
    'paid': paidCount.toString(),
    'unpaid': unpaidCount.toString(),
  };
}

Future<void> addAndUpdateStudentFeesDetails({
  required String id,
  required String allocateddAmount,
  required List<TextEditingController> feeNameControllers,
  required List<TextEditingController> feeAmountControllers,
}) async {
  Map<String, dynamic> feeMap = {
    'allocatedAmount': allocateddAmount,
  };

  for (int i = 0; i < feeNameControllers.length; i++) {
    feeMap['fee${i + 1}'] = feeNameControllers[i].text;
    feeMap['fee${i + 1}_amount'] = feeAmountControllers[i].text;
  }

  await collectionVariable.studentLoginCollection
      .doc(id)
      .set(feeMap, SetOptions(merge: true));
}

Future<Map<String, dynamic>> getStudentFeesDetails({
  required String id,
}) async {
  final snapshot = await collectionVariable.studentLoginCollection.doc(id).get();
  final doc = snapshot.data() as Map<String, dynamic>;

  List<TextEditingController> feeNameControllers = [];
  List<TextEditingController> feeAmountControllers = [];

  String allocatedAmount = doc['allocatedAmount']?.toString() ?? '0';

  int i = 1;
  while (true) {
    final feeKey = 'fee$i';
    final feeAmountKey = 'fee${i}_amount';

    if (doc.containsKey(feeKey) && doc.containsKey(feeAmountKey)) {
      feeNameControllers.add(TextEditingController(text: doc[feeKey].toString()));
      feeAmountControllers.add(TextEditingController(text: doc[feeAmountKey].toString()));
      i++;
    } else {
      break;
    }
  }

  return {
    'allocatedAmount': allocatedAmount,
    'feeNameControllers': feeNameControllers,
    'feeAmountControllers': feeAmountControllers,
  };
}


}
 