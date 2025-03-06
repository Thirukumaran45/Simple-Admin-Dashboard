import 'dart:developer' show log;

import 'package:admin_pannel/FireBaseServices/AuthUserModule.dart';
import 'package:admin_pannel/views/widget/CustomDialogBox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthUser {
  
  Future<Authuser?> signinUser({required String email, required String password, required BuildContext context}) async {
  try {
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return Authuser(id: userCredential.user!.uid, email: userCredential.user!.email!);
  } on FirebaseAuthException catch (e) {
    log("Firebase Auth Error: ${e.code}");
    showCustomDialog(context, "Error ${e.code}");
    return null; // Return null if authentication fails
  }
}

}