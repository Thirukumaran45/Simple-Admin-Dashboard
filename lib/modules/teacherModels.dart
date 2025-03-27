
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class Teacherdetailmodel {
  final String teacherProfile;
  final String teacherName; 
  final String teacherEmail;
  final String teacherPhoneNumber;
  final String teacherAddress;
  final String dateofemployment;
  final String collegedegree;
  final String yearofexperience;
  final String teacherSubjectHandling;
  final String id;
  final String role;
// the below constructor is used in the case of returning the specific user id and the text
  const Teacherdetailmodel({
    required this.teacherProfile,
    required this.teacherName,
    required this.teacherEmail,
    required this.teacherPhoneNumber,
    required this.teacherAddress,
    required this.dateofemployment,
    required this.collegedegree,
    required this.yearofexperience,
    required this.teacherSubjectHandling,
    required this.id,
    required this.role,
  });
//the below constructor is used in the case of returning all the user and all the user text .
// we can specify the user by using the where functions
  Teacherdetailmodel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        teacherProfile = snapshot.data()?[teacherProfileField] ?? " ",
        role = snapshot.data()?[teacherrole] ?? " ",
        teacherName = snapshot.data()?[teacherNameField] ?? " ",
        teacherEmail = snapshot.data()?[teacherEmailfield] ?? " ",
        teacherPhoneNumber = snapshot.data()?[teacherPhoneNumberfield] ?? " ",
        teacherAddress = snapshot.data()?[teacherAddressfield] ?? " ",
        dateofemployment = snapshot.data()?[dateofEmploymentfield] ?? " ",
        collegedegree = snapshot.data()?[collegedegreefield] ?? " ",
        yearofexperience = snapshot.data()?[yearOfExperiencefield] ?? " ",
        teacherSubjectHandling = snapshot.data()?[teacherSubjectHandlingfield] ?? " ";
}
