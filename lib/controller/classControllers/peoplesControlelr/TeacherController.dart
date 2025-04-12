import 'dart:developer'show log;
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:admin_pannel/contant/constant.dart';
import 'package:admin_pannel/modules/teacherModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, FieldValue;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' show UploadTask, TaskSnapshot;
import 'package:flutter/foundation.dart' show Uint8List,kIsWeb;

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
    }).toList().cast<Map<String, dynamic>>();
  } catch (e) { 
    log('Error in fetching the data: $e');
  }
   update(); // Notify GetX listeners
}
 

Future<Teacherdetailmodel?> teacherDataRead({required String uid}) async {
  try {
    final doc = await collectionControler.teacherLoginCollection.doc(uid).get();
    
    if (!doc.exists) {
      log("Document does not exist");
      return null;
    }

    final castedDoc = doc as DocumentSnapshot<Map<String, dynamic>>;
     update(); // Notify GetX listeners
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
    update(); // Notify GetX listeners
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

            final ref = collectionControler.firebaseStorageRef.child("Teacher Photo/$teacherId");

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
         update(); // Notify GetX listeners
    } catch (e) {
        log("Error updating teacher Photo: $e");
    }
    return downloadUrl;
}


Future<String?> getTeacherPhotoUrl(String teacherId) async {
  try {
    final ref =collectionControler.firebaseStorageRef.child("Teacher Photo/$teacherId");
    final doc = await ref.getDownloadURL();
     update(); // Notify GetX listeners
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
if(!context.mounted)return;
      await customSnackbar(context: context, text: "Registration succesfull");
      fetchTeacherData();
     update();
  } catch (e) {
    log(e.toString());
if(!context.mounted)return;

      await customSnackbar(context: context, text: "failed to create person $e");
  }
   update(); // Notify GetX listeners
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

  final ref = collectionControler.firebaseStorageRef.child("Teacher Photo/$userId");

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

Future<void> updateNumberOfTeacher(bool isIncrement) async {
  
final dataDoc = collectionControler.loginCollection.doc('teachers');
final val = await dataDoc.get();

if(val.exists)
{
 await collectionControler.loginCollection.doc('teachers').update({
    'numberOfPeople': FieldValue.increment(isIncrement ? 1 : -1),
  });
}
else
{
   await collectionControler.loginCollection.doc('teachers').set({
    'numberOfPeople': 1,
  });
}
 update(); // Notify GetX listeners
}



Future<bool> deleteTeacher({
  required String teacherId,
}) async {
  try {
  String autoId='';
  final teacherDoc = await collectionControler.teacherLoginCollection.doc(teacherId).get();

  if (teacherDoc.exists) {
    // Reference to the assignments collection
    final assignmentsCollection = collectionControler.teacherLoginCollection
        .doc(teacherId)
        .collection("assigments");

    // Fetch all documents in the assignments collection
    final assignmentsSnapshot = await assignmentsCollection.get();

    // Delete each assignment document
    for (var doc in assignmentsSnapshot.docs) {
      await doc.reference.delete();
    }

    // Now delete the teacher document
    await collectionControler.teacherLoginCollection.doc(teacherId).delete();
  }
  // Check if student photo exists in Storage before deleting
  final teacherPhotoRef = collectionControler.firebaseStorageRef.child("Teacher Photo/$teacherId");
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
   teacherData .removeWhere((staff) => staff['id'] == teacherId);

   update(); // Notify GetX listeners
  log("deleted the teacher data");
  return true;
}  catch (e) {
  log("error inn deleting :$e");
  return false;
}

}

Future<void>addAndUpdateClassInchargers({required String stuClass,
 required String stuSec, required String name,
 required String phoneNo,
 required String email
})async{
String section = stuSec.toUpperCase();
final data =  collectionControler.loginCollection.doc('teachers').collection('ClassIncharger');
final isData = await data.doc("$stuClass$section").get();  
if(isData.exists)
{
await data.doc('$stuClass$section').update({
"name": name,
"phoneNo":phoneNo,
"email":email
});
}
else{
  await data.doc('$stuClass$section').set({
"name": name,
"phoneNo":phoneNo,
"email":email
});
}
 update(); // Notify GetX listeners
}

Future<void> fetchAllClassInchargeDetails(
    List<List<TextEditingController>> nameControllers,
    List<List<TextEditingController>> phoneNumberControllers,
    List<List<TextEditingController>> emailControllers,
  ) async {
    try {
      for (int classIndex = 0; classIndex < 12; classIndex++) {
        for (int sectionIndex = 0; sectionIndex < 4; sectionIndex++) {
          String className = (classIndex + 1).toString();
          String sectionName = String.fromCharCode(65 + sectionIndex); // 'A', 'B', 'C', 'D'
          String docId = '$className$sectionName'; // Example: "1A", "2B", ..., "12D"

          DocumentSnapshot snapshot = await collectionControler.loginCollection.doc('teachers').
          collection('ClassIncharger')
              .doc(docId).get();

          if (snapshot.exists) {
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

            // Set fetched values into the corresponding controllers
            nameControllers[classIndex][sectionIndex].text = data['name'] ?? '';
            phoneNumberControllers[classIndex][sectionIndex].text = data['phoneNo'] ?? '';
            emailControllers[classIndex][sectionIndex].text = data['email'] ?? '';
          }
        }
        update(); // Notify GetX listeners

      }
    } catch (e) {
      log('Error fetching class incharge details: $e');
    }
  }
}