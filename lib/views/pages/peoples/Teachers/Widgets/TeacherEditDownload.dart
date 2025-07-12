import 'package:admin_pannel/utils/ExceptionDialod.dart';

import '../../../../../contant/ConstantVariable.dart' show dateofEmploymentfield;
import '../../../../../controller/classControllers/peoplesControlelr/TeacherController.dart';
import '../../../../../modules/teacherModels.dart';
import '../../../../../contant/CustomNavigation.dart';
import '../../../../../contant/pdfApi/pdfTeacher/pdfTeacherDetails.dart';
import '../../../../widget/CustomDialogBox.dart';
import '../../../../widget/CustomeButton.dart';
import '../../../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst;
 
class TeacherEditDownload extends StatefulWidget {
   final String uid;
  const TeacherEditDownload({super.key, required this.uid});

  @override
  _StudentEditDownloadState createState() => _StudentEditDownloadState();
}

class _StudentEditDownloadState extends State<TeacherEditDownload> {
  // Sample data for the student (using TextEditingController for editable fields)
  late TextEditingController firstNameController;
  late TextEditingController degreeController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController homeAddressController;
  late TextEditingController subjectHandlingController;
  late TextEditingController emplymentDateController;
  late TextEditingController experienceController;
  String? assetImage;
  bool isEdited = false;
  Teacherdetailmodel? teacherDetails;
  late Teachercontroller controller ;
  @override
  void initState() {
    super.initState();
    controller = Get.find<Teachercontroller>();
    initializeFunction();
   }

Future<void> handlePhotoUpdate(String studentId) async {
  String? newPhotoUrl =await ExceptionDialog().handleExceptionDialog(context, ()async=> await  controller.updateTeacherPhoto(studentId ,context));
  
  if (newPhotoUrl!.isNotEmpty) { 
    setState(() {
      assetImage = newPhotoUrl; // Update UI with new photo URL
    });
  }
}

  Future<void>initializeFunction()async{
  teacherDetails = await ExceptionDialog().handleExceptionDialog(context, ()async=> await controller.teacherDataRead(context,uid: widget.uid));
   if (teacherDetails == null) {
      return;
    }

    // ignore: use_build_context_synchronously
    String? photoUrl =await ExceptionDialog().handleExceptionDialog(context, ()async=> await controller.getTeacherPhotoUrl(context,teacherDetails!.id));
    
    setState(() {
       assetImage = photoUrl ?? teacherDetails?.teacherProfile;
       experienceController = TextEditingController(text: teacherDetails?.yearofexperience??'');
    firstNameController = TextEditingController(text:teacherDetails?.teacherName??'');
    degreeController = TextEditingController(text: teacherDetails?.collegedegree??'');
    phoneNumberController = TextEditingController(text:teacherDetails?.teacherPhoneNumber??'');
    emailController = TextEditingController(text: teacherDetails?.teacherEmail??'');
    homeAddressController = TextEditingController(text: teacherDetails?.teacherAddress??'');
    subjectHandlingController = TextEditingController(text: teacherDetails?.teacherSubjectHandling??'');
    emplymentDateController = TextEditingController(text: teacherDetails?.dateofemployment??'');
  
    });
  }

  @override
  void dispose() {
    experienceController.dispose();
    firstNameController.dispose();
    degreeController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    homeAddressController.dispose();
    subjectHandlingController.dispose();
    emplymentDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     if (teacherDetails == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.green,));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Row(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customIconNavigation(context, '/manage-teacher/viewTeacherDetails'),
            
      
            Column(
                      mainAxisAlignment: MainAxisAlignment.start,
               children: [
                    const SizedBox(height: 30,),
              
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width:320,
                        height: 500,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          image:  DecorationImage(
                            image: NetworkImage(assetImage!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ), Positioned(
            bottom: 0,
            right: 0,
            child: customIconTextButton(Colors.red, onPressed: ()async{
            await handlePhotoUpdate(teacherDetails!.id);
              
            }, icon: Icons.edit, text: "change")
          ),
                    ],
                  ),
                ),
               SizedBox(
  height:MediaQuery.sizeOf(context).height*0.3,

                      ),
                    ],)
              ],
            ),
          
                const SizedBox(
                      width: 20,
                    ),
            Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: 700,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      // Background container with school logo
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCustomRow("Teacher Name", firstNameController),
                            const SizedBox(height: 8),
                            _buildCustomRow("Graduated Degree", degreeController),
                            const SizedBox(height: 8),
                            _buildCustomRow("year of Experience", experienceController),
                            const SizedBox(height: 8),
                            _buildCustomRow("Employment Date", emplymentDateController),
                          
                            const SizedBox(height: 8),
                            _buildCustomRow("Phone Number", phoneNumberController),
                            const SizedBox(height: 8),
                            _buildCustomRow("Subject handling", subjectHandlingController),
                            const SizedBox(height: 8),
                            _buildCustomRow("Email", emailController),
                            const SizedBox(height: 8),
                            _buildCustomRow("Home Address", homeAddressController, maxLines: 2),
                            
                          
                            
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
            
                      // Action Buttons (Edit and Download)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Edit/Save Button
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async{
                                if (isEdited) {
                                   CustomDialogs().showLoadingDialogInSec(context,10,"Please wait a moment ...", onlyText: false);
  
                     
                  // ignore: use_build_context_synchronously
                await ExceptionDialog().handleExceptionDialog(context, ()async=>await controller.updateTeacherDetails(context,
                    teacherAddress: homeAddressController.text.toString(),
                    teacherSubjectHandling: subjectHandlingController.text.toString(),
                     teacherEmail: emailController.text.toString(),
                     teacherName: firstNameController.text.toUpperCase(),
                     teacherProfile: assetImage??'',
                    userId: widget.uid, 
                   collegedegree: degreeController.text.toString(),
                   dateofemployment: dateofEmploymentfield,
                   role: 'Teacher',
                   teacherPhoneNumber: phoneNumberController.text.toString(),
                   yearofexperience: experienceController.text.toString()
                   ));
                   if(!context.mounted)return;
                   if(!context.mounted)return;
     if (Navigator.of(context, rootNavigator: true).canPop()) {
     Navigator.of(context, rootNavigator: true).pop();
}     await CustomDialogs().showCustomDialog(context, "✅ Teacher details Updated Succecfully");
                                  setState(() {
                                    isEdited = false;
                                  });
                                    }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: isEdited ? Colors.blue : Colors.grey,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              ),
                              child: Text(isEdited ? 'Save' : 'Edit'
                              ,  style: const TextStyle(color: Colors.white, fontSize:  16, fontWeight: FontWeight.bold),
                                
                              
                              ),
                            ),
                          ),
                          // Download Button
                          SizedBox(height: 50,
                            child: ElevatedButton(
                              onPressed: ()async {
                           
                   if(!context.mounted)return;
                                 await PdfTeacherDetails().openPdf(context: context,fileName:  firstNameController.text.toString(), nameController: firstNameController, 
                                 employmentDate: emplymentDateController, degreeController: degreeController,assetImage: assetImage,
                                 phoneNumberController: phoneNumberController, dateOfBirthController: subjectHandlingController, 
                                 emailController: emailController, homeAddressController: homeAddressController, yearofExperience: experienceController, subjectHandling: subjectHandlingController);
                               },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: primaryGreenColors,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              ),
                              child: const Text(
                                'Download',        style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      
            
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom row builder for label and editable value
  Widget _buildCustomRow(String labelText, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: Text(
              labelText,
              style:  TextStyle(color: primaryGreenColors, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            flex: 7,
            child: TextField(cursorColor :primaryGreenColors,
             style: const TextStyle( color: Colors.black),
           
              controller: controller,
              decoration: InputDecoration(border:  OutlineInputBorder( 
                
                  borderRadius: BorderRadius.circular(8.0),
                borderSide:  BorderSide(color: primaryGreenColors),
              ),
              focusedBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: primaryGreenColors),
              ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
               
              ),
              maxLines: maxLines,
              onChanged: (value) {
                setState(() {
                  isEdited = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
