import 'dart:developer' show log;
import 'package:admin_pannel/services/FireBaseServices/FirebaseAuth.dart';
import 'package:admin_pannel/utils/AppException.dart';
import '../../../services/FireBaseServices/CollectionVariable.dart';
import '../../../modules/higherOfficialModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, FieldValue, Query;

import 'package:get/get.dart';
import '../../../contant/ConstantVariable.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'
    show UploadTask, TaskSnapshot;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;

class Higherofficialcontroller extends GetxController {
  final RxList<Map<String, dynamic>> officialData =
      <Map<String, dynamic>>[].obs;
  late FirebaseCollectionVariable collectionControler;
  final int _limit = 15;
  late FirebaseAuthUser authControlelr ;
  DocumentSnapshot? _lastDocument;
  bool _isFetchingMore = false;
 var _context;
  @override
  void onInit() {
    super.onInit();
    collectionControler = Get.find<FirebaseCollectionVariable>();
   authControlelr = Get.find<FirebaseAuthUser>();
    fetchMoreOfficials(_context);
  }
 
  void fetchMoreOfficials(dynamic context,) async {
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
         var docSnapshot = entry.value;
         var doc = docSnapshot.data() as Map<String, dynamic>? ?? {};
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
      throw CloudDataReadException(
          "Error in loading Higher Official details, please try again later !");
    } finally {
      _isFetchingMore = false;
    }
  }

  Future<Principaldetailmodel?> officialDataRead(dynamic context,{required String uid}) async {
    try {
      final doc =
          await collectionControler.officialLoginCollection.doc(uid).get();

      if (!doc.exists) {
        log("Document does not exist");
        return null;
      }

      final castedDoc = doc as DocumentSnapshot<Map<String, dynamic>>;
      update(); // Notify GetX listeners

      return Principaldetailmodel.fromSnapshot(castedDoc);
    } catch (e) {
      throw CloudDataReadException(
          "Error in getting Higher Official details, please try again later !");
    }
  }

  Future<bool> updateOfficialDetails(dynamic context,{
    required String principalName,
    required String principalEmail,
    required String principalPhoneNumber,
    required String principalAddress,
    required String principalProfile,
    required String userId,
    required String principalRole,
  }) async {
    try {
      final docRef = collectionControler.officialLoginCollection.doc(userId);
      await docRef.update({
        principalNamefield: principalName,
        principalEmailfield: principalEmail,
        principalPhoneNumberfield: principalPhoneNumber,
        principalAddressfield: principalAddress,
        principalProfilefield: principalProfile,
        principalId: userId,
        "isInRemainderChat":false,
         "isSchoolChat":false,
        principalRoleField: principalRole,
      });
      fetchMoreOfficials(_context);
      update();
      log("Officials details updated successfully.");
      return true; // Return success
    } catch (e) {
      throw CloudDataWriteException(
          "Error in updating Higher Official details, please try again later !");
    }
  }

  Future<String> updateOfficialsPhoto(dynamic context,
    String officialId,
  ) async {
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

        final ref = collectionControler.firebaseStorageRef
            .child("Higher Official Photo/$officialId");

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
      throw CloudDataUpdateException(
          "Error in updating Higher Official photo, please try again later !");
    }
    update(); // Notify GetX listeners

    return downloadUrl;
  }

  Future<String?> getOfficialsPhotoUrl(dynamic context,String officialsId) async {
    try {
      final ref = collectionControler.firebaseStorageRef
          .child("Higher Official Photo/$officialsId");
      final doc = await ref.getDownloadURL();
      update(); // Notify GetX listeners

      return doc;
    } catch (e) {
      throw CloudDataReadException(
          "Error in getting Higher Official photo, please try again later !");
    }
  }

  Future<void> registerOfficials({
    required String principalName,
    required String principalEmail,
    required String principalPhoneNumber,
    required String principalAddress,
    required password,updatePhotoUrl,
    required String principalRole,
    required dynamic context,
  }) async {
    try {
       final user=  await authControlelr.createUser(email: principalEmail,
       password: password, context: context);
  String userId = user!.id;
  final url =   await photoStorage(context,image: updatePhotoUrl,userId: userId);
  
      await collectionControler.officialLoginCollection.doc(userId).set({
        principalNamefield: principalName,
        principalEmailfield: principalEmail,
        principalPhoneNumberfield: principalPhoneNumber,
        principalAddressfield: principalAddress,
        principalProfilefield: url,
        principalId: userId,
        "isInRemainderChat":false,
         "isSchoolChat":false,
        principalRoleField: principalRole,
      });
      fetchMoreOfficials(context);
      update(); // Notify GetX listeners
    } catch (e) {
      throw CloudDataWriteException(
          "Error in adding Higher Official details, please try again later !");
    }
    update(); // Notify GetX listeners
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
    } catch (e) {
    throw CloudDataWriteException("Error in adding Higher Official photo, please try again later !");

    }
    update(); // Notify GetX listeners
  }

  Future<String> photoStorage(dynamic context,
      {required String userId, required dynamic image}) async {
    String downloadUrl = '';

    try {
  final ref = collectionControler.firebaseStorageRef
      .child("Higher Official Photo/$userId");
  
  UploadTask uploadTask;
  
  if (kIsWeb && image is Uint8List) {
    // Web: Use putData for Uint8List
    uploadTask = ref.putData(image);
  } else if (image is File) {
    // Mobile: Use putFile for File
    uploadTask = ref.putFile(image);
  } else{
    throw CloudDataWriteException("Error in adding Higher Official photo, please try again later !");
    
  }
  
  // Wait for upload to complete
  TaskSnapshot snapshot = await uploadTask;
  
  // Get download URL
  downloadUrl = await snapshot.ref.getDownloadURL();
  update(); // Notify GetX listeners
  
  return downloadUrl;
}  catch (e) {
    throw CloudDataWriteException("Error in adding Higher Official photo, please try again later !");
  
}
  }

  Future<void> updateNumberOfOfficials(dynamic context,bool isIncrement) async {
    try {
  final dataDoc = collectionControler.loginCollection.doc('officials');
  final val = await dataDoc.get();
  
  if (val.exists) {
    await collectionControler.loginCollection.doc('officials').update({
      'numberOfPeople': FieldValue.increment(isIncrement ? 1 : -1),
    });
  } else {
    await collectionControler.loginCollection.doc('officials').set({
      'numberOfPeople': 1,
    });
  }
  update(); 
}  catch (e) {
   throw CloudDataWriteException("Error in updating number of Higher Official, please try again later !");

}

  }

  Future<bool> deleteOfficials(dynamic context,{
    required String officialId,
  }) async {
    try {
      final officialDoc = await collectionControler.officialLoginCollection
          .doc(officialId)
          .get();
      if (officialDoc.exists) {
        await collectionControler.officialLoginCollection
            .doc(officialId)
            .delete();
      }

      // Check if student photo exists in Storage before deleting
      final officialsPhotoRef = collectionControler.firebaseStorageRef
          .child("Higher Official Photo/$officialId");
      if ((await officialsPhotoRef.listAll()).items.isNotEmpty) {
        await officialsPhotoRef.delete();
      }

      // Check if AnnouncementChatPost exists before deleting
      final announcementRef = collectionControler.firebaseStorageRef
          .child("AnnouncementChatPost/$officialId");
      if ((await announcementRef.listAll()).items.isNotEmpty) {
        await announcementRef.delete();
      }

      // Iterate through all class and section combinations
      for (int classNum = 1; classNum <= 12; classNum++) {
        for (String section in ['A', 'B', 'C', 'D']) {
          final remainderRef = collectionControler.firebaseStorageRef
              .child("RemainderChatPost/$classNum/$section/$officialId");

          if ((await remainderRef.listAll()).items.isNotEmpty) {
            await remainderRef.delete();
          }
        }
      }
      await updateNumberOfOfficials(_context,false); 
      officialData.removeWhere((staff) => staff['id'] == officialId);
      return true;
    } catch (e) {
    throw CloudDataDeleteException("Error in deleting Higher Official details, please try again later !");
    }
  }
}
