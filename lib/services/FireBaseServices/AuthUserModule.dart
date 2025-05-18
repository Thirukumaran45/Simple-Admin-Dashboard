import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class Authuser {
  final String id;
  final String email;
  const Authuser({required this.id, required this.email});
  factory Authuser.fromFirebase(User user) =>
      Authuser(email: user.email!, id: user.uid);
}