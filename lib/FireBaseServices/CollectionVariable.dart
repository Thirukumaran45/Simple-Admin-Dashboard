import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FirebaseCollectionVariable extends GetxController {
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

  Future<void> signOutAccount() async {
    await FirebaseAuth.instance.signOut();
  }
}
