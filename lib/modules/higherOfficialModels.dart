import '../contant/ConstantVariable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable 
class Principaldetailmodel {
  final String principalName;
  final String principalEmail;
  final String principalPhoneNumber;
  final String principalAddress;
  final String principalProfile;
  final String Id;
  final String role;
// the below constructor is used in the case of returning the specific user id and the text
  const Principaldetailmodel({
    required this.role,
    required this.principalName,
    required this.principalEmail,
    required this.principalPhoneNumber,
    required this.principalAddress,
    required this.principalProfile,
    required this.Id,
  });
//the below constructor is used in the case of returning all the user and all the user text .
// we can specify the user by using the where functions
  Principaldetailmodel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : Id = snapshot.id,
        principalProfile = snapshot.data()?[principalProfilefield] ?? "" ,
        role = snapshot.data()?[principalRoleField] ?? "",
        principalName = snapshot.data()?[principalNamefield] ?? "",
        principalAddress = snapshot.data()?[principalAddressfield] ?? "",
        principalEmail = snapshot.data()?[principalEmailfield] ?? "",
        principalPhoneNumber = snapshot.data()?[principalPhoneNumberfield] ?? "";
}