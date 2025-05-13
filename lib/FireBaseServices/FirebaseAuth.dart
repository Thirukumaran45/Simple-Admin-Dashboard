import 'dart:developer' show log;

import 'package:admin_pannel/FireBaseServices/AuthUserModule.dart';
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:admin_pannel/views/widget/CustomDialogBox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show  GetxController, Get,Inst;
class FirebaseAuthUser extends GetxController{
  
  FirebaseCollectionVariable collectioncontrolelr = Get.find();
  

  Future<Authuser?> signinUser({required String email, required String password, required BuildContext context}) async {
  try {
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
   await checkBackendEmail(email);  
    return Authuser(id: userCredential.user!.uid, email: userCredential.user!.email!);
  }  catch (e) {
    await showCustomDialog(context, "Oops ! something wrong please enter valid credentials ");
    return null; // Return null if authentication fails
  }
}


  Future<bool> checkBackendEmail(String email) async {
  try {
   final docSnapshot = await collectioncontrolelr.schoolDetails.get();
if (docSnapshot.exists) {
  String adminEmail = docSnapshot.get('admin_email');
  return adminEmail == email;
}

  } catch (e) {
    log("Error checking backend email: $e");
  }
  
  return false; // Return false if not found or an error occurs
}


Future<Authuser?> createUser({required String email, required String password, required BuildContext context})async
{
  try{
 final  userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return Authuser(id: userCredential.user!.uid, email: userCredential.user!.email!);

  }
  on FirebaseAuthException catch(e){
   log("Firebase Auth Error: ${e.code}");
    showCustomDialog(context, "Error ${e.code}");
    return null; // Return null if authentication fails
  
}
}
  Future<void> signOutAccount() async {
    await FirebaseAuth.instance.signOut();

   
  }
  Future<String>getCurrentUserEmail()async{
    final String currentUserEmail =  FirebaseAuth.instance.currentUser!.email!;
  return currentUserEmail;
  }
}