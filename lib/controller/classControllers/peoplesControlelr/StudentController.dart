import 'dart:developer'show log;
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:admin_pannel/contant/constant.dart';
import 'package:admin_pannel/modules/studentModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, FieldValue;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' show UploadTask, TaskSnapshot;
import 'package:flutter/foundation.dart' show Uint8List,kIsWeb;

class StudentController extends GetxController {
  late FirebaseCollectionVariable collectionControler;
  late dynamic snapshot;
  final RxList<Map<String, dynamic>> studentData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    collectionControler = Get.find<FirebaseCollectionVariable>();
    fetchStudentData();
  }
 
  void fetchStudentData() async {
    try {
  snapshot = await collectionControler.studentLoginCollection.get();
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
}   catch (e) {
  log('error in fetching the data $e');
        update(); // Notify GetX listeners
}
  }

Future<StudentdetailsModel?> studentDataRead({required String uid}) async {
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
    return null;
  }
  
}

Future<bool> updateStudentDetails({
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
        update(); // Notify GetX listeners

    log("Student details updated successfully.");
    return true; // Return success
  } catch (e) {
    log("Error updating student details: $e");
    return false; // Return failure
  }
}


Future<String> updateStudentPhoto(String studentId,) async {
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
    }
    return downloadUrl;
}


Future<String?> getStudentPhotoUrl(String studentId) async {
  try {
    final ref =collectionControler.firebaseStorageRef.child("Student photo/$studentId");
    final doc = await ref.getDownloadURL();
        update(); // Notify GetX listeners
    return doc;
  } catch (e) {
    log(
      'error in getting the downloads url $e'); 
    return null; 
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
  required BuildContext context,
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

      await customSnackbar(context: context, text: "Registration succesfull");
         fetchStudentData();

        update(); // Notify GetX listeners

  } catch (e) {
    log(e.toString());
      await customSnackbar(context: context, text: "failed to create person $e");
                               
   
  }
}
Future<dynamic> addPhoto() async {
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
  }
}  

Future<String> photoStorage({required String userId, required dynamic image}) async {
  String downloadUrl = '';

  final ref = collectionControler.firebaseStorageRef.child("Student photo/$userId");

  UploadTask uploadTask;

  if (kIsWeb && image is Uint8List) {
    // Web: Use putData for Uint8List
    uploadTask = ref.putData(image);
  } else if (image is File) {
    // Mobile: Use putFile for File
    uploadTask = ref.putFile(image);
  } else {
    throw Exception("Invalid image format");
  }

  // Wait for upload to complete
  TaskSnapshot snapshot = await uploadTask;

  // Get download URL
  downloadUrl = await snapshot.ref.getDownloadURL();
        update(); // Notify GetX listeners

  return downloadUrl;
}

Future<void> updateNumberOfStudent(bool isIncrement) async {


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
        update(); // Notify GetX listeners


}



Future<bool> deleteStudent({
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
   await updateNumberOfStudent(false);
   studentData .removeWhere((staff) => staff['id'] == studentId);

        update(); // Notify GetX listeners

  log("deleted the student data");
    return true;
  } catch (e) {
    log("Error in delete: $e");
    return false;
  }
}
}