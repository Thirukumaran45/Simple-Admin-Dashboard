import 'dart:developer'show log;
import 'package:admin_pannel/utils/AppException.dart';

import '../../../services/FireBaseServices/CollectionVariable.dart';
import '../../../modules/studentModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, FieldValue, Query;

import 'package:get/get.dart' ;
import '../../../contant/ConstantVariable.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' show UploadTask, TaskSnapshot;
import 'package:flutter/foundation.dart' show Uint8List,kIsWeb;

class StudentController extends GetxController {
  late FirebaseCollectionVariable collectionControler;
  late dynamic snapshot;
  final RxList<Map<String, dynamic>> studentData = <Map<String, dynamic>>[].obs;
final int _limit = 15;
DocumentSnapshot? _lastDocument;
bool _isFetchingMore = false;
var _context;
  @override
  void onInit() {
    super.onInit();
    collectionControler = Get.find<FirebaseCollectionVariable>();
    fetchStudentData(_context);
  }
 
  void fetchStudentData(dynamic context,) async {
     if (_isFetchingMore) return;

  _isFetchingMore = true;
    try {
       Query query = collectionControler.studentLoginCollection.limit(_limit);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }
  snapshot = await query.get();
  if (snapshot.docs.isNotEmpty) {
     _lastDocument = snapshot.docs.last;
  studentData.value = snapshot.docs.map((doc) {
    return {
      'rollNumber': doc[rollNofield] ?? '',
      'name': doc[studentNamefield] ?? '',
      'id': doc[studentIdField] ?? '',
      'class': doc[classField] ?? '',
      'section': doc[sectionFild] ?? '',
      'parentMobile': doc[motherPhoneNoField] ?? '',
    };
  }).toList().cast<Map<String, dynamic>>(); 
  }
  update();
}   catch (e) {
  log('error in fetching the data $e');
    throw CloudDataReadException("Error in loading student details, please try again later !");

}finally {
    _isFetchingMore = false;
  }
  }

Future<StudentdetailsModel?> studentDataRead(dynamic context,{required String uid}) async {
  try {
    final doc = await collectionControler.studentLoginCollection.doc(uid).get();
    
    if (!doc.exists) {
      log("Document does not exist");
      return null;
    }

    final castedDoc = doc as DocumentSnapshot<Map<String, dynamic>>;
        update(); // Notify GetX listeners
    
    return StudentdetailsModel.fromSnapshot(castedDoc);
    
  }  catch (e) {
    log('Error fetching student data: $e');
        throw CloudDataReadException("Error in getting student details, please try again later !");

  }
  
}

Future<bool> updateStudentDetails(dynamic context,{
  required String uid,
  required String name,
  required String studentClass,
  required String section,
  required String profilePhotoUrl,
  required String fatherName,
  required String fatherNumber,
  required String motherName,
  required String motherNumber,
  required String dob,
  required String email,
  required String address,
  required String totalFee,
  required String feesStatus,
  required String rollNo,
}) async {
  try {
    final docRef = collectionControler.studentLoginCollection.doc(uid);

    await docRef.update({
      rollNofield:rollNo,
      studentNamefield: name,
      classField: studentClass,
      sectionFild: section,
      fatherNameField:fatherName,
      fatherPhoneNoField:fatherNumber,
      motherNameField:motherName,
      motherPhoneNoField:motherNumber,
      dobfield: dob,
      stuentEmailfield:email,
      studentAddress:address,
      totalFees:totalFee,
      feesStatusField:feesStatus,
      profilePhotfield: profilePhotoUrl, // Update photo URL
    });
       fetchStudentData(_context);
        update(); 

    log("Student details updated successfully.");
    return true; // Return success
  } catch (e) {
    log("Error updating student details: $e");
        throw CloudDataUpdateException("Error in updating student details, please try again later !");

  }
}


Future<String> updateStudentPhoto(dynamic context,String studentId,) async {
    String downloadUrl = '';

    final docRef = collectionControler.studentLoginCollection.doc(studentId);

    try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom, // Custom type for specific extensions
            allowedExtensions: ['jpg', 'jpeg', 'png'], // Only allow JPEG and PNG
            withData: kIsWeb, // Needed for web support
        );

        if (result != null) {
            Uint8List? fileBytes;
            File? file;

            if (kIsWeb) {
                // Web case
                fileBytes = result.files.first.bytes;
            } else {
                // Non-web (mobile, desktop)
                file = File(result.files.first.path!);
            }

            final ref = collectionControler.firebaseStorageRef.child("Student photo/$studentId");

            // Upload file
            UploadTask uploadTask;
            if (kIsWeb && fileBytes != null) {
                uploadTask = ref.putData(fileBytes);
            } else if (file != null) {
                uploadTask = ref.putFile(file);
            } else {
                throw Exception("No valid file selected.");
            }

            TaskSnapshot snapshot = await uploadTask;
            downloadUrl = await snapshot.ref.getDownloadURL();
            await docRef.update({
                profilePhotfield: downloadUrl,
            });
        
        } else {
            log("No file selected.");
        update(); // Notify GetX listeners
        }
    } catch (e) {
        log("Error updating student photo: $e");
    throw CloudDataUpdateException("Error in updating student photo, please try again later !");

    }
    return downloadUrl;
}


