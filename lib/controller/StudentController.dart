import 'dart:developer'show log;
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:admin_pannel/constant.dart';
import 'package:admin_pannel/modules/studentModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, FieldValue;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; 
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
  return downloadUrl;
}

Future<void>updateNumberofStudent()async{
 await collectionControler.loginCollection.doc('students').update({
      'numberOfPeople': FieldValue.increment(1),
    });
}

Future<void>deleteStudent({required String studentId, required String stuClass , required String stuSec})async{
 await collectionControler.studentLoginCollection.doc(studentId).delete();
 await collectionControler.firebaseStorageRef.child("Student photo/$studentId").delete();
 await collectionControler.firebaseStorageRef.child("AnnouncementChatPost/$studentId").delete();
 await collectionControler.firebaseStorageRef.child("RemainderChatPost/$stuClass/$stuSec/$studentId").delete();
}

}