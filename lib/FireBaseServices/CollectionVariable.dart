import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart' show GetxController;


class CollectionVariable {}
const int feesAmount = 500;

// teacher variable
const teacherProfileField = 'profile_photo';
const teacherNameField = 'name';
const teacherEmailfield = 'email';
const teacherPhoneNumberfield = 'phoneNo';
const teacherAddressfield = 'Address';
const dateofEmploymentfield = 'Date_of_employment';
const collegedegreefield = 'college_degree';
const yearOfExperiencefield = 'year_of_experience';
const teacherSubjectHandlingfield = 'subject_handling';
const teacherIdFireld = 'id';
const teacherPasskeyField = 'teacherPasskey';
const teacherrole = 'role';

// principal variable
const principalNamefield = 'name';
const principalEmailfield = 'email';
const principalPhoneNumberfield = 'phoneNo';
const principalAddressfield = 'address';
const principalProfilefield = 'profile_photo';
const principalId = 'id';
const principalPasskeyField = 'principalPassKey';
const principalRoleField = 'role';


// staff variable
const staffNamefield = 'name';
const staffEmailfield = 'email';
const staffPhoneNumberfield = 'phoneNo';
const staffAddressfield = 'address';
const staffProfilefield = 'profile_photo';
const stafflId = 'id';
const staffroleField = 'role';
const staffPassKeyField ='staffPassKey';


//student variable

const studentNamefield = 'name';
const stuentEmailfield = 'email';
const studentIdField = 'studentId';
const profilePhotfield = 'profile_photo';
const studentrole = 'role';
const classField = 'class';
const sectionFild = 'section';
const rollNofield = "RollNo";
const dobfield = 'dob';
const fatherNameField = 'Father name';
const fatherPhoneNoField = "Father PhoneNo";
const motherNameField = 'Mother Name';
const motherPhoneNoField = 'Mother PhoneNo';
const studentAddress = 'Address';
const feesStatusField = 'Fess Status';
const attendancePercentageField = 'Attendance Percentage';
const todayAttendanceStatusField = 'Today Attendance';
const studentAdminssionNoField = 'Adminnsion Number';
const totalFees = 'total Fess'; 
const studentPasskeyField = 'studentPassKey';
const totalAttendanceDays = 'totalAttendanceDays';

var dueDate = '12-4-2024';
var fee1 = 'Tuition Fees';
var fee2 = 'Bus Fee';
var fee3 = 'Lab Fee';
var fee1amount = int.parse('6000');
var fee2amount = int.parse('4000');
var fee3amount = int.parse('9000');
var totalfee = fee1amount + fee2amount + fee3amount;

class FirebaseCollectionVariable extends GetxController {
  final Reference firebaseStorageRef = FirebaseStorage.instance.ref();
  final firebaseStorageInstance = FirebaseStorage.instance;
  final schoolDetails =
      FirebaseFirestore.instance.collection('School').doc('school_details');

  final CollectionReference announcementCollection = FirebaseFirestore.instance
      .collection('School')
      .doc('school_details')
      .collection('Announcement');

  final CollectionReference loginCollection = FirebaseFirestore.instance
      .collection('School')
      .doc('school_details')
      .collection('logins');

  final CollectionReference remainderCollection = FirebaseFirestore.instance
      .collection('School')
      .doc('school_details')
      .collection('Remainder');

  final CollectionReference galleryCollection = FirebaseFirestore.instance
      .collection('School')
      .doc('school_details')
      .collection('gallery');

  final CollectionReference timetableCollection = FirebaseFirestore.instance
      .collection('School')
      .doc('school_details')
      .collection('time_table');

  final DocumentReference feesDocCollection = FirebaseFirestore.instance
      .collection('School')
      .doc('school_details')
      .collection('feeDetails')
      .doc('TransactionHistory');

  final DocumentReference attendanceCollection = FirebaseFirestore.instance
      .collection('School')
      .doc('school_details')
      .collection('attendance')
      .doc('classWiseAttendance');

  // Declare as late variables and initialize in onInit
  late final CollectionReference officialLoginCollection;
  late final CollectionReference staffLoginCollection;
  late final CollectionReference teacherLoginCollection;
  late final CollectionReference studentLoginCollection;

  @override
  void onInit() {
    super.onInit();
    
    // Initialize login sub-collections inside onInit
    officialLoginCollection = loginCollection.doc('officials').collection('live_officials');
    staffLoginCollection = loginCollection.doc('staffs').collection('live_staffs');
    teacherLoginCollection = loginCollection.doc('teachers').collection('live_teachers');
    studentLoginCollection = loginCollection.doc('students').collection('live_students');
  }


}
