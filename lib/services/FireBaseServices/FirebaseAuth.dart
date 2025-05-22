import 'dart:developer' show log;
import 'package:admin_pannel/services/FirebaseException/pageException.dart';
import 'AuthUserModule.dart';
import 'CollectionVariable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show  GetxController, Get,Inst;
class FirebaseAuthUser extends GetxController{
  
  FirebaseCollectionVariable collectioncontrolelr = Get.find<FirebaseCollectionVariable>();

  

  Future<Authuser?> signinUser({required String email, required String password, required BuildContext context}) async {
  try {
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    
   await checkBackendEmail(email);  
    return Authuser(id: userCredential.user!.uid, email: userCredential.user!.email!);
  }  
   on FirebaseAuthException catch (e) {
  throw ServerException('Error ${e.toString()}');
}catch (e) {
   throw ServerException('Error in sign in user, please try again later !');
  }
}


  Future<bool> checkBackendEmail(String email) async {
  try {
   final docSnapshot = await collectioncontrolelr.schoolDetails.get();
if (docSnapshot.exists) {
  String adminEmail = docSnapshot.get('admin_email');
  return adminEmail == email;
}

  } 
  
catch (e) {
    log("Error checking backend email: $e");
    throw ServerException('Error in checking existing user, please try again !');
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
  throw ServerException('Error ${e.code} !');
   
}
 catch (e) {
  throw ServerException('Error in creating people\'s, please try again later !');
}
}
  Future<void> signOutAccount() async {
    try {
  await FirebaseAuth.instance.signOut();
} on FirebaseAuthException catch (e) {
  throw ServerException('Error ${e.code} !');
}  catch (e) {
  throw ServerException('Error in sign out, please try again later !');
}

   
  }
  Future<String>getCurrentUserEmail()async{
    try {
  final String currentUserEmail =  FirebaseAuth.instance.currentUser!.email!;
    return currentUserEmail;
}  catch (e) {
      throw CloudDataReadException('Error no user is found, please login again !');

}
  }
}