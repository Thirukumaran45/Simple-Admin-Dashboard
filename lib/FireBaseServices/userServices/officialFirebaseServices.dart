// import 'package:admin_pannel/contant/CustomNavigation.dart' show customPopNavigation;
// import 'package:admin_pannel/controller/HigherOfficialController.dart';
// import 'package:admin_pannel/views/widget/CustomDialogBox.dart' show showCustomConfirmDialog, showCustomDialog;
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';


// class Officialfirebaseservices {

// List<Map<String, dynamic>> filteredData = [];
// final Higherofficialcontroller controller = Get.find();

// //Adding user

// Future<dynamic> addOffcialPhoto()async{
//   await controller. addPhoto();
// } 

// Future<String> officialPhtotoStorage({required dynamic updatePhotoUrl,required String userId })async{
//   final String url =await controller.photoStorage(image: updatePhotoUrl,userId: userId);
//   return url;
// }
// Future<void> registerOfficial({
//   required String userId,
//   required String addresscontrl,
//   required String emailController,
//   required String name,
//   required String officialMobileController,
//   required String url,
//   required BuildContext context,
// }) async {
//   await controller.registerOfficials(
//     userId: userId,
//     context: context,
//     principalAddress: addresscontrl,
//     principalEmail: emailController,
//     principalName: name.toUpperCase(),
//     principalPhoneNumber: officialMobileController,
//     principalProfile: url,
//     principalRole: "Higher Official",
//   );

//   if (!context.mounted) return; // Ensure widget is still mounted

//   await controller.updateNumberOfOfficials(true);

//   if (!context.mounted) return; // Ensure widget is still mounted before showing dialog

//   bool val = await showCustomConfirmDialog(
//     context: context, 
//     text: 'Higher official registered Successfully',
//   );

//   if (!context.mounted) return; // Ensure widget is still mounted before navigation

//   if (val) {
//     customPopNavigation(context, '/manage-higher-official');
//   } else {
//     await showCustomDialog(
//       context, 
//       "Higher official Profile picture is not uploaded!",
//     );
//   }
// }

// // official Details
//     filteredData = List.from(controller.officialData);



// } 