Future<String?> getStudentPhotoUrl(dynamic context,String studentId) async {
  try {
    final ref =collectionControler.firebaseStorageRef.child("Student photo/$studentId");
    final doc = await ref.getDownloadURL();
        update(); // Notify GetX listeners
    return doc;
  } catch (e) {
    log(
      'error in getting the downloads url $e'); 
        throw CloudDataReadException("Error in getting student photo, please try again later !");

  }
}

Future<void> registerUser({
  required String studentName,
  required String stuClass,
  required String stuSection,
  required String sturollNo,
  required String stuEmail,
  required String stufatherName,
  required String stumotherName,
  required String stufatherNo,
  required String stumotherNo,
  required String stuDob,
  required String stuAdminNo,
  required String stuAddress,
  required dynamic stupicUrl,
  required String userId,
  required dynamic context,
}) async {
  try {
  
  
    await collectionControler.studentLoginCollection.doc(userId).set({
      studentNamefield: studentName,
      classField:stuClass,
      studentIdField:userId,
      profilePhotfield:stupicUrl,
      sectionFild:stuSection,
      rollNofield:sturollNo,
      stuentEmailfield:stuEmail,
      fatherNameField:stufatherName,
      motherNameField:stumotherName,
      fatherPhoneNoField:stufatherNo,
      motherPhoneNoField:stumotherNo,
      dobfield:stuDob,
      attendancePercentageField:'',
      feesStatusField:"Pending",
      todayAttendanceStatusField:'',
      studentrole:"Student",
      studentAdminssionNoField:stuAdminNo,
      studentAddress:stuAddress,
      totalAttendanceDays:''
    });
      fetchStudentData(context);
        update(); // Notify GetX listeners

  } catch (e) {
    log(e.toString());
     throw CloudDataWriteException("Error in adding student details, please try again later !");

                               
   
  }
}
Future<dynamic> addPhoto(dynamic context,) async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, // Custom type for specific extensions
      allowedExtensions: ['jpg', 'jpeg', 'png'], // Only allow JPEG and PNG
      withData: kIsWeb, // Needed for web support
    );

    if (result != null) {
      if (kIsWeb) {
        return result.files.first.bytes;
      } else {
        return File(result.files.first.path!);
      }
    } 
        update(); // Notify GetX listeners

  } catch (e) {
    log(e.toString());
    throw CloudDataWriteException("Error in adding student details, please try again later !");

  }
}  

Future<String> photoStorage(dynamic context,{required String userId, required dynamic image}) async {
  String downloadUrl = '';

  try {
  final ref = collectionControler.firebaseStorageRef.child("Student photo/$userId");
  
  UploadTask uploadTask;
  
  if (kIsWeb && image is Uint8List) {
    // Web: Use putData for Uint8List
    uploadTask = ref.putData(image);
  } else if (image is File) {
    // Mobile: Use putFile for File
    uploadTask = ref.putFile(image);
  } else {
        throw CloudDataWriteException("Error in adding student photo, please try again later !");
  }
  
  // Wait for upload to complete
  TaskSnapshot snapshot = await uploadTask;
  
  // Get download URL
  downloadUrl = await snapshot.ref.getDownloadURL();
        update(); // Notify GetX listeners
  
  return downloadUrl;
}  catch (e) {
    throw CloudDataWriteException("Error in adding student photo, please try again later !");
  
}
}

Future<void> updateNumberOfStudent(dynamic context,bool isIncrement) async {


try {
  final dataDoc = collectionControler.loginCollection.doc('students');
  final val = await dataDoc.get();
  
  if(val.exists)
  {
   await collectionControler.loginCollection.doc('students').update({
      'numberOfPeople': FieldValue.increment(isIncrement ? 1 : -1),
    });
  }
  else
  {
     await collectionControler.loginCollection.doc('students').set({
      'numberOfPeople': 1,
    });
  }
          update(); 
}  catch (e) {
    throw CloudDataUpdateException("Error in updating number of student details, please try again later !");
  
}
// Notify GetX listeners


}



Future<bool> deleteStudent(dynamic context,{
  required String studentId,
  required String stuClass,
  required String stuSec,
}) async {
  try {
    // Check if student exists in Firestore before deleting
    final studentDoc = await collectionControler.studentLoginCollection.doc(studentId).get();
    if (studentDoc.exists) {
      await collectionControler.studentLoginCollection.doc(studentId).delete();
    }

    // Check if student photo exists in Storage before deleting
    final studentPhotoRef = collectionControler.firebaseStorageRef.child("Student photo/$studentId");
    if ((await studentPhotoRef.listAll()).items.isNotEmpty) {
      await studentPhotoRef.delete();
    }

    // Check if AnnouncementChatPost exists before deleting
    final announcementRef = collectionControler.firebaseStorageRef.child("AnnouncementChatPost/$studentId");
    if ((await announcementRef.listAll()).items.isNotEmpty) {
      await announcementRef.delete();
    }

    // Check if RemainderChatPost exists before deleting
    final remainderRef = collectionControler.firebaseStorageRef.child("RemainderChatPost/$stuClass/$stuSec/$studentId");
    if ((await remainderRef.listAll()).items.isNotEmpty) {
      await remainderRef.delete();
    }
   await updateNumberOfStudent(_context,false);
   studentData .removeWhere((staff) => staff['id'] == studentId);

        update(); // Notify GetX listeners

  log("deleted the student data");
    return true;
  } catch (e) {
    log("Error in delete: $e");
    throw CloudDataDeleteException("Error in deleting student details, please try again later !");

  }
}
}