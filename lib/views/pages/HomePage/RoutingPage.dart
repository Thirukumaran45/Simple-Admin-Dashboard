import 'package:admin_pannel/views/pages/Bonafied/Bonafied.dart';
import 'package:admin_pannel/views/pages/Bus/BusUpdateMainScreen.dart';
import 'package:admin_pannel/views/pages/ExamUpdate/widgets/StudentResult.dart';
import 'package:admin_pannel/views/pages/Fees/widget/FeesTransactionHistry.dart';
import 'package:admin_pannel/views/pages/Fees/widget/SectionWiseFeesUpdation.dart';
import 'package:admin_pannel/views/pages/Fees/widget/StudentFeesList.dart';
import 'package:admin_pannel/views/pages/Fees/widget/BankDetails.dart';
import 'package:admin_pannel/views/pages/Fees/widget/studentFeesUpdationPage.dart';
import 'package:admin_pannel/views/pages/HomePage/HomePage.dart';
import 'package:admin_pannel/views/pages/Time%20Table/SectionWiseTimetable.dart';
import 'package:admin_pannel/views/pages/Time%20Table/TimeTable.dart';
import 'package:beamer/beamer.dart';
import 'package:admin_pannel/views/pages/SchoolDetailsUpdate/SchoolUpdateMainScreen.dart';
import 'package:admin_pannel/views/pages/SchoolDetailsUpdate/widget/PhotoViewPage.dart';
import 'package:admin_pannel/views/pages/peoples/HigherOfficial/HigherOfficialMainScreen.dart';
import 'package:admin_pannel/views/pages/peoples/HigherOfficial/Widgets/AddHigherOfficialTab.dart';
import 'package:admin_pannel/views/pages/peoples/HigherOfficial/Widgets/HigherOfficialDetailsTab.dart';
import 'package:admin_pannel/views/pages/peoples/HigherOfficial/Widgets/HigherOfficialEditDownload.dart';
import 'package:admin_pannel/views/pages/peoples/Students/StudentMainScreen.dart';
import 'package:admin_pannel/views/pages/peoples/Students/Widgets/AddStudent.dart';
import 'package:admin_pannel/views/pages/peoples/Students/Widgets/StudentDetailTab.dart';
import 'package:admin_pannel/views/pages/peoples/Students/Widgets/StudentEditDownload.dart';
import 'package:admin_pannel/views/pages/peoples/Teachers/TeacherMainScreen.dart';
import 'package:admin_pannel/views/pages/peoples/Teachers/Widgets/AddTeacherss.dart';
import 'package:admin_pannel/views/pages/peoples/Teachers/Widgets/ClassIncargerDetails.dart';
import 'package:admin_pannel/views/pages/peoples/Teachers/Widgets/TeacherDetailTab.dart';
import 'package:admin_pannel/views/pages/peoples/Teachers/Widgets/TeacherEditDownload.dart';
import 'package:admin_pannel/views/pages/peoples/staff/Widgets/AddStaffDetails.dart';
import 'package:admin_pannel/views/pages/peoples/staff/Widgets/StaffDetailsStaff.dart';
import 'package:admin_pannel/views/pages/peoples/staff/Widgets/StaffEditDownload.dart';
import 'package:admin_pannel/views/pages/peoples/staff/staff.dart';
import 'package:flutter/material.dart';
import 'package:admin_pannel/views/pages/ResetYear/ResetSchoolYearScreen.dart';
import 'package:admin_pannel/views/pages/ResetYear/SectionwiseReset.dart';
import 'package:admin_pannel/views/pages/Attendance/AttendanceMainScreen.dart';
import 'package:admin_pannel/views/pages/Attendance/widgets/AttendanceDownloadPage.dart';
import 'package:admin_pannel/views/pages/Attendance/widgets/SeectionMainPage.dart';
import 'package:admin_pannel/views/pages/ExamUpdate/ExamUpdateScreen.dart';
import 'package:admin_pannel/views/pages/ExamUpdate/widgets/StudentExamResultPublish.dart';
import 'package:admin_pannel/views/pages/ExamUpdate/widgets/sectionWiseExamResutlPublish.dart';
import 'package:admin_pannel/views/pages/Fees/FeesUpdateScreen.dart';

Widget routingNameUri({required beamerKey})
{
  
  return   Container(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
            
                borderRadius: BorderRadius.circular(10.0)
              ),
              child: Beamer(key: beamerKey,routerDelegate: BeamerDelegate(locationBuilder:RoutesLocationBuilder(routes: {
               
            
                '/*': (context, state, data)=>
                 const  BeamPage(child:  SizedBox(),
                 title: "NAG- Admin Pannel",
                    type: BeamPageType.scaleTransition,key: ValueKey('initial')),
            
                '/home': (context, state, data)=>
                 const  BeamPage(child:  Homepage(),
                 title: 'Dashborad',
                    type: BeamPageType.scaleTransition,key: ValueKey('Home')),

                    // Attendance
                   '/attendance': (context, state, data) => const BeamPage(
                    title: 'School Attendance',
                    type: BeamPageType.scaleTransition,
            child: AttendanceMainScreen(),
          ),

      '/attendance/class': (context, state, data) {

  final classNumber = state.queryParameters['classNumber'] ?? '';

  return BeamPage(
    title: 'Class - $classNumber',
    child: ClassPage(classNumber: classNumber),
    type: BeamPageType.slideRightTransition,
    key: ValueKey('Class $classNumber'),
  );
},


      '/attendance/class/section': (context, state, data) {
  final classNumber = state.queryParameters['classNumber'] ?? '';
  final sectionName = state.queryParameters['sectionName'] ?? '';

              return BeamPage(
                title: 'Class $classNumber - $sectionName',
    child: AttendanceDownloadPage(section: sectionName, classNUmber: classNumber),
    type: BeamPageType.slideRightTransition,
    key: ValueKey('Class $classNumber - Section $sectionName'),
  );
},

                  // fees updation
                  '/fees-updation': (context, state, data){
                  if(state.pathPatternSegments.contains('feesTransactionHistry'))
                  {
                  return  const  BeamPage(child:  Feestransactionhistry(),
                 title: 'Fees Transaction Histry',
                    type: BeamPageType.slideLeftTransition,key: ValueKey('Fees Transaction histry'));
                  }

                  else if(state.pathPatternSegments.contains('sectionWiseFeesUpdation'))
                   {
                     
                   return  const  BeamPage(child:  SectionWiseFeesUpdation(),
                 title: 'Class and Section Selection for Fee Update',
                    type: BeamPageType.slideLeftTransition,key: ValueKey('Sectionwise student fees update'));
                 
                   }
               return  const  BeamPage(child:  FeesUpdateScreen(),
                 title: 'Fees Updation',
                    type: BeamPageType.scaleTransition,key: ValueKey('Fees Update'));},

              "/fees-updation/sectionWiseFeesUpdation/studentFeesList" :(context, state,data){
               
               

                 final classNumber = state.queryParameters['classNumber'] ?? '';
                 final sectionName = state.queryParameters['sectionName'] ?? '';
                  return    BeamPage(child:  StudentFeesList(stuClass: classNumber,section: sectionName,),
                 title: 'Student Fees List',
                    type: BeamPageType.slideLeftTransition,key: const ValueKey('student fees list'));
              },
                  


                '/fees-updation/sectionWiseFeesUpdation/studentFeesList/studentFeesUpdation': (context, state, data){
                        final String stuName = state.queryParameters['name']??'';

                 final classNumber = state.queryParameters['classNumber'] ?? '';
                 final sectionName = state.queryParameters['sectionName'] ?? '';
                return   BeamPage(child:  StudentFeesUpdationpage( stuName: stuName,stuClass:  classNumber,stuSec: sectionName),
                 title: 'Student Fees Detials Updation',
                    type: BeamPageType.slideLeftTransition,key:const ValueKey('Student Fees Updation'));},
                   
                   '/fees-updation/bankDetails':(context, state, data){
                        

                return  const BeamPage(child:  BankAccountDetails(),
                 title: 'Bank Account Details Detials',
                    type: BeamPageType.slideRightTransition,key: ValueKey('Bank account details Updation'));},


                    //exam updation
                     '/exam-Details-updation': (context, state, data)=>
                 const  BeamPage(child:  ExamUpdateScreen(),
                 title: 'Exam Detials Updation',
                    type: BeamPageType.scaleTransition,key: ValueKey('Exam Updates')),
                
                    '/exam-Details-updation/sectionWiseResultPublishment' :(context, state, data){
                      final String examName = state.queryParameters['examName']??'';
                      return   BeamPage(child: SectionWiseexamResutlPublish(examName: examName,)  ,
                       title: 'Select Class & Section to Publish Exam Result',
                    type: BeamPageType.slideLeftTransition,key:const  ValueKey('Class & Section Selection'));
                 
                    },
                    '/exam-Details-updation/sectionWiseResultPublishment/studentOverview' :(context, state, data){
                      final String examName = state.queryParameters['examName']??'';
                      final String sectionNmae = state.queryParameters['section']??'';
                        final String stuClass = state.queryParameters['class']??'';

                      return   BeamPage(child: StudentExamResultPublish(examName: examName, section: sectionNmae, stuClass:stuClass ,)  ,
                       title: 'Select Student Exam Result',
                    type: BeamPageType.slideLeftTransition,key:const  ValueKey('Select student result'));
                 
                    
                    },
                     '/exam-Details-updation/sectionWiseResultPublishment/studentOverview/student' :(context, state, data){
                        final String examName = state.queryParameters['examName']??'';
                        final String stuClass = state.queryParameters['class']??'';
                      final String stuSection = state.queryParameters['section']??'';
                      final String name = state.queryParameters['name']??'';
                       return   BeamPage(child: StudentResult(stuname: name, stuClass: stuClass,stuSec: stuSection,examName: examName ,) ,
                       title: 'Upload the Exam Result',
                    type: BeamPageType.slideLeftTransition,key:const  ValueKey('publish student result'));
                 
                     },
                    //student management
                      '/manage-student': (context, state, data){
                  if(state.pathPatternSegments.contains('addStudent')){
                    return const BeamPage(child: AddStudentTab(),
                    title: 'Add Student',
                    type: BeamPageType.slideLeftTransition,key: ValueKey('Add Student'));
                  }
                 else if (state.pathPatternSegments.contains('viewStudentDetails')) {
                    if (state.pathPatternSegments.contains('editStudentDetails')) {
                     return const BeamPage(
                      title: 'Edit Student Details',
        child: StudentEditDownload(),
        type: BeamPageType.slideLeftTransition,
        key: ValueKey('Edit Student Details'),
      );
    }
    return const BeamPage(
      child: StudentDetailsTab(),
      title: "View Student Details",
      type: BeamPageType.slideLeftTransition,
      key: ValueKey('View Student Details'),
    );
    }
                 return const BeamPage(child:  StudentMainScreen(),
                 title: "Manage Students",
                    type: BeamPageType.scaleTransition,key: ValueKey('Manage Student'));},
                  
                  
                    //teacher management
                      '/manage-teacher': (context, state, data){
                  if(state.pathPatternSegments.contains('addTeacher')){
                    return const BeamPage(child: AddTeacherTab(),
                    title: "Add Teacher",
                    type: BeamPageType.slideLeftTransition,key: ValueKey('Add Teacher'));
                  }
                  else if(state.pathPatternSegments.contains('classInchargerDetails'))
                  {
                    return const BeamPage(child: ClassInchargerDetails(),
                    title: "Class and Section wise Incharger Name",
                    type: BeamPageType.slideLeftTransition,key: ValueKey('class Incharger'));
                  
                  }
                  else if(state.pathPatternSegments.contains('viewTeacherDetails')){
                     if (state.pathPatternSegments.contains('editTeacherDetails')) {
                     return const BeamPage(
                      title: " Edit Teacher Details",
                    child: TeacherEditDownload(),
                        type: BeamPageType.slideLeftTransition,
                       key: ValueKey('Edit Teacher Details'),
      );
    }
                     return const BeamPage(child:  TeacherDetailsTab(),
                     title: 'View Teacher Details',
                    type: BeamPageType.slideLeftTransition,key: ValueKey('View Teacher Details'));
                 
                  } 
                 return const BeamPage(child:  TeacherMainScreen(),
                 title: "Manage Teachers",
                    type: BeamPageType.scaleTransition,key: ValueKey('Manage Teacher'));},
                    
                    //higher official management
                      '/manage-higher-official': (context, state, data){
                  if(state.pathPatternSegments.contains('addOfficial')){
                    return const BeamPage(child: AddHigherOfficialTab(),
                    title: "Add Higher Officials",
                    type: BeamPageType.slideLeftTransition,key: ValueKey('Add Official'));
                  }
                  else if(state.pathPatternSegments.contains('viewHigherOfficailDetails')){
                    if (state.pathPatternSegments.contains('editHigherOfficialDetails')) {
                     return const BeamPage(
        child:HigherOfficialEditDownload (),
        title: "Edit Higher Officials",
        type: BeamPageType.slideLeftTransition,
        key: ValueKey('Edit Higher Official Details'),
      );
    }
                     return const BeamPage(child:  HigherOfficialDetailsTab(),
                     title: "View Higher Official Details",
                    type: BeamPageType.slideLeftTransition,key: ValueKey('View Official Details'));
                 
                  } 
                return const  BeamPage(child:  HigherOfficialMainScreen(),
                title: " Manage Higher Official",
                    type: BeamPageType.scaleTransition,key: ValueKey('Manage Officials'));},

                    //working staff management
                      '/manage-working-staff': (context, state, data){
                  if(state.pathPatternSegments.contains('addWorkingStaff')){
                    return const BeamPage(child: AddStaffTab(),
                    title: "Add Working Staff",
                    type: BeamPageType.slideLeftTransition,key: ValueKey('Add Staff'));
                  }
                  else if(state.pathPatternSegments.contains('viewStaffDetails')){
                    if (state.pathPatternSegments.contains('editWorkingStaffDetails')) {
                     return const BeamPage(
                      title: "Edit Working Staff Details",
        child: StaffEditDownload(),
        type: BeamPageType.slideLeftTransition,
        key: ValueKey('Edit Working Staff Details'),
      );
    }
                     return const BeamPage(child:  StaffDetailsTab(),
                     title: "View Working Staff Details",
                    type: BeamPageType.slideLeftTransition,key: ValueKey('View Staff Details'));
                 
                  } 
                 return const  BeamPage(child:  StaffMainScreen(),
                 title: "Manage Working Staff",
                    type: BeamPageType.scaleTransition,key: ValueKey('Manage Staff'));},

                    //school detaisl updation
                      '/school-details-updation': (context, state, data)=>
                 const  BeamPage(child:  SchoolUpdateMainScreen(),
                 title: "School Details Updation",
                    type: BeamPageType.scaleTransition,key: ValueKey('School Updates')),
                     '/school-details-updation/viewPhoto': (context, state, data){  
                    final assetLink = state.queryParameters['assetLink'] ?? '';
                return    BeamPage(child:  Photoviewpage(assetLink: assetLink,),
                 title: "Gallary Photo",
                    type: BeamPageType.slideLeftTransition,key: const ValueKey('Gallary photo'));},
                
                      //school-timeTable' bus updation
                      '/school-timeTable': (context, state, data){

              return   const  BeamPage(child:  Timetable(),
                 title: "School Time Table",
                    type: BeamPageType.scaleTransition,key: ValueKey('school time table'));},
                 
                    '/school-timeTable/sectionTimetable': (context, state, data){
                      
                        final String stuClass = state.queryParameters['class']??'';
                      final String stuSection = state.queryParameters['section']??'';
                  return     BeamPage(child:  SectionWiseTimetable(stuClass: stuClass,stuSec: stuSection,),
                 title: "Class and Section wise Time Table",
                    type: BeamPageType.scaleTransition,key: ValueKey('time table'));},
                 
                        

                   //bonafied' bus updation
                      '/bonafied': (context, state, data)=>
                 const  BeamPage(child:  Bonafied(),
                 title: "Generate Bonafied",
                    type: BeamPageType.scaleTransition,key: ValueKey('bonafied')),
                 

                    //live bus updation
                      '/live-bus-operation': (context, state, data)=>
                 const  BeamPage(child:  BusUpdateMainScreen(),
                 title: "Live Bus Updation",
                    type: BeamPageType.scaleTransition,key: ValueKey('Live Bus')),

                    //schoolyear reset
                      '/schoolYear-data-updation': (context, state, data){
                         if(state.pathPatternSegments.contains('sectionWiseResetHistry')){
                    return  BeamPage(child: SectionWiseResetData(),
                    title: "Select Section Reset Histry",
                    type: BeamPageType.slideLeftTransition,key: const ValueKey('Section wise Reset'));
                  }
                return const  BeamPage(child:  ResetSchoolYearScreen(),
                 title: "Reset School Data",
                    type: BeamPageType.scaleTransition,key: ValueKey('Reset Year'));},

                           

                    
                    
              }).call)
            
              ),
            );
}