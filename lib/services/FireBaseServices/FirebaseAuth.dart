import 'dart:io' show SocketException;
import 'package:admin_pannel/utils/AppException.dart';
import 'AuthUserModule.dart';
import 'CollectionVariable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show  GetxController, Get,Inst;
class FirebaseAuthUser extends GetxController{
  
  FirebaseCollectionVariable collectioncontrolelr = Get.find<FirebaseCollectionVariable>();

  

 Future<Authuser?> signinUser({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final isValidAdmin = await checkBackendEmail(email);

    if (!isValidAdmin) {
      throw ServerException('Unauthorized email, Please contact the administrator !');
    }

    return Authuser(
      id: userCredential.user!.uid,
      email: userCredential.user!.email!,
    );
  } on SocketException {
    throw ServerException("No Internet Connection. Please check your network.");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      throw ServerException("No user found for this email.");
    } else if (e.code == 'wrong-password') {
      throw ServerException("Incorrect password.");
    } else if (e.code == 'invalid-email') {
      throw ServerException("The email address is invalid.");
    } else if (e.code == 'user-disabled') {
      throw ServerException("This user account has been disabled.");
    }else if (e.code == 'invalid-credential') {
      throw ServerException("Wrong email and password, check them and try again !.");
    } 
    else {
      throw ServerException("Sign-in failed. Please try again.");
    }
  } catch (e) {
    throw ServerException("An unexpected error occurred while sign in, please try again later !");
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
 on SocketException {
    throw ServerException("No Internet Connection. Please check your network.");
  } on FirebaseAuthException catch (e) {

    if (e.code == 'email-already-in-use') {
      throw ServerException("This email is already in use.");
    } else if (e.code == 'invalid-email') {
      throw ServerException("The email address is invalid.");
    } else if (e.code == 'weak-password') {
      throw ServerException("The password is too weak.");
    } else if (e.code == 'operation-not-allowed') {
      throw ServerException("Email/password accounts are not enabled.");
    } else {
      throw ServerException("Failed to create account. Please try again.");
    }
  } catch (e) {
    throw ServerException("An unexpected error occurred, please try again later!");
  }
}

  Future<void> signOutAccount() async {
    try {
  await FirebaseAuth.instance.signOut();
} on SocketException {
    throw ServerException("No Internet Connection. Please check your network.");
  } catch (e) {
    if (e is FirebaseAuthException) {
      if (e.code == 'network-request-failed') {
        throw ServerException("Network error during sign-out!");
      } else if (e.code == 'user-token-expired') {
        throw ServerException("Session expired, please login again!");
      } else {
        throw ServerException("Error in fetching school details !");
      }
    } else {
      throw ServerException("An unexpected error occurred while sign-out, please try again later !");
    }
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