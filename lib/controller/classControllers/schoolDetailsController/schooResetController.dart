import 'dart:developer' show log;

import '../../../FireBaseServices/CollectionVariable.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FieldValue;
import 'package:get/get.dart' show Get, GetxController, Inst;

class SchoolResetYearController extends GetxController
{
late FirebaseCollectionVariable collectionVariable;
List<String> collectionNames=[];

  @override
  void onInit() {
    super.onInit();
    collectionVariable = Get.find();
    initializeList();
  }

  void initializeList() async {
    collectionNames = await getAttendanceDates();
    log(collectionNames.toString());
    update(); 
  }

//delete funtion for fireabse storage

Future<void> deleteStorageDirectory(String directoryPath) async {
  try {
    final storage = collectionVariable.firebaseStorageInstance;
    final  dirRef = storage.ref(directoryPath);

    final  result = await dirRef.listAll();
    for (var  fileRef in result.items) {
      await fileRef.delete();
    }

    for (var folderRef in result.prefixes) {
      await deleteStorageDirectory(folderRef.fullPath);
    }

  } catch (e) {
    log(' Error deleting storage directory: $e');
  }
    update(); 

}  


//delete the attendance data 
Future<List<String>> getAttendanceDates() async {
  try {
    final overallDaysDoc = await collectionVariable.attendanceCollection.get();

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
    update(); 

  return [];
}

Future<void> deleteAttendanceDataByClass(String className) async {
  try {
    bool isAnyCollectionLeft = false;

    for (String section in ['A', 'B', 'C', 'D']) {
      String docId = "$className$section";

      for (String collectionName in collectionNames) {
        var collectionRef = collectionVariable.attendanceCollection.collection(collectionName);

        final val = collectionRef.doc(docId);
        final doc = val.collection('presented_student');
        final data = await doc.get();

        for (var doc in data.docs) {
          await doc.reference.delete();
        }
        if (data.docs.isEmpty) {
          await doc.doc().delete();
        }
        await val.delete();

        final coldata = await collectionRef.get();
        if (coldata.docs.isEmpty) {
          await collectionRef.doc().delete();
          
          // **Remove collectionName from attendance_dates field**
          await collectionVariable.attendanceCollection.update({
            'attendance_dates': FieldValue.arrayRemove([collectionName])
          });
        } else {
          isAnyCollectionLeft = true;
        }
      }
    }

    // **Check if any sub-collections exist under attendanceCollection**
    final subCollections = await collectionVariable.attendanceCollection.firestore
        .collectionGroup(collectionVariable.attendanceCollection.id)
        .get();

    if (subCollections.docs.isEmpty && !isAnyCollectionLeft) {
      await collectionVariable.attendanceCollection.delete();
      log("Deleted attendanceCollection as no collections were left.");
    }

  } catch (e) {
    log("Error deleting attendance data: $e");
  }
  update();
}


Future<void> deleteAttendanceDataByClassSection( String className, String section) async {
  try {
    bool isAnyCollectionLeft = false;

    String docId = "$className$section";

      for (String collectionName in collectionNames) {
        var collectionRef = collectionVariable.attendanceCollection.collection(collectionName);

        final val = collectionRef.doc(docId);
        final doc = val.collection('presented_student');
        final data = await doc.get();

        for (var doc in data.docs) {
          await doc.reference.delete();
        }
        if (data.docs.isEmpty) {
          await doc.doc().delete();
        }
        await val.delete();

        final coldata = await collectionRef.get();
        if (coldata.docs.isEmpty) {
          await collectionRef.doc().delete();
          
          // **Remove collectionName from attendance_dates field**
          await collectionVariable.attendanceCollection.update({
            'attendance_dates': FieldValue.arrayRemove([collectionName])
          });
        } else {
          isAnyCollectionLeft = true;
        }
      }
    

    // **Check if any sub-collections exist under attendanceCollection**
    final subCollections = await collectionVariable.attendanceCollection.firestore
        .collectionGroup(collectionVariable.attendanceCollection.id)
        .get();

    if (subCollections.docs.isEmpty && !isAnyCollectionLeft) {
      await collectionVariable.attendanceCollection.delete();
      log("Deleted attendanceCollection as no collections were left.");
    }


  } catch (e) {
    log("Error deleting attendance data: $e");
  }
    update(); 

}



//delete the reaminder by class and section wise 

Future<void> deleteRemainderChatDataByClassSection({
  required String stuClass,
  required String stuSec,
}) async {
  try {
    final  remainderCollection = collectionVariable.remainderCollection;
    
    final  querySnapshot = await remainderCollection
        .doc(stuClass)
        .collection(stuSec)
        .get();

    for (var  doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
    

    String storagePath = 'RemainderChatPost/$stuClass/$stuSec/';
    await deleteStorageDirectory(storagePath);

    log(' Storage files deleted successfully!');

  } catch (e) {
    log('Error deleting remainder chat data: $e');
  }
    update(); 

}

Future<void> deleteRemainderChatDataByClass({
  required String stuClass,
}) async {
  try {
    final  remainderCollection = collectionVariable.remainderCollection;
    
   for(String stuSec in ['A','B','C','D']) {
    final  querySnapshot = await remainderCollection
        .doc(stuClass)
        .collection(stuSec)
        .get();

    for (var  doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
    

    String storagePath = 'RemainderChatPost/$stuClass/$stuSec/';
    await deleteStorageDirectory(storagePath);
  }
    log(' Storage files deleted successfully!');

  } catch (e) {
    log('Error deleting remainder chat data: $e');
  }
    update(); 

}



// delete the annoucement chat 

  Future<void>deleteSchoolChatData()async{

  try {
    final  schoolChatCollection = collectionVariable.announcementCollection;
    
    final  querySnapshot = await schoolChatCollection.get();

    for (var  doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
    
    String storagePath = 'AnnouncementChatPost/';
    await deleteStorageDirectory(storagePath);

    log(' Storage files deleted successfully!');

  } catch (e) {
    log('Error deleting schoolChat chat data: $e');
  }
    update(); 

  }


//delete exam result by class and sec
Future<void> deleteExamDataByClass({required String stuClass}) async {

  final examSnapshot = collectionVariable.studentLoginCollection;
  final querySnapshot = await examSnapshot
      .where('class', isEqualTo: stuClass)
      .get();

  for (var doc in querySnapshot.docs) {
    final examResultRef = doc.reference.collection('exam_result');

    final examResultSnapshot = await examResultRef.get();

    for (var examDoc in examResultSnapshot.docs) {
      await examDoc.reference.delete();
    }
    
  }
    update(); 

}

Future<void> deleteExamDataByClassSection({required String stuClass, required String stuSec}) async {

  final examSnapshot = collectionVariable.studentLoginCollection;
  final querySnapshot = await examSnapshot
      .where('class', isEqualTo: stuClass)
      .where('section', isEqualTo: stuSec)
      .get();

  for (var doc in querySnapshot.docs) {
    final examResultRef = doc.reference.collection('exam_result');

    final examResultSnapshot = await examResultRef.get();

    for (var examDoc in examResultSnapshot.docs) {
      await examDoc.reference.delete();
    }
    
  }
    update(); 

}


//delete exam result by class and sec
Future<void> deleteAssignmentByClassSection({required String stuClass, required String stuSec}) async {

  final examSnapshot = collectionVariable.studentLoginCollection;
  final querySnapshot = await examSnapshot
      .where('class', isEqualTo: stuClass)
      .where('section', isEqualTo: stuSec)
      .get();

  for (var doc in querySnapshot.docs) {
    final examResultRef = doc.reference.collection('assignments');

    final examResultSnapshot = await examResultRef.get();

    for (var examDoc in examResultSnapshot.docs) {
      await examDoc.reference.delete();
    }
  
  }

    String storagePath = 'assignments/$stuClass/$stuSec/';
    await deleteStorageDirectory(storagePath);

    update(); 

}

Future<void> deleteAssignmentByClass({required String stuClass, }) async {

  final examSnapshot = collectionVariable.studentLoginCollection;
  final querySnapshot = await examSnapshot
      .where('class', isEqualTo: stuClass)
      .get();

  for (var doc in querySnapshot.docs) {
    final examResultRef = doc.reference.collection('assignments');

    final examResultSnapshot = await examResultRef.get();

    for (var examDoc in examResultSnapshot.docs) {
      await examDoc.reference.delete();
    }
  
  }
  for(String stuSec in ['A','B','C','D']){
   String storagePath = 'assignments/$stuClass/$stuSec/';
    await deleteStorageDirectory(storagePath);
  }
    update(); 


}


//delete leave histry

Future<void> deleteLeaveHistrytByClassSection({required String stuClass, required String stuSec}) async {

  final examSnapshot = collectionVariable.studentLoginCollection;
  final querySnapshot = await examSnapshot
      .where('class', isEqualTo: stuClass)
      .where('section', isEqualTo: stuSec)
      .get();

  for (var doc in querySnapshot.docs) {
    final examResultRef = doc.reference.collection('leave_histry');

    final examResultSnapshot = await examResultRef.get();

    for (var examDoc in examResultSnapshot.docs) {
      await examDoc.reference.delete();
    }
  
  }
    update(); 

}

Future<void> deleteLeaveHistryByClass({required String stuClass, }) async {

  final examSnapshot = collectionVariable.studentLoginCollection;
  final querySnapshot = await examSnapshot
      .where('class', isEqualTo: stuClass)
      .get();

  for (var doc in querySnapshot.docs) {
    final examResultRef = doc.reference.collection('leave_histry');

    final examResultSnapshot = await examResultRef.get();

    for (var examDoc in examResultSnapshot.docs) {
      await examDoc.reference.delete();
    }
  
  }
    update(); 


}
//delete teacher 


Future<void> deleteAssignmentByTeacherClassSection({required String stuClass,required String stuSec}) async {
  try {
    final querySnapshot =await  collectionVariable.teacherLoginCollection.get();

  

    for (var teacherDoc in querySnapshot.docs) {
      final assignmentCollection = teacherDoc.reference.collection('assigments');
      final assignmentSnapshot = await assignmentCollection
      .where('class', isEqualTo: stuClass)
      .where('section', isEqualTo: stuSec)
      .get();

      for (var assignmentDoc in assignmentSnapshot.docs) {
        // Fetch and delete all documents inside 'submitted_students'
        final submittedStudents = await assignmentDoc.reference.collection('submitted_students').get();
        
        for (var studentDoc in submittedStudents.docs) {
          await studentDoc.reference.delete();
        }

        // Delete the assignment document itself
        await assignmentDoc.reference.delete();
      }

      // Check if the 'assigments' collection is empty and delete it
      final updatedAssignmentSnapshot = await assignmentCollection.get();
      if (updatedAssignmentSnapshot.docs.isEmpty) {
        await assignmentCollection.doc().delete(); // Ensure deletion
      }

      
    }

    log("Assignments deleted successfully for class $stuClass.");

  } catch (e) {
    log("Error deleting assignments: $e");
  }
    update(); 

}


Future<void> deleteAssignmentByTeacherClass({required String stuClass}) async {
  try {
    final querySnapshot =await  collectionVariable.teacherLoginCollection.get();

    // Fetch all teachers who have assignments for this 


    for (var teacherDoc in querySnapshot.docs) {
      final assignmentCollection = teacherDoc.reference.collection('assigments');

      final assignmentSnapshot = await assignmentCollection
      .where('class', isEqualTo: stuClass).
      get();

      for (var assignmentDoc in assignmentSnapshot.docs) {
        // Fetch and delete all documents inside 'submitted_students'
        final submittedStudents = await assignmentDoc.reference.collection('submitted_students').get();
        
        for (var studentDoc in submittedStudents.docs) {
          await studentDoc.reference.delete();
        }

        // Delete the assignment document itself
        await assignmentDoc.reference.delete();
      }

      // Check if the 'assigments' collection is empty and delete it
      final updatedAssignmentSnapshot = await assignmentCollection.get();
      if (updatedAssignmentSnapshot.docs.isEmpty) {
        await assignmentCollection.doc().delete(); // Ensure deletion
      }
    }

    log("Assignments deleted successfully for class $stuClass.");

  } catch (e) {
    log("Error deleting assignments: $e");
  }
    update(); 

}


// delete the time_table

  Future<void>deleteTimeTableDataByClass({required String stuClass})async{
    final examSnapshot = collectionVariable.timetableCollection;
     final List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

    for(String sec in ['A','B','C','D'])
    {
      String docId = '$stuClass$sec';
       for(String day in days)
      {
       final docs = await examSnapshot.doc(docId).collection(day).get(); 
      for(var doc in docs.docs)
      {
        await doc.reference.delete();
      }
      }
         // **Check if any sub-collections exist under attendanceCollection**
    final subCollections = await examSnapshot.doc(docId).firestore
        .collectionGroup(examSnapshot.doc(docId).id)
        .get();

    if (subCollections.docs.isEmpty ) {
      await examSnapshot.doc(docId).delete();
      log("Deleted timetableCollection as no collections were left.");
    }
    }
    update(); 
  
  }


  Future<void>deleteTimeTableDataByClassSection({required String stuClass,required String sec})async{
    final examSnapshot = collectionVariable.timetableCollection;
     final List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

      String docId = '$stuClass$sec';
      for(String day in days)
      {
       final docs = await examSnapshot.doc(docId).collection(day).get(); 
      for(var doc in docs.docs)
      {
        await doc.reference.delete();
      }
      }
       // **Check if any sub-collections exist under attendanceCollection**
    final subCollections = await examSnapshot.doc(docId).firestore
        .collectionGroup(examSnapshot.doc(docId).id)
        .get();

    if (subCollections.docs.isEmpty ) {
      await examSnapshot.doc(docId).delete();
      log("Deleted timetableCollection as no collections were left.");
    }
    update(); 
 
  }


// fees transaction hisrty delete
Future<void> deleteFeesTransactionByClassSection({required String stuClass, required String stuSec}) async {

  final examSnapshot = collectionVariable.feesDocCollection.collection("completedTransaction");
  final querySnapshot = await examSnapshot
      .where('class', isEqualTo: stuClass)
      .where('section', isEqualTo: stuSec)
      .get();

  for (var doc in querySnapshot.docs) {
    await doc.reference.delete();
  }
    update(); 

}
 
  
}