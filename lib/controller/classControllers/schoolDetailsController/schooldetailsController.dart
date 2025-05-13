import 'dart:developer' show log;
import 'dart:io';

import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:admin_pannel/modules/schoolDetailsModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Query, QueryDocumentSnapshot;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' show UploadTask, TaskSnapshot;
import 'package:flutter/foundation.dart' show Uint8List,kIsWeb;
import 'package:get/get.dart' show Get, GetxController, Inst;

class SchooldetailsController extends GetxController{
String? email;
QueryDocumentSnapshot? lastVisibleImage;
late FirebaseCollectionVariable collectionVariable;
@override
  void onInit() {
    super.onInit();
    collectionVariable = Get.find();
    initializeEmail();
  }

void initializeEmail()=>currrentUserEmail();
  Future<void > currrentUserEmail ()async{
    String adminEmail = await collectionVariable.getCurrentUserEmail();
   email = adminEmail;
  }

Future<bool> addAndUpdateSchoolDetails({
  required String schoolName,
  required String chatbotApi,
  required String studentPassKey,
  required String teacherPassKey,
  required String higherOfficialPassKey,
  required String staffPassKey,
})async{
final dataset = collectionVariable.schoolDetails;
final docVal = await dataset.get();

try {
  if(docVal.exists)
  {
  await dataset.set({
  "schoolName": schoolName,
  'chatBotApi':chatbotApi,
  studentPasskeyField:studentPassKey,
  teacherPasskeyField:teacherPassKey,
  principalPasskeyField:higherOfficialPassKey,
  staffPassKeyField:staffPassKey,
  "admin_email":email
  });
  }
  else
  { 
    await dataset.update({
  "schoolName": schoolName,
  'chatBotApi':chatbotApi,
  studentPasskeyField:studentPassKey,
  teacherPasskeyField:teacherPassKey,
  principalPasskeyField:higherOfficialPassKey,
  staffPassKeyField:staffPassKey,
  "admin_email":email

  });
  update();
  }
  return true;
}  catch (e) {
  log("error in adding and updating the schooldetails:$e");
  return false;
}
}


Future<SchooldetailsModels>getSchoolDetails()async{

  final dataset = collectionVariable.schoolDetails;
  final docVal = await dataset.get();
  return SchooldetailsModels.fromSnapshot(docVal); 
}

Future<String>updateSchoolPhorilfePhoto()async
{
 String downloadUrl = '';
 final dataset =   collectionVariable.schoolDetails;

 
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

            final ref = collectionVariable.firebaseStorageRef.child("SchoolDetails/ProfilePhoto");

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
            await dataset.update({
              "schoolPhotoUrl"  : downloadUrl,
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


Future<String?> getSchoolPhotoUrl( ) async {
  try {
    final ref = collectionVariable.firebaseStorageRef.child("SchoolDetails/ProfilePhoto");
    final doc = await ref.getDownloadURL();
        update(); // Notify GetX listeners

    return doc;
  } catch (e) {
    log(
      'error in getting the downloads url $e'); 
    return null; 
  }
}

Future<bool> deleteSchoolPhoto() async {
  try {
    final schoolPhotoRef = collectionVariable.firebaseStorageRef.child("SchoolDetails/ProfilePhoto");
    await schoolPhotoRef.delete(); // Attempt to delete the file
    update(); // Notify GetX listeners if necessary
    return true;
  } catch (e) {
    log("Error deleting school photo: $e");
    return false;
  }
}
Future<void> uploadImageGallery({required dynamic image}) async {
  try {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    dynamic ref = collectionVariable.firebaseStorageRef.child('gallery').child(fileName);

    UploadTask uploadTask;
    
    if (image is Uint8List) {
      // Web: Upload bytes
      uploadTask = ref.putData(image);
    } else if (image is File) {
      // Mobile: Upload file
      uploadTask = ref.putFile(image);
    } else {
      throw Exception("Unsupported image type");
    }

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    await collectionVariable.galleryCollection.add({'url': downloadUrl});
    update();
  } catch (e) {
    log('Error uploading image: $e');
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
        update(); // Notify GetX listeners

}  

Future<void> deleteImageFromGallery({

  required String imageUrl,
}) async {
  try {
    await deleteById(imageUrl);
    // Corrected `refFromURL` usage
    dynamic ref = collectionVariable.firebaseStorageInstance.refFromURL(imageUrl);
    await ref.delete();
  } catch (e) {
    log('Error deleting image: $e');
  }
}


Future<List<String>> getGalleryImages({bool isInitial = false}) async {
  List<String> imageUrls = [];
  try {
    Query query = collectionVariable.galleryCollection.limit(4);

    if (!isInitial && lastVisibleImage != null) {
      query = query.startAfterDocument(lastVisibleImage!);
    }

    final querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      lastVisibleImage = querySnapshot.docs.last;
      for (var doc in querySnapshot.docs) {
        imageUrls.add(doc['url']);
      }
    }
  } catch (e) {
    log('Error fetching images: $e');
  }
  return imageUrls;
}


Future<String?> deleteById(String imageUrl) async {
  try {
    final querySnapshot = await collectionVariable.galleryCollection
        .where('url', isEqualTo: imageUrl)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String docId = querySnapshot.docs.first.id;

      await collectionVariable.galleryCollection.doc(docId).delete();

      return docId; // Return the deleted document ID
    } else {
      return ""; // Return null if no matching document is found
    }
  } catch (e) {
    log("Error deleting image: $e");
    return ""; // Return null on error
  }
}

 
}