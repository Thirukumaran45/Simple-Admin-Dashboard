
import '../Bonafied/Bonafied.dart';
import '../Bonafied/widget/ClassWiseBonafied.dart';
import '../Bonafied/widget/StudentBonafied.dart';
import '../Bus/BusUpdateMainScreen.dart';
import '../ExamUpdate/widgets/StudentResult.dart';
import '../Fees/FeesUpdateScreen.dart';
import '../Fees/widget/BankDetails.dart';
import '../Fees/widget/FeesTransactionHistry.dart';
import '../Fees/widget/SectionWiseFeesUpdation.dart';
import '../Fees/widget/StudentFeesList.dart';
import '../Fees/widget/studentFeesUpdationPage.dart';
import 'HomePage.dart';
import '../Time Table/SectionWiseTimetable.dart';
import '../Time Table/TimeTable.dart';
import 'package:beamer/beamer.dart';
import '../SchoolDetailsUpdate/SchoolUpdateMainScreen.dart';
import '../SchoolDetailsUpdate/widget/PhotoViewPage.dart';
import '../peoples/HigherOfficial/HigherOfficialMainScreen.dart';
import '../peoples/HigherOfficial/Widgets/AddHigherOfficialTab.dart';
import '../peoples/HigherOfficial/Widgets/HigherOfficialDetailsTab.dart';
import '../peoples/HigherOfficial/Widgets/HigherOfficialEditDownload.dart';
import '../peoples/Students/StudentMainScreen.dart';
import '../peoples/Students/Widgets/AddStudent.dart';
import '../peoples/Students/Widgets/StudentDetailTab.dart';
import '../peoples/Students/Widgets/StudentEditDownload.dart';
import '../peoples/Teachers/TeacherMainScreen.dart';
import '../peoples/Teachers/Widgets/AddTeacherss.dart';
import '../peoples/Teachers/Widgets/ClassIncargerDetails.dart';
import '../peoples/Teachers/Widgets/TeacherDetailTab.dart';
import '../peoples/Teachers/Widgets/TeacherEditDownload.dart';
import '../peoples/staff/Widgets/AddStaffDetails.dart';
import '../peoples/staff/Widgets/StaffDetailsStaff.dart';
import '../peoples/staff/Widgets/StaffEditDownload.dart';
import '../peoples/staff/staff.dart';
import 'package:flutter/material.dart';
import '../ResetYear/ResetSchoolYearScreen.dart';
import '../ResetYear/SectionwiseReset.dart';
import '../Attendance/AttendanceMainScreen.dart';
import '../Attendance/widgets/AttendanceDownloadPage.dart';
import '../Attendance/widgets/SeectionMainPage.dart';
import '../ExamUpdate/ExamUpdateScreen.dart';
import '../ExamUpdate/widgets/StudentExamResultPublish.dart';
import '../ExamUpdate/widgets/sectionWiseExamResutlPublish.dart';

Widget routingNameUri({required GlobalKey<BeamerState> beamerKey})
{
 return   Container(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
            
                borderRadius: BorderRadius.circular(10.0)
              ),
              child:    Beamer(key: beamerKey,routerDelegate: BeamerDelegate(
                locationBuilder:RoutesLocationBuilder(routes: {
               
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
                    '/fees-updation': (context, state, data)=>
                const  BeamPage(child:  FeesUpdateScreen(),
                 title: 'Fees Updation',
                    type: BeamPageType.scaleTransition,key: ValueKey('Fees Update')),

                   '/fees-updation/feesTransactionHistry' : (context,state,data)=>
                    const  BeamPage(child:  Feestransactionhistry(),
                 title: 'Fees Transaction Histry',
                    type: BeamPageType.slideLeftTransition,key: ValueKey('Fees Transaction histry')),
                 
                  '/fees-updation/sectionWiseFeesUpdation': (context,state,data)=>
                   const  BeamPage(child:  SectionWiseFeesUpdation(),
                 title: 'Class and Section Selection for Fee Update',
                    type: BeamPageType.slideLeftTransition,key: ValueKey('Sectionwise student fees update')),
               
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
                 final id = state.queryParameters['id']??'';
                return   BeamPage(child:  StudentFeesUpdationpage( stuName: stuName,stuClass:  classNumber,stuSec: sectionName, id: id,),
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
                      final String id = state.queryParameters['id']??'';
                      final String singleSub = state.queryParameters['singleSubjectMark']??'';
                       return   BeamPage(child: StudentResult(id:id ,stuname: name,
                        stuClass: stuClass,stuSec: stuSection,examName: examName ,singleSubjectMark: singleSub,) ,
                       title: 'Upload the Exam Result',
                    type: BeamPageType.slideLeftTransition,key:const  ValueKey('publish student result'));
                  },

                    //student management
                    '/manage-student':(context,state,data)=>
                    const BeamPage(child:  StudentMainScreen(),
                 title: "Manage Students",
                    type: BeamPageType.scaleTransition,key: ValueKey('Manage Student')),

                    '/manage-student/addStudent':(context,state,data)=>
                    const BeamPage(child: AddStudentTab(),
                    title: 'Add Student',
                    type: BeamPageType.slideLeftTransition,key: ValueKey('Add Student')),

                    '/manage-student/viewStudentDetails':(context,state,data)=>
                    const BeamPage(child: StudentDetailsTab(), title: "View Student Details",
                    type: BeamPageType.slideLeftTransition, key: ValueKey('View Student Details'),),
                    
                    '/manage-student/viewStudentDetails/editStudentDetails':(context,state,data){
                    final String uid = state.queryParameters['uid']??'';
                   
                    return  BeamPage( title: 'Edit Student Details', child: StudentEditDownload(uid:uid ,),
                        type: BeamPageType.slideLeftTransition, key: const ValueKey('Edit Student Details'),);
                    },
                    
                 
                    //teacher management
                    '/manage-teacher':(context,state,data)=>
                     const BeamPage(child:  TeacherMainScreen(),
                 title: "Manage Teachers", type: BeamPageType.scaleTransition,key: ValueKey('Manage Teacher')),
 
                     '/manage-teacher/addTeacher':(context,state,data)=>
                     const BeamPage(child: AddTeacherTab(),title: "Add Teacher",
                     type: BeamPageType.slideLeftTransition,key: ValueKey('Add Teacher')),

                    '/manage-teacher/classInchargerDetails':(context,state,data)=>
                    const BeamPage(child: ClassInchargerDetails(),
                    title: "Class and Section wise Incharger Name",
                    type: BeamPageType.slideLeftTransition,key: ValueKey('class Incharger')),

                     '/manage-teacher/viewTeacherDetails':(context,state,data)=>
                       const BeamPage(child:  TeacherDetailsTab(),title: 'View Teacher Details',
                    type: BeamPageType.slideLeftTransition,key: ValueKey('View Teacher Details')),

                    '/manage-teacher/viewTeacherDetails/editTeacherDetails':(context,state,data){
                    final String uid = state.queryParameters['uid']??'';

                    return BeamPage( title: " Edit Teacher Details", child: TeacherEditDownload(uid:uid),
                        type: BeamPageType.slideLeftTransition, key:const ValueKey('Edit Teacher Details'),);},

                    
                    
                    //higher official management

                     '/manage-higher-official':(context,state,data)=>
                     const  BeamPage(child:  HigherOfficialMainScreen(),
                title: " Manage Higher Official",type: BeamPageType.scaleTransition,
                key: ValueKey('Manage Officials')),

                '/manage-higher-official/addOfficial':(context,state,data)=>
                const BeamPage(child: AddHigherOfficialTab(),
                    title: "Add Higher Officials",type: BeamPageType.slideLeftTransition,
                    key: ValueKey('Add Official')),

                '/manage-higher-official/viewHigherOfficailDetails':(context,state,data)=>
                    const BeamPage(child:  HigherOfficialDetailsTab(),
                     title: "View Higher Official Details",
                    type: BeamPageType.slideLeftTransition,key: ValueKey('View Official Details')),
                 '/manage-higher-official/viewHigherOfficailDetails/editHigherOfficialDetails':(context,state,data){
                    final String uid = state.queryParameters['uid']??'';
                    return BeamPage( child:HigherOfficialEditDownload (uid:uid),title: "Edit Higher Officials",
                    type: BeamPageType.slideLeftTransition,key: const ValueKey('Edit Higher Official Details'),);},
    

                    //working staff management
                    '/manage-working-staff':(context,state,data)=>
                    const  BeamPage(child:  StaffMainScreen(),
                 title: "Manage Working Staff",
                    type: BeamPageType.scaleTransition,key: ValueKey('Manage Staff')),

                    '/manage-working-staff/addWorkingStaff':(context,state,data)=>
                    const BeamPage(child: AddStaffTab(),
                    title: "Add Working Staff",type: BeamPageType.slideLeftTransition,
                    key: ValueKey('Add Staff')),
                    
                    '/manage-working-staff/viewStaffDetails':(context,state,data)=>
                     const BeamPage(child:  StaffDetailsTab(),
                     title: "View Working Staff Details",
                    type: BeamPageType.slideLeftTransition,key: ValueKey('View Staff Details')),

                    '/manage-working-staff/viewStaffDetails/editWorkingStaffDetails':(context,state,data){
                    final String uid = state.queryParameters['uid']??'';
                    return BeamPage(
                      title: "Edit Working Staff Details",child: StaffEditDownload(uid:uid),
                      type: BeamPageType.slideLeftTransition, key:const  ValueKey('Edit Working Staff Details'),);},

                    
                    //school detaisl updation
                      '/school-details-updation': (context, state, data)=>
                 const  BeamPage(child:  SchoolUpdateMainScreen(),
                 title: "School Details Updation",
                    type: BeamPageType.scaleTransition,key: ValueKey('School Updates')),
                     '/school-details-updation/viewPhoto': (context, state, data){  
                    
                return  const    BeamPage(child:  Photoviewpage(),
                 title: "School Icon Image",
                    type: BeamPageType.slideLeftTransition,key:  ValueKey('Gallary photo'));},
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
                    type: BeamPageType.slideLeftTransition,key: const ValueKey('time table'));},
                 
                        

                   //bonafied' bus updation
                   '/bonafied': (context,state,data)=>
                   const  BeamPage(child:  Bonafied(),title: "Generate Bonafied",
                    type: BeamPageType.scaleTransition,key: ValueKey('bonafied')),

                    '/bonafied/studentBonafied':(context,state,data)=>
                     const  BeamPage(child:  StudentBonafied(),
                 title: "Student Bonafied Generator",
                    type: BeamPageType.slideLeftTransition,key: ValueKey('student bonafied')),
                 
                 '/bonafied/classWiseBonafied':(context,state,data)=>
                 const  BeamPage(child:  ClasswiseBonafied(),
                 title: "Class and Section wise Bonafied Generator",
                    type: BeamPageType.slideLeftTransition,key: ValueKey('class and section wise generator')),
                 

                    //live bus updation
                      '/live-bus-operation': (context, state, data)=>
                 const  BeamPage(child:  BusUpdateMainScreen(),
                 title: "Live Bus Updation",
                    type: BeamPageType.scaleTransition,key: ValueKey('Live Bus')),

                    //schoolyear reset
                    '/schoolYear-data-updation/sectionWiseResetHistry':(context,state,data){ 
                    final String stuClass = state.queryParameters['class']??'';
                  return BeamPage(child: SectionWiseResetData(stuClass: stuClass,),
                    title: "Select Section Reset Histry",
                    type: BeamPageType.slideLeftTransition,key: const ValueKey('Section wise Reset'));},
                
                      '/schoolYear-data-updation': (context, state, data){
                    return const  BeamPage(child:  ResetSchoolYearScreen(), title: "Reset School Data",
                    type: BeamPageType.scaleTransition,key: ValueKey('Reset Year'));},   
              }).call)
            
              ),
            );
}