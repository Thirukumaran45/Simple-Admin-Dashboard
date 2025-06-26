import 'dart:developer'show log;
import 'package:admin_pannel/utils/AppException.dart';

import '../../../services/FireBaseServices/CollectionVariable.dart';
import '../../../modules/staffModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot, FieldValue, Query;

import 'package:get/get.dart' ;
import '../../../contant/ConstantVariable.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' show UploadTask, TaskSnapshot;
import 'package:flutter/foundation.dart' show Uint8List,kIsWeb;



class StaffController extends GetxController{
   late FirebaseCollectionVariable collectionControler;
late dynamic snapshot;
 var _context;
final int _limit = 15;
DocumentSnapshot? _lastDocument;
bool _isFetchingMore = false;
 final RxList<Map<String, dynamic>> staffData = <Map<String, dynamic>>[].obs;


  @override
  void onInit() {
    super.onInit();
    collectionControler = Get.find<FirebaseCollectionVariable>();
    fetchStaffData(_context);
  }


void fetchStaffData(dynamic context,) async {
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
    throw CloudDataReadException("Error in loading staff details, please try again later !");
  } finally {
    _isFetchingMore = false;
  }
}

Future<Stafffdetailsmodel?> staffDataRead(dynamic context,{required String uid}) async {
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
    throw CloudDataReadException("Error in fetching staff details, please try again later !");

  }
}

Future<bool> updateStaffDetails(dynamic context,{
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
      "isInRemainderChat":false,
         "isSchoolChat":false,
      staffroleField :staffrole
    });
       fetchStaffData(_context);
        update();  // Notify GetX listeners

    log("Staffs details updated successfully.");
    return true; // Return success
  } catch (e) {
    log("Error updating Staffs details: $e");
    throw CloudDataUpdateException("Error in updating staff details, please try again later !");
  }
}


Future<String> updateStaffsPhoto(dynamic context,String staffId,) async {
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
         throw CloudDataUpdateException("Error in updating staff photo, please try again later !");


    }
        update(); // Notify GetX listeners

    return downloadUrl;
}


Future<String?> getStaffsPhotoUrl(dynamic context,String staffsId) async {
  try {
    final ref =collectionControler.firebaseStorageRef.child("Staff Photo/$staffsId");
    final doc = await ref.getDownloadURL();
        update(); // Notify GetX listeners

    return doc;
  } catch (e) {
    log(
      'error in getting the downloads url $e'); 
    throw CloudDataReadException("Error in fetching staff photo, please try again later !");

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
  required dynamic context,
}) async {
  try {
  
  
    await collectionControler.staffLoginCollection.doc(userId).set({
      staffNamefield:staffName,
      staffEmailfield:staffEmail,
      staffPhoneNumberfield :staffPhoneNumber,
      staffAddressfield: staffAddress,
      staffProfilefield :staffAddress,
      stafflId :userId,
      "isInRemainderChat":false,
         "isSchoolChat":false,
      staffroleField :staffrole
    });
         fetchStaffData(_context);
        update(); // Notify GetX listeners

  } catch (e) {
    log(e.toString());
    throw CloudDataWriteException("Error in adding staff details, please try again later !");
 
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
    throw CloudDataWriteException("Error in adding staff , please try again later !");

  }
}  

Future<String> photoStorage(dynamic context,{required String userId, required dynamic image}) async {
  String downloadUrl = '';

  try {
  final ref = collectionControler.firebaseStorageRef.child("Staff Photo/$userId");
  
  UploadTask uploadTask;
  
  if (kIsWeb && image is Uint8List) {
    // Web: Use putData for Uint8List
    uploadTask = ref.putData(image);
  } else if (image is File) {
    // Mobile: Use putFile for File
    uploadTask = ref.putFile(image);
  } else {
       throw CloudDataReadException("Error in fetching staff photo, please try again later !");

  }
  
  // Wait for upload to complete
  TaskSnapshot snapshot = await uploadTask;
  
  // Get download URL
  downloadUrl = await snapshot.ref.getDownloadURL();
        update(); // Notify GetX listeners
  
  return downloadUrl;
}  catch (e) {
    throw CloudDataReadException("Error in fetching staff photo, please try again later !");
  
}
}

Future<void> updateNumberOfStaffs(dynamic context,bool isIncrement) async {
  
try {
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
          update(); 
}  catch (e) {
    throw CloudDataUpdateException("Error in updating  number of staff details, please try again later !");
}
// Notify GetX listeners

}



Future<bool> deleteStaffs(dynamic context,{
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
  
   await updateNumberOfStaffs(_context,false); 
    // Remove the deleted staff from the observable list
    staffData.removeWhere((staff) => staff['id'] == staffId);
        update(); // Notify GetX listeners
  
  log("deleted the Staffs data");
  return true;
}  catch (e) {
  log("error in deleting :$e");
    throw CloudDataDeleteException("Error in deleting staff details, please try again later !");

}

}
}