import 'dart:developer'show log;
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:admin_pannel/FireBaseServices/FirebaseAuth.dart';
import 'package:admin_pannel/modules/studentModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; 
class StudentController extends GetxController {
  FirebaseAuthUser authControlelr = FirebaseAuthUser();
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
      'rollNumber': doc.data()?['Roll.no'] ?? '',
      'name': doc[studentNamefield] ?? '',
      'id': doc[stdentIdField] ?? '',
      'class': doc[classField] ?? '',
      'section': doc[sectionFild] ?? '',
      'parentMobile': doc[motherPhoneNoField] ?? '',
    };
  }).toList().cast<Map<String, dynamic>>(); 
}   catch (e) {
  log(e.toString());
}
  }

Future<StudentdetailsModel?> studentDataRead({required String uid}) async {
  try {
   final  doc = await collectionControler.studentLoginCollection.doc(uid).get();
   final  castedDoc = doc as DocumentSnapshot<Map<String, dynamic>>;
    return StudentdetailsModel.fromSnapshot(castedDoc);
  } catch (e) {
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
}) async {
  try {
    final docRef = collectionControler.studentLoginCollection.doc(uid);

    await docRef.update({
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


Future<String> updateStudentPhoto(String studentId, String profilePhotoUrl) async {
    String downloadUrl='';
    
  final docRef = collectionControler.studentLoginCollection.doc(studentId);

  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Allows only images
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
   profilePhotfield: profilePhotoUrl,
         });

      log("Updated photo URL: $downloadUrl");
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
    log(e.toString()); 
    return null; 
  }
}

Future<void> registerUser({
  required TextEditingController emailController,
  required TextEditingController passwordController,
  required TextEditingController nameController,
  required TextEditingController phoneController,
  required TextEditingController addressController,
  required TextEditingController fatherNameController,
  required TextEditingController fatherPhoneController,
  required TextEditingController motherNameController,
  required TextEditingController motherPhoneController,
  required BuildContext context,
}) async {
  try {
    // Create user in Firebase Authentication
   final user = await authControlelr.createUser(email: emailController.text, password: passwordController.text, context: context);
    String userId = user!.id;
    await collectionControler.studentLoginCollection.doc(userId).set({
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
      'fatherName': fatherNameController.text.trim(),
      'fatherPhone': fatherPhoneController.text.trim(),
      'motherName': motherNameController.text.trim(),
      'motherPhone': motherPhoneController.text.trim(),
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration Successful')),
    );
  } catch (e) {
    // Handle errors (e.g., weak password, email already in use, network issues)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}


}
