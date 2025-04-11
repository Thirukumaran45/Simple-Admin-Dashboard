import 'dart:developer' show log;
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

class AttendanceController extends GetxController {
  late FirebaseCollectionVariable collectionControler;
  late dynamic snapshot;

  @override
  void onInit() {
    super.onInit();
    collectionControler = Get.find<FirebaseCollectionVariable>();
    fetchStudentData();
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

        // Convert dynamic list to List<String> safely
        return List<String>.from(rawList);
      }
    }
  } catch (e) {
    log("Error fetching attendance dates: $e");
  }

  return [];
}


Future<List<String>> fetchUniqueMonthValuesAll() async {
  // Use a Set to avoid duplicates.
final String date = gettoadayDate();
  Set<String> monthValues = {};
  List<String> sections = ['A', 'B', 'C', 'D'];

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
      } catch (e) {
        log('Error in fetching month values for class $i section $sec: $e');
      }
    }
  }

  return monthValues.toList();
}

Future<void> updateAttendance({required String stuClass, required String sec, required String status}) async {
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


}
Future<String> getTeacherName({required String stuClass, required String sec}) async {
  try {
    final String date = gettoadayDate();
    final docRef = collectionControler.attendanceCollection.collection(date).doc("$stuClass$sec");
    
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      return docSnapshot.data()?['teacherName'] ?? '';
    } else {
      return ''; 
    }
  } catch (e) {
    log("Error fetching teacher name: $e");
    return ''; // Return empty string on error
  }
}


  Future<Map<int, Map<String, List<Map<String, dynamic>>>>> fetchStudentData() async {
  final String date = gettoadayDate();

  Map<int, Map<String, List<Map<String, dynamic>>>> classSectionData = {};

  try {
    for (int i = 1; i <= 12; i++) {
      // Initialize inner map for this class.
      classSectionData[i] = {};

      for (String sec in ['A', 'B', 'C', 'D']) {
        // Fetch snapshot for the particular class and section.
        var snapshot = await collectionControler.attendanceCollection
            .collection(date)
            .doc("${i.toString()}$sec")
            .collection("presented_student")
            .get();

        List<Map<String, dynamic>> docs;
        if (snapshot.docs.isNotEmpty) {
          // Map each document to a Map<String, dynamic> containing desired fields.
          docs = snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'rollNumber': data['rollNo'] ?? '',
              'name': data["studentName"] ?? '',
              'id': data["studentId"] ?? '',
              'date': data['date'] ?? '',
              'month': data['month'] ?? '',
              'attendanceStatus': data["status"] ?? 'Absent',
              'percentage':data['percentage']??''
            };
          }).toList();
        } else {
          // If no documents exist, assign a temporary value.
          docs = [
            {
              'rollNumber': 'N/A',
              'name': 'Temporary Value',
              'id': 'N/A',
              'date': '',
              'month': '',
              'attendanceStatus': 'Absent',
              'percentage':"0",
            }
          ];
        }

        // Store the list in the inner map for that section.
        classSectionData[i]![sec] = docs;
      }
    }
  } catch (e) {
    log('Error in fetching the data: $e');
  }
  return classSectionData;
}



 


Future<Map<int, Map<String, String>>> totalNumberOfPresentAndAbsent() async {

final String date = gettoadayDate();

  Map<int, Map<String, String>> classWiseAttendance = {};

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
  return classWiseAttendance;
}

Future<Map<String, Map<String, String>>> getSectionWiseTotalPresentAndAbsent({required String stuClass})async{
final String date = gettoadayDate();

  Map<String, Map<String, String>> sectionWiseAttendance = {};

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
}

}
      
