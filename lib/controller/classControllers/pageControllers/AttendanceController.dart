import 'dart:developer' show log;
import 'package:admin_pannel/services/FirebaseException/pageException.dart' ;
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
    throw CloudDataReadException(" Fetching error, please try again later !"); 
  }
 
  return [];
}


Future<List<String>> fetchUniqueMonthValuesAll() async {
  
final List<String> listDate = await getAttendanceDates();
  Set<String> monthValues = {};
  List<String> sections = ['A', 'B', 'C', 'D'];

for( String date in listDate){
  for (int i = 1; i <= 12; i++) {
    for (String sec in sections) {
      try {
        var snapshot = await collectionControler.attendanceCollection.collection(date)

            .doc("${i.toString()}$sec")
            .collection("presented_student")
            .get();

        for (var doc in snapshot.docs) {
          final data = doc.data() ;
          if (data.containsKey('month') && data['month'] != null) {
            monthValues.add(data['month']);
          }
        }
       update();
      } catch (e) {
        log('Error in fetching month values for class $i section $sec: $e');
        throw CloudDataReadException('Error in getting attendacne month values');
      }
    }
  }
}

  return monthValues.toList();
}

Future<void> updateAttendance({required String stuClass, required String sec, required String status}) async {
  try {
  final String date = gettoadayDate();
  
  final snapshot = await collectionControler.attendanceCollection
      .collection(date)
      .doc("$stuClass$sec")
      .collection("presented_student")
      .get();
  
  for (var doc in snapshot.docs) {
    final String id = doc.data()["studentId"]; // Extract studentId for each document
  
    // Update attendance status in the attendance collection
    await doc.reference.update({'attendanceStatus': status});
  
    // Update the student's document in studentLoginCollection
    await collectionControler.studentLoginCollection.doc(id).update({
      "Today Attendance": status,
    });
  }
       update();

}  catch (e) {
  log('error in updating the attendance $e');
  throw CloudDataReadException("Updating the attendance is failed, please try again later !");
}

}

Future<String> getTeacherName({required String stuClass, required String sec}) async {
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
Future<List<Map<String, dynamic>>> fetchPagedStudents({
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
    }
    if (monthFilter.isNotEmpty) {
      query = query.where('month', isEqualTo: monthFilter);
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

 


Future<Map<int, Map<String, String>>> totalNumberOfPresentAndAbsent() async {

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
        final String presentStr = data?["number of Student present"] ?? '0';
        final String absentStr = data?["number of Student absent"] ?? '0';
        final String status = data?["class attendance status"] ?? 'Not Taken';
  
        totalPresent += int.tryParse(presentStr) ?? 0;
        totalAbsent += int.tryParse(absentStr) ?? 0;
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
  log(e.toString());
  throw CloudDataReadException('Could not get the total number of present and absent, please try again later !');
}
}

Future<Map<String, Map<String, String>>> getSectionWiseTotalPresentAndAbsent({required String stuClass})async{
final String date = gettoadayDate();

  Map<String, Map<String, String>> sectionWiseAttendance = {};

   try {
  for (String sec in ['A','B','C','D']) {
     final docRef = collectionControler.attendanceCollection.collection(date)
         .doc("$stuClass$sec");
  
     final docSnapshot = await docRef.get();
  
     if (docSnapshot.exists) {
       final data = docSnapshot.data(); // Explicitly cast to a Map
      final String  presentStr = data?["number of Student present"] ?? '0';
       final String  absentStr = data?["number of Student absent"] ?? '0';
       final String  status = data?["class attendance status"] ?? 'Not Taken';
  
     sectionWiseAttendance[sec]={
     "numberOfPresent": presentStr,
     "numberOfAbsent": absentStr,
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
throw CloudDataReadException('Could not get the total number of present and absent, please try again later !');

}
}

}
      
