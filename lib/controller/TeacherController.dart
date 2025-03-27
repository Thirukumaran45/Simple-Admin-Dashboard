import 'dart:developer'show log;
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:admin_pannel/constant.dart';
import 'package:admin_pannel/modules/teacherModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, FieldValue;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; 
class Teachercontroller extends GetxController{
  late FirebaseCollectionVariable collectionControler;
  late dynamic snapshot;
 final RxList<Map<String, dynamic>> teacherData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    collectionControler = Get.find<FirebaseCollectionVariable>();
    fetchTeacherData();
  }

void fetchTeacherData() async {
  try {
    snapshot = await collectionControler.teacherLoginCollection.get();
    teacherData.value = snapshot.docs.asMap().entries.map((entry) {
      int index = entry.key + 1; // Auto-generate serial number starting from 1
      var doc = entry.value;

      return {
        'sNo': index.toString(),
        'name': doc[teacherNameField] ?? '',
        'id': doc[teacherIdFireld] ?? '',
        'degree': doc[collegedegreefield] ?? '',
        'email': doc[teacherEmailfield] ?? '',
        'phone': doc[teacherPhoneNumberfield] ?? '',
      };
    }).toList().cast<Map<String, dynamic>>(); ;
  } catch (e) { 
    log('Error in fetching the data: $e');
  }
}
 

Future<Teacherdetailmodel?> teacherDataRead({required String uid}) async {
  try {
    final doc = await collectionControler.teacherLoginCollection.doc(uid).get();
    
    if (!doc.exists) {
      log("Document does not exist");
      return null;
    }

    final castedDoc = doc as DocumentSnapshot<Map<String, dynamic>>;
    
    return Teacherdetailmodel.fromSnapshot(castedDoc);
  }  catch (e) {
    log('Error fetching teacher data: $e');
    return null;
  }
}

Future<bool> updateTeacherDetails({
  required String teacherProfile,
  required String teacherName,
  required String teacherEmail,
  required String teacherPhoneNumber,
  required String teacherAddress,
  required String dateofemployment,
  required String collegedegree,
  required String yearofexperience,
  required String teacherSubjectHandling,
  required String userId,
  required String role,
}) async {
  try {
    final docRef = collectionControler.teacherLoginCollection.doc(userId);
    await docRef.update({
      teacherProfileField:teacherProfile,
      teacherNameField: teacherName,
      teacherEmailfield:teacherEmail,
      teacherPhoneNumberfield:teacherPhoneNumber,
      teacherAddressfield:teacherAddress,
      dateofEmploymentfield:dateofemployment,
      collegedegreefield:collegedegree,
      yearOfExperiencefield:yearofexperience,
      teacherSubjectHandlingfield:teacherSubjectHandling,
      teacherIdFireld:userId,
      teacherrole:role
    });

    log("teacher details updated successfully.");
    return true; // Return success
  } catch (e) {
    log("Error updating teacher details: $e");
    return false; // Return failure
  }
}


Future<String> updateTeacherPhoto(String teacherId,) async {
    String downloadUrl = '';
    final docRef = collectionControler.teacherLoginCollection.doc(teacherId);

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

            final ref = collectionControler.firebaseStorageRef.child("Teacher photo/$teacherId");

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
        log("Error updating teacher photo: $e");
    }
    return downloadUrl;
}


Future<String?> getTeacherPhotoUrl(String teacherId) async {
  try {
    final ref =collectionControler.firebaseStorageRef.child("Teacher photo/$teacherId");
    final doc = await ref.getDownloadURL();
    return doc;
  } catch (e) {
    log(
      'error in getting the downloads url $e'); 
    return null; 
  }
}

Future<void> registerTeacher({
  required String teacherProfile,
  required String teacherName,
  required String teacherEmail,
  required String teacherPhoneNumber,
  required String teacherAddress,
  required String dateofemployment,
  required String collegedegree,
  required String yearofexperience,
  required String teacherSubjectHandling,
  required String userId,
  required String role,
  required BuildContext context,
}) async {
  try {
  
  
    await collectionControler.teacherLoginCollection.doc(userId).set({
       teacherProfileField:teacherProfile,
      teacherNameField: teacherName,
      teacherEmailfield:teacherEmail,
      teacherPhoneNumberfield:teacherPhoneNumber,
      teacherAddressfield:teacherAddress,
      dateofEmploymentfield:dateofemployment,
      collegedegreefield:collegedegree,
      yearOfExperiencefield:yearofexperience,
      teacherSubjectHandlingfield:teacherSubjectHandling,
      teacherIdFireld:userId,
      teacherrole:role
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

  final ref = collectionControler.firebaseStorageRef.child("Teacher photo/$userId");

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

Future<void> updateNumberOfTeacher(bool isIncrement) async {
  await collectionControler.loginCollection.doc('teachers').update({
    'numberOfPeople': FieldValue.increment(isIncrement ? 1 : -1),
  });
}



Future<bool> deleteTeacher({
  required String teacherId,
}) async {
  try {
  String autoId='';
  final teacherDoc = await collectionControler.teacherLoginCollection.doc(teacherId).get();
  if (teacherDoc.exists) {
    await collectionControler.teacherLoginCollection.doc(teacherId).delete();
  }
  
  // Check if student photo exists in Storage before deleting
  final teacherPhotoRef = collectionControler.firebaseStorageRef.child("Teacher photo/$teacherId");
  if ((await teacherPhotoRef.listAll()).items.isNotEmpty) {
    await teacherPhotoRef.delete();
  }
  
  // Check if AnnouncementChatPost exists before deleting
  final announcementRef = collectionControler.firebaseStorageRef.child("AnnouncementChatPost/$teacherId");
  if ((await announcementRef.listAll()).items.isNotEmpty) {
    await announcementRef.delete();
  }
  
  // Assume teacherUid, stuClass, and stuSec are already defined.
  final studentDocs = await collectionControler.studentLoginCollection.get();
  
  // Iterate over each student document.
  for (final studentDoc in studentDocs.docs) {
  final studentId = studentDoc.id; // Get student document ID
  
  // Reference to the student's assignments subcollection
  final studentAssignmentsRef = collectionControler.studentLoginCollection
      .doc(studentId)
      .collection('assignments');
  
  // Query assignments where the field 'id' matches teacherUid
  final querySnapshot = await studentAssignmentsRef.where('id', isEqualTo: teacherId).get();
  
  for (final doc in querySnapshot.docs) {
    // Retrieve autoId field value
     autoId = doc.data()['autoId'];
  
    // Delete Firestore document
    await doc.reference.delete();
  }
  }
  
  
  // Iterate through all class and section combinations
  for (int classNum = 1; classNum <= 12; classNum++) {
  for (String section in ['A', 'B', 'C', 'D']) {
    final storageAssigmentRef = collectionControler.firebaseStorageRef.child("assignments/$classNum/$section/$autoId");
    
    if ((await storageAssigmentRef.listAll()).items.isNotEmpty) {
      await storageAssigmentRef.delete();
    }
  
  }
  }
  
   // Iterate through all class and section combinations
  for (int classNum = 1; classNum <= 12; classNum++) {
  for (String section in ['A', 'B', 'C', 'D']) {
    final remainderRef = collectionControler.firebaseStorageRef.child("RemainderChatPost/$classNum/$section/$teacherId");
    
    if ((await remainderRef.listAll()).items.isNotEmpty) {
      await remainderRef.delete();
    }
  }
  }
  await updateNumberOfTeacher(false);
  
  log("deleted the teacher data");
  return true;
}  catch (e) {
  log("error inn deleting :$e");
  return false;
}

}
}