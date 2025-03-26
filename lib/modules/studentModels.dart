import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';

@immutable
class StudentdetailsModel {
  final String studentName;
  final String role;
  final String studentEmail;
  final String stdentId;
  final String profilePhot;
  final String studentClass;
  final String studentSection;
  final String rollNo;
  final String dob;
  final String fatherName;
  final String fatherPhone;
  final String motherName;
  final String motherPhoneNo;
  final String address;
  final String feesStatus;
  final String attendancePercentage;
  final String todayAttendanceStatus;
  final String totalAttendanceDaysCount;
  final String studentAdminssion;
  final String allFees;
// the below constructor is used in the case of returning the specific user id and the text
  const StudentdetailsModel({
    required this.studentName,
    required this.totalAttendanceDaysCount,
    required this.studentEmail,
    required this.stdentId,
    required this.profilePhot,
    required this.role,
    required this.studentClass,
    required this.studentSection,
    required this.rollNo,
    required this.dob,
    required this.fatherName,
    required this.fatherPhone,
    required this.motherName,
    required this.motherPhoneNo,
    required this.address,
    required this.feesStatus,
    required this.attendancePercentage,
    required this.todayAttendanceStatus,
    required this.studentAdminssion,
    required this.allFees,
  });
//the below constructor is used in the case of returning all the user and all the user text .
// we can specify the user by using the where functions
StudentdetailsModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  )   : studentName = snapshot.data()? [studentNamefield] ?? '',
        stdentId = snapshot.id,
        studentAdminssion = snapshot.data()? [studentAdminssionNoField]?.toString() ?? '',
        profilePhot = snapshot.data()? [profilePhotfield] ?? '',
        role = snapshot.data()? [studentrole] ?? '',
        studentClass = snapshot.data()? [classField]?.toString() ?? '',
        studentSection = snapshot.data()? [sectionFild] ?? '',
        rollNo = snapshot.data()? [rollNofield]?.toString() ?? '',
        dob = snapshot.data()? [dobfield] ?? '',
        fatherName = snapshot.data()? [fatherNameField] ?? '',
        fatherPhone = snapshot.data()? [fatherPhoneNoField]?.toString() ?? '',
        motherName = snapshot.data()? [motherNameField] ?? '',
        motherPhoneNo = snapshot.data()? [motherPhoneNoField]?.toString() ?? '',
        address = snapshot.data()? [studentAddress] ?? '',
        feesStatus = snapshot.data()? [feesStatusField] ?? '',
        attendancePercentage = snapshot.data()? [attendancePercentageField]?.toString() ?? '',
        todayAttendanceStatus = snapshot.data()? [todayAttendanceStatusField]?.toString() ?? '',
        studentEmail = snapshot.data()? [stuentEmailfield] ?? '',
        allFees = snapshot.data()? [totalFees]?.toString() ?? '',
        totalAttendanceDaysCount = snapshot.data()? [totalAttendanceDays]?.toString() ?? '';
}