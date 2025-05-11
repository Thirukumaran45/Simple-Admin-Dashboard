import 'dart:developer'show log;
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:admin_pannel/contant/constant.dart';
import 'package:admin_pannel/modules/higherOfficialModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, FieldValue, Query;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' show UploadTask, TaskSnapshot;
import 'package:flutter/foundation.dart' show Uint8List,kIsWeb;


class Higherofficialcontroller extends GetxController {
final RxList<Map<String, dynamic>> officialData = <Map<String, dynamic>>[].obs;
late FirebaseCollectionVariable collectionControler;
DocumentSnapshot? lastDocument;  // NEW: Track last document
bool isFetching = false; // NEW: Prevent multiple fetches
final int pageSize = 10; // NEW: Load 10 at a time

@override
void onInit() {
  super.onInit();
  collectionControler = Get.find<FirebaseCollectionVariable>();
  fetchMoreOfficials();
}
int _limit = 10;
DocumentSnapshot? _lastDocument;
bool _isFetchingMore = false;

void fetchMoreOfficials() async {
  if (_isFetchingMore) return;

  _isFetchingMore = true;
  try {
    Query query = collectionControler.officialLoginCollection.limit(_limit);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;

      final newEntries = snapshot.docs.asMap().entries.map((entry) {
        int index = officialData.length + entry.key + 1;
        var doc = entry.value;
        return {
          'sNo': index.toString(),
          'name': doc[principalNamefield] ?? '',
          'id': doc[principalId] ?? '',
          'role': doc[principalRoleField] ?? '',
          'email': doc[principalEmailfield] ?? '',
          'phone': doc[principalPhoneNumberfield] ?? '',
        };
      }).toList();

      officialData.addAll(newEntries);
      update();
    }
  } catch (e) {
    log('Error while fetching more officials: $e');
  } finally {
    _isFetchingMore = false;
  }
}

Future<Principaldetailmodel?> officialDataRead({required String uid}) async {
  try {
    final doc = await collectionControler.officialLoginCollection.doc(uid).get();
    
    if (!doc.exists) {
      log("Document does not exist");
      return null;
    }

    final castedDoc = doc as DocumentSnapshot<Map<String, dynamic>>;
        update(); // Notify GetX listeners
    
    return Principaldetailmodel.fromSnapshot(castedDoc);
  }  catch (e) {
    log('Error fetching higher official data: $e');
    return null;
  }
}

Future<bool> updateOfficialDetails({
required  String  principalName ,
required  String  principalEmail ,
required  String  principalPhoneNumber ,
required  String  principalAddress ,
required  String  principalProfile ,
required  String  userId,
required  String  principalRole ,
}) async {
  try {
    final docRef = collectionControler.officialLoginCollection.doc(userId);
    await docRef.update({
     principalNamefield : principalName,
     principalEmailfield : principalEmail,
     principalPhoneNumberfield : principalPhoneNumber,
     principalAddressfield : principalAddress,
     principalProfilefield : principalProfile,
     principalId : userId,
     principalRoleField : principalRole,
    });
       fetchMoreOfficials();
        update(); 

    log("Officials details updated successfully.");
    return true; // Return success
  } catch (e) {
    log("Error updating Officials details: $e");
    return false; // Return failure
  }
}


Future<String> updateOfficialsPhoto(String officialId,) async {
    String downloadUrl = '';
    final docRef = collectionControler.officialLoginCollection.doc(officialId);

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

            final ref = collectionControler.firebaseStorageRef.child("Higher Official Photo/$officialId");

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
        log("Error updating officials photo: $e");
    }
        update(); // Notify GetX listeners

    return downloadUrl;
}


Future<String?> getOfficialsPhotoUrl(String officialsId) async {
  try {
    final ref =collectionControler.firebaseStorageRef.child("Higher Official Photo/$officialsId");
    final doc = await ref.getDownloadURL();
        update(); // Notify GetX listeners

    return doc;
  } catch (e) {
    log(
      'error in getting the downloads url $e'); 
    return null; 
  }
}

Future<void> registerOfficials({
required  String  principalName ,
required  String  principalEmail ,
required  String  principalPhoneNumber ,
required  String  principalAddress ,
required  String  principalProfile ,
required  String  userId,
required  String  principalRole ,
  required BuildContext context,
}) async {
  try {
  
  
    await collectionControler.officialLoginCollection.doc(userId).set({
          principalNamefield : principalName,
     principalEmailfield : principalEmail,
     principalPhoneNumberfield : principalPhoneNumber,
     principalAddressfield : principalAddress,
     principalProfilefield : principalProfile,
     principalId : userId,
     principalRoleField : principalRole,
    });

      await customSnackbar(context: context, text: "Registration succesfull");
      fetchMoreOfficials();
        update(); // Notify GetX listeners


  } catch (e) {
    log(e.toString());
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
  } catch (e) {
    log(e.toString());
  }
        update(); // Notify GetX listeners

}  

Future<String> photoStorage({required String userId, required dynamic image}) async {
  String downloadUrl = '';

  final ref = collectionControler.firebaseStorageRef.child("Higher Official Photo/$userId");

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

Future<void> updateNumberOfOfficials(bool isIncrement) async {

final dataDoc = collectionControler.loginCollection.doc('officials');
final val = await dataDoc.get();

if(val.exists)
{
 await collectionControler.loginCollection.doc('officials').update({
    'numberOfPeople': FieldValue.increment(isIncrement ? 1 : -1),
  });
}
else
{
   await collectionControler.loginCollection.doc('officials').set({
    'numberOfPeople': 1,
  });
}
        update(); // Notify GetX listeners

}



Future<bool> deleteOfficials({
  required String officialId,
}) async {
  try {
  final officialDoc = await collectionControler.officialLoginCollection.doc(officialId).get();
  if (officialDoc.exists) {
    await collectionControler.officialLoginCollection.doc(officialId).delete();
  }
  
  // Check if student photo exists in Storage before deleting
  final OfficialsPhotoRef = collectionControler.firebaseStorageRef.child("Higher Official Photo/$officialId");
  if ((await OfficialsPhotoRef.listAll()).items.isNotEmpty) {
    await OfficialsPhotoRef.delete();
  }
  
  // Check if AnnouncementChatPost exists before deleting
  final announcementRef = collectionControler.firebaseStorageRef.child("AnnouncementChatPost/$officialId");
  if ((await announcementRef.listAll()).items.isNotEmpty) {
    await announcementRef.delete();
  }
  
   // Iterate through all class and section combinations
  for (int classNum = 1; classNum <= 12; classNum++) {
  for (String section in ['A', 'B', 'C', 'D']) {
    final remainderRef = collectionControler.firebaseStorageRef.child("RemainderChatPost/$classNum/$section/$officialId");
    
    if ((await remainderRef.listAll()).items.isNotEmpty) {
      await remainderRef.delete();
    }
  }
  }
  await updateNumberOfOfficials(false);
    officialData .removeWhere((staff) => staff['id'] == officialId);

        update(); // Notify GetX listeners
  
  log("deleted the officials data");
  return true;
}  catch (e) {
  log("error in deleting :$e");
  return false;
}

}
}