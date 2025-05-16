
import '../contant/ConstantVariable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Stafffdetailsmodel {
  final String staffName;
  final String staffEmail;
  final String staffPhoneNumber;
  final String staffAddress;
  final String staffProfile;
  final String Id;
  final String role;
// the below constructor is used in the case of returning the specific user id and the text
  const Stafffdetailsmodel({
    required this.role,
    required this.staffName,
    required this.staffEmail,
    required this.staffPhoneNumber,
    required this.staffAddress,
    required this.staffProfile,
    required this.Id,
  });
//the below constructor is used in the case of returning all the user and all the user text .
// we can specify the user by using the where functions
  Stafffdetailsmodel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : Id = snapshot.id,
        staffProfile = snapshot.data()?[staffProfilefield]?? "",
        role = snapshot.data()?[staffroleField]?? "",
        staffName = snapshot.data()?[staffNamefield]?? "",
        staffEmail = snapshot.data()?[staffEmailfield]?? "",
        staffAddress = snapshot.data()?[staffAddressfield]?? "",
        staffPhoneNumber = snapshot.data()?[staffPhoneNumberfield]?? "";
}