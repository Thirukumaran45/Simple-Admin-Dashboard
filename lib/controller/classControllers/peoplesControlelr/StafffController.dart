import 'dart:developer'show log;
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:admin_pannel/contant/constant.dart';
import 'package:admin_pannel/modules/staffModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, FieldValue, Query;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' show UploadTask, TaskSnapshot;
import 'package:flutter/foundation.dart' show Uint8List,kIsWeb;



class StaffController extends GetxController{
   late FirebaseCollectionVariable collectionControler;
late dynamic snapshot;
 
 final RxList<Map<String, dynamic>> staffData = <Map<String, dynamic>>[].obs;


  @override
  void onInit() {
    super.onInit();
    collectionControler = Get.find<FirebaseCollectionVariable>();
    fetchStaffData();
  }

final int _limit = 15;
DocumentSnapshot? _lastDocument;
bool _isFetchingMore = false;

void fetchStaffData() async {
  if (_isFetchingMore) return;

  _isFetchingMore = true;
  try {
    Query query = collectionControler.staffLoginCollection.limit(_limit);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;

      final newEntries = snapshot.docs.asMap().entries.map((entry) {
        int index = staffData.length + entry.key + 1;
        var doc = entry.value;
          return {
        'sNo': index.toString(),
        'name': doc[staffNamefield] ?? '',
        'id': doc[stafflId] ?? '',
        'phone': doc[staffPhoneNumberfield] ?? '',
        'email': doc[staffEmailfield] ?? '',
        'address': doc[staffAddressfield] ?? '',
      };
      }).toList();

      staffData.addAll(newEntries);
      update();
    }
  } catch (e) {
    log('Error while fetching more officials: $e');
  } finally {
    _isFetchingMore = false;
  }
}

// void fetchStaffData() async {
//   try {
//     snapshot = await collectionControler.staffLoginCollection.get();
//     staffData.value = snapshot.docs.asMap().entries.map((entry) {
//       int index = entry.key + 1; // Auto-generate serial number starting from 1
//       var doc = entry.value;

//       return {
//         'sNo': index.toString(),
//         'name': doc[staffNamefield] ?? '',
//         'id': doc[stafflId] ?? '',
//         'phone': doc[staffPhoneNumberfield] ?? '',
//         'email': doc[staffEmailfield] ?? '',
//         'address': doc[staffAddressfield] ?? '',
//       };
//     }).toList().cast<Map<String, dynamic>>(); 
//         update(); // Notify GetX listeners

//   } catch (e) { 
//     log('Error in fetching the data: $e');
//   }
// }
 

Future<Stafffdetailsmodel?> staffDataRead({required String uid}) async {
  try {
    final doc = await collectionControler.staffLoginCollection.doc(uid).get();
    
    if (!doc.exists) {
      log("Document does not exist");
      return null;
    }

    final castedDoc = doc as DocumentSnapshot<Map<String, dynamic>>;
        update(); // Notify GetX listeners
    
    return Stafffdetailsmodel.fromSnapshot(castedDoc);
  }  catch (e) {
    log('Error fetching staff data: $e');
    return null;
  }
}

Future<bool> updateStaffDetails({
required String  staffName ,
required String  staffEmail ,
required String  staffPhoneNumber,
required String  staffAddress,
required String  staffProfile ,
required String  userId ,
required String  staffrole,
}) async {
  try {
    final docRef = collectionControler.staffLoginCollection.doc(userId);
    await docRef.update({
      staffNamefield:staffName,
      staffEmailfield:staffEmail,
      staffPhoneNumberfield :staffPhoneNumber,
      staffAddressfield: staffAddress,
      staffProfilefield :staffAddress,
      stafflId :userId,
      staffroleField :staffrole
    });
       fetchStaffData();
        update();  // Notify GetX listeners

    log("Staffs details updated successfully.");
    return true; // Return success
  } catch (e) {
    log("Error updating Staffs details: $e");
    return false; // Return failure
  }
}


Future<String> updateStaffsPhoto(String staffId,) async {
    String downloadUrl = '';
    final docRef = collectionControler.staffLoginCollection.doc(staffId);

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

            final ref = collectionControler.firebaseStorageRef.child("Staff Photo/$staffId");

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
        log("Error updating Staffs photo: $e");
    }
        update(); // Notify GetX listeners

    return downloadUrl;
}


Future<String?> getStaffsPhotoUrl(String staffsId) async {
  try {
    final ref =collectionControler.firebaseStorageRef.child("Staff Photo/$staffsId");
    final doc = await ref.getDownloadURL();
        update(); // Notify GetX listeners

    return doc;
  } catch (e) {
    log(
      'error in getting the downloads url $e'); 
    return null; 
  }
}

Future<void> registerStaffs({
required String  staffName ,
required String  staffEmail ,
required String  staffPhoneNumber,
required String  staffAddress,
required String  staffProfile ,
required String  userId ,
required String  staffrole,
  required BuildContext context,
}) async {
  try {
  
  
    await collectionControler.staffLoginCollection.doc(userId).set({
      staffNamefield:staffName,
      staffEmailfield:staffEmail,
      staffPhoneNumberfield :staffPhoneNumber,
      staffAddressfield: staffAddress,
      staffProfilefield :staffAddress,
      stafflId :userId,
      staffroleField :staffrole
    });

      await customSnackbar(context: context, text: "Registration succesfull");
         fetchStaffData();
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

  final ref = collectionControler.firebaseStorageRef.child("Staff Photo/$userId");

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

Future<void> updateNumberOfStaffs(bool isIncrement) async {
  
final dataDoc = collectionControler.loginCollection.doc('staffs');
final val = await dataDoc.get();

if(val.exists)
{
 await collectionControler.loginCollection.doc('staffs').update({
    'numberOfPeople': FieldValue.increment(isIncrement ? 1 : -1),
  });
}
else
{
   await collectionControler.loginCollection.doc('staffs').set({
    'numberOfPeople': 1,
  });

}
        update(); // Notify GetX listeners

}



Future<bool> deleteStaffs({
  required String staffId,
}) async {
  try {
  final staffDoc = await collectionControler.staffLoginCollection.doc(staffId).get();
  if (staffDoc.exists) {
    await collectionControler.staffLoginCollection.doc(staffId).delete();
  }
  
  // Check if student photo exists in Storage before deleting
  final staffsPhotoRef = collectionControler.firebaseStorageRef.child("Staff Photo/$staffId");
  if ((await staffsPhotoRef.listAll()).items.isNotEmpty) {
    await staffsPhotoRef.delete();
  }
  
  // Check if AnnouncementChatPost exists before deleting
  final announcementRef = collectionControler.firebaseStorageRef.child("AnnouncementChatPost/$staffId");
  if ((await announcementRef.listAll()).items.isNotEmpty) {
    await announcementRef.delete();
  }
  
   await updateNumberOfStaffs(false);
    // Remove the deleted staff from the observable list
    staffData.removeWhere((staff) => staff['id'] == staffId);
        update(); // Notify GetX listeners
  
  log("deleted the Staffs data");
  return true;
}  catch (e) {
  log("error in deleting :$e");
  return false;
}

}
}