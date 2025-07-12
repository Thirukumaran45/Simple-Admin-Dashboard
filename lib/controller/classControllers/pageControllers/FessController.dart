
import 'package:admin_pannel/utils/AppException.dart';


import '../../../contant/ConstantVariable.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, Query, SetOptions;
import 'package:get/get.dart' ;
import '../../../services/FireBaseServices/CollectionVariable.dart';
import 'package:flutter/material.dart' show TextEditingController;
import 'package:intl/intl.dart' show DateFormat;

class FeesController extends GetxController {
  
 FirebaseCollectionVariable collectionVariable = Get.find<FirebaseCollectionVariable>();
final RxList<Map<String, dynamic>> feesData = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> studentData = <Map<String, dynamic>>[].obs;
final int _limit = 15;
DocumentSnapshot? _studentlastDocument;
DocumentSnapshot? _histrylastDocument;
bool _isFetchingMoreStudent = false;
bool _isFetchingMoreHisrty = false;
var _context ;
@override
  void onInit() {
    super.onInit();
    fetchTransactionHistry(_context);
  }

    Future<void> fetchStudentData(dynamic context,{required String stuClass,required String stuSec}) async {
    
      if (_isFetchingMoreStudent) return;

      _isFetchingMoreStudent = true;
    try {
       Query query =collectionVariable.studentLoginCollection.limit(_limit);
    if (_studentlastDocument != null) {
      query = query.startAfterDocument(_studentlastDocument!);
    }
 final  snapshot = await query.
 where('class', isEqualTo: stuClass).where('section',isEqualTo: stuSec).
 get();

 if(snapshot.docs.isNotEmpty)
 {
  _studentlastDocument = snapshot.docs.last;
    final newEntries = snapshot.docs.map((doc) {
  final data = doc.data() as Map<String, dynamic>;

  int allocated = int.tryParse("${data['allocatedAmount'] ?? '0'}") ?? 0;
  int pending = int.tryParse("${data[totalFees] ?? '0'}") ?? 0;
  int paid = allocated - pending;

  return {
    'roll': '${data[rollNofield] ?? ''}',
    'name': '${data[studentNamefield] ?? ''}',
    'pendingFees': '${data[totalFees] ?? '0'}',
    'totalFees': '${data['allocatedAmount'] ?? '0'}',
    'paidFees': paid.toString(),
    'status': '${data[feesStatusField] ?? 'Unpaid'}',
    'id': '${data[studentIdField] ?? ''}',
  };
}).toList()
.cast<Map<String, dynamic>>();

      studentData.addAll(newEntries);
      update();
    }

}   catch (e) {
  throw CloudDataReadException("Error in getting student details, please try again later !");
}finally {
    _isFetchingMoreStudent = false;
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
  
Future<List<Map<String, String>>> fetchAllBankDetails(dynamic context,) async {
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
    throw CloudDataReadException("Error in fetching bank details, please try again later !");
    
  }
  
}


Future<void> addAndUpdateBankDetailsToFirestore(dynamic context,
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
       if(!context.mounted)return;
    update(); 
  } catch (e) {
    throw CloudDataWriteException("Error in updating the bank details, please try again later !");
  }
}


Future<void> fetchTransactionHistry(dynamic context,) async {
  List<Map<String, dynamic>> tempList = [];
 if (_isFetchingMoreHisrty) return;

  _isFetchingMoreHisrty = true;
      try {
        Query query =  collectionVariable.feesDocCollection.collection('completedTransaction').limit(_limit);
    if (_histrylastDocument != null) {
      query = query.startAfterDocument(_histrylastDocument!);
    }
  final snapshot = await query.get();
       
  final currentList = snapshot.docs.map((doc) {
    final data = doc.data() as Map<String,dynamic>;
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
    
  final dateFormat = DateFormat('dd-MM-yyyy');
  tempList.sort((a, b) =>
    dateFormat.parse(b['paymentDate']!).compareTo(dateFormat.parse(a['paymentDate']!)));
    feesData.value = tempList;
}  catch (e) {
  throw CloudDataReadException("Error in fetching transaction histry, please try again later !");
}finally {
    _isFetchingMoreHisrty = false;
  }
  update();
}

 
Future<List<String>> fetchUniqueMonthValuesAll(dynamic context,) async {
  // Use a Set to avoid duplicates.


      try {
           var snapshot = await collectionVariable.feesDocCollection
            .get();


    if (snapshot.exists) {
      // Explicitly cast data to a Map<String, dynamic>
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('payment_months')) {
        List<dynamic> rawList = data['payment_months'];
       update();
        return List<String>.from(rawList);
      }
    }
      } catch (e) {
        throw CloudDataReadException("Error in getting payment fees month details, please try again later !");
      }
    
  update();
  return [];
}
  
Future<List<String>> fetchUniqueDateValuesAll(dynamic context,) async {
  
      try {
        var snapshot = await collectionVariable.feesDocCollection
            .get();


    if (snapshot.exists) {
      // Explicitly cast data to a Map<String, dynamic>
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('payment_dates')) {
        List<dynamic> rawList = data['payment_dates'];
       update();
        return List<String>.from(rawList);
      }
    }
      } catch (e) {
        throw CloudDataReadException("Error in getting payment fee date details, please try again later !");
        
  }
  return [];

}

Future<Map<String, String>> getFeesSummary(dynamic context,{
  required String sectedClass,
  required String section,
}) async {
  try {
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
}  catch (e) {
        throw CloudDataReadException("Error in getting the fee summary details, please try again later !");
  }
}

Future<void> addAndUpdateStudentFeesDetails(dynamic context,{
  required String id,
  required String allocateddAmount,
  required List<TextEditingController> feeNameControllers,
  required List<TextEditingController> feeAmountControllers,
}) async {
  try {
  Map<String, dynamic> feeMap = {
    'allocatedAmount': allocateddAmount,
  };
  
  for (int i = 0; i < feeNameControllers.length; i++) {
    feeMap['fee${i + 1}'] = feeNameControllers[i].text;
    feeMap['fee${i + 1}_amount'] = feeAmountControllers[i].text;
    feeMap['isView']=true;
  }
  
  await collectionVariable.studentLoginCollection
      .doc(id)
      .set(feeMap, SetOptions(merge: true));
}  catch (e) {
        throw CloudDataWriteException("Error in updating the fees details, please try again later !");
  
}
}


Future<Map<String, dynamic>> getStudentFeesDetails(dynamic context,{
  required String id,
}) async {
  try {
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
} catch (e) {
        throw CloudDataReadException("Error in getting student fee details, please try again later !");
  
}
}


}
 