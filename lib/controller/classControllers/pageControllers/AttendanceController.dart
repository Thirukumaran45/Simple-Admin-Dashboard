import 'dart:developer' show log;
import 'package:admin_pannel/contant/constant.dart' show customSnackbar;
import 'package:admin_pannel/utils/AppException.dart' ;
import 'package:firebase_storage/firebase_storage.dart' show FirebaseException;

import '../../../services/FireBaseServices/CollectionVariable.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, Query;
import 'package:get/get.dart' show Get, GetxController, Inst ;
import 'package:intl/intl.dart' show DateFormat;

class AttendanceController extends GetxController {
  late FirebaseCollectionVariable collectionControler;
  late dynamic snapshot;

final int _pageSize = 15;
DocumentSnapshot? _lastStudentDoc;
bool _isFetchingMoreStudents = false;

  @override
  void onInit() {
    super.onInit();
    collectionControler = Get.find<FirebaseCollectionVariable>();
  }

  String gettoadayDate() {
    final currentDate = DateTime.now();
    return DateFormat('dd-MM-yyyy').format(currentDate);
  }

  String gettodaymonth() {
    final currentMonth = DateTime.now();
    return DateFormat('MMMM yyyy').format(currentMonth);
  }

Future<List<String>> getAttendanceDates() async {
  try {
    final overallDaysDoc = await collectionControler.attendanceCollection.get();

    if (overallDaysDoc.exists) {
      // Explicitly cast data to a Map<String, dynamic>
      Map<String, dynamic>? data = overallDaysDoc.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('attendance_dates')) {
        List<dynamic> rawList = data['attendance_dates'];
       update();
        // Convert dynamic list to List<String> safely
        return List<String>.from(rawList);
      }
    }
  }  catch (fe) {
    log("Error fetching attendance dates: $fe");
    throw CloudDataReadException(" Fetching error in attendance dates, please try again later !"); 
  }
 
  return [];
}


Future<List<String>> fetchUniqueMonthValuesAll(dynamic context) async {
  
 try {
    final overallDaysDoc = await collectionControler.attendanceCollection.get();

    if (overallDaysDoc.exists) {
      // Explicitly cast data to a Map<String, dynamic>
      Map<String, dynamic>? data = overallDaysDoc.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey('attendance_months')) {
        List<dynamic> rawList = data['attendance_months'];
       update();
        // Convert dynamic list to List<String> safely
        return List<String>.from(rawList);
      }
    }
  }  catch (fe) {
    log("Error fetching attendance months: $fe");
    throw CloudDataReadException(" Fetching error in attendance months, please try again later !"); 
  }
 
  return [];
}

Future<void> updateAttendance(dynamic context,{ required String id,required String stuClass,  required String date,required String sec, required String status}) async {
  try {
    
  final String section = sec.toUpperCase();
  final col = collectionControler.attendanceCollection
      .collection(date)
      .doc("$stuClass$section");

     final snapshot =await col .collection("presented_student").doc(id)
      .get();

    await snapshot.reference.update({'status': status});
  
    final studentDoc =   collectionControler.studentLoginCollection.doc(id);
    final studentData = await studentDoc.get();
    final data = studentData.data() as Map<String, dynamic>?;

      int totalAttendanceDays = int.tryParse(
        data?['totalAttendanceDays']?.toString() ?? '0') ?? 0;

 if (status == 'Present') {
      totalAttendanceDays += 1;
    
}
     final overallDaysDoc =  collectionControler.attendanceCollection;
     final snapdata = await  overallDaysDoc.get(); 
    final daysData = snapdata.data() as Map<String, dynamic>?;
    
    int totalDays = daysData?['total number of Days'] ?? 1;

    double attendancePercentage = (totalAttendanceDays / totalDays) * 100;
    int attendancePercentageInt = attendancePercentage.toInt();
  
  
    await studentDoc.update({
      'Today Attendance': status,
      'Attendance Percentage': attendancePercentageInt.toString(),
    });
// Step 1: Get current values
final collection = await col.get();
final collectiondata = collection.data() as Map<String, dynamic>;

int presentCount = collectiondata['number of Student present'] ?? 0;
int absentCount = collectiondata['number of Student absent'] ?? 0;

if(status =="Present")
{
  presentCount+=1;
  absentCount-=1;

}
else
{
  absentCount+=1;
  presentCount-=1;

}

  // Step 3: Update the values
  await col.update({
    'number of Student present': presentCount,
    'number of Student absent': absentCount,
  });

  
  if(!context.mounted)return;
   await   customSnackbar(context: context, text: "Attendance status as been changed !!!");


       update();

} on FirebaseException catch (e) {
  log('error in updating the attendance $e');
  throw CloudDataReadException("Updating the attendance is failed, please try again later !");
}

}

Future<String> getTeacherName(dynamic context,{required String stuClass, required String sec}) async {
  try {
    final String date = gettoadayDate();
    final docRef = collectionControler.attendanceCollection.collection(date).doc("$stuClass$sec");
    
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data() as Map<String, dynamic>;
      String teacherName = data['teacherName'] ?? '';
      
      return teacherName;
    } else {
      return ''; 
    } 
    
  } catch (e) {
    log("Error fetching teacher name: $e");
    throw CloudDataReadException("No teacher are found !");
  }
  
}

/// in AttendanceController.dart
Future<List<Map<String, dynamic>>> fetchPagedStudents(dynamic context,{
  required String stuClass,
  required String stuSec,
  required String dateFilter,     // ← new
  required String monthFilter,    // ← new
  bool reset = false,
}) async {
  if (_isFetchingMoreStudents) return [];

  if (reset) {
    _lastStudentDoc = null;
  }

  _isFetchingMoreStudents = true;
  
  try {
    Query query = collectionControler.attendanceCollection
      .collection(dateFilter)
      .doc("$stuClass$stuSec")
      .collection("presented_student");

    // ADD your filters here:
    if (dateFilter.isNotEmpty) {
      query = query.where('date', isEqualTo: dateFilter);
          log(dateFilter);
    }

    if (monthFilter.isNotEmpty) {
      query = query.where('month', isEqualTo: monthFilter);
          log(monthFilter);
    }

    query = query.limit(_pageSize);

    if (_lastStudentDoc != null) {
      query = query.startAfterDocument(_lastStudentDoc!);
    }

    final snapshot = await query.get();
    if (snapshot.docs.isEmpty) return [];

    _lastStudentDoc = snapshot.docs.last;
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String,dynamic>;
      return {
        'rollNumber': data['rollNo'] ?? '',
        'name'      : data['studentName'] ?? '',
        'id'        : data['studentId'] ?? '',
        'date'      : data['date'] ?? '',
        'month'     : data['month'] ?? '',
        'attendanceStatus': data['status'] ?? 'Absent',
        'percentage': data['percentage'] ?? ''
      };
    }).toList();
    
  } catch (e) {
    log('Error paginating students: $e');
    throw CloudDataDeleteException("Error in fetching the student details");
  } finally {
    _isFetchingMoreStudents = false;
  }
}

 


Future<Map<int, Map<String, String>>> totalNumberOfPresentAndAbsent(dynamic context,) async {

final String date = gettoadayDate();

  Map<int, Map<String, String>> classWiseAttendance = {};

  try {
  for (int i = 1; i < 13; i++) {
    int totalPresent = 0;
    int totalAbsent = 0;
    Map<String, String> sectionStatus = {}; // Stores status for sections A, B, C, D
  
    for (String sec in ['A', 'B', 'C', 'D']) {
      
      final docRef = collectionControler.attendanceCollection
          .collection(date)
          .doc("${i.toString()}$sec");
  
      final docSnapshot = await docRef.get();
  
      if (docSnapshot.exists) {
        final data = docSnapshot.data(); // Explicitly cast to a Map
        final int presentStr =  data?["number of Student present"] ?? 0;
        final int absentStr = data?["number of Student absent"] ?? 0;
        final String status = data?["class attendance status"] ?? 'Not Taken';
  
        totalPresent += presentStr;
        totalAbsent += absentStr;
        sectionStatus[sec] = status; // Store status for each section
      } else {
        sectionStatus[sec] = 'Not Taken'; // Default if document doesn't exist
      }
    }
   
    classWiseAttendance[i] = {
      "numberOfPresent": totalPresent.toString(),
      "numberOfAbsent": totalAbsent.toString(),
      "A": sectionStatus["A"] ?? "Not Taken",
      "B": sectionStatus["B"] ?? "Not Taken",
      "C": sectionStatus["C"] ?? "Not Taken",
      "D": sectionStatus["D"] ?? "Not Taken",
    };
  }
       update();
  return classWiseAttendance;
} catch (e) {
  log("error $e");
  throw CloudDataReadException('Could not get the total number of present and absent, please try again later !');
}
}

Future<Map<String, Map<String, String>>> getSectionWiseTotalPresentAndAbsent(dynamic context,{required String stuClass})async{
final String date = gettoadayDate();

  Map<String, Map<String, String>> sectionWiseAttendance = {};

   try {
  for (String sec in ['A','B','C','D']) {
     final docRef = collectionControler.attendanceCollection.collection(date)
         .doc("$stuClass$sec");
  
     final docSnapshot = await docRef.get();
  
     if (docSnapshot.exists) {
       final data = docSnapshot.data(); // Explicitly cast to a Map
      final int  presentStr = data?["number of Student present"] ?? 0;
       final int  absentStr = data?["number of Student absent"] ?? 0;
       final String  status = data?["class attendance status"] ?? 'Not Taken';
  
     sectionWiseAttendance[sec]={
     "numberOfPresent": presentStr.toString(),
     "numberOfAbsent": absentStr.toString(),
     "status":status
     };
  
     }
     else{
        sectionWiseAttendance[sec]={
     "numberOfPresent": '0',
     "numberOfAbsent": '0',
     "status":"Not Taken"
     };
     }
    
     }
  
   return sectionWiseAttendance;
}  catch (e) {
  log("error $e");

throw CloudDataReadException('Could not get the total number of present and absent, please try again later !');

}
}

}
      
