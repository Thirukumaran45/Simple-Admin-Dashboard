
import 'package:admin_pannel/utils/ExceptionDialod.dart';
import '../../../../../controller/classControllers/peoplesControlelr/StafffController.dart';
import '../../../../../modules/staffModels.dart';
import '../../../../../contant/CustomNavigation.dart';
import '../../../../../contant/pdfApi/PdfStaff/pdfStaffDetails.dart';
import '../../../../widget/CustomDialogBox.dart';
import '../../../../widget/CustomeButton.dart';
import '../../../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst;

class StaffEditDownload extends StatefulWidget {
  final String uid;
  const StaffEditDownload({super.key, required this. uid});
 
  @override
  _StudentEditDownloadState createState() => _StudentEditDownloadState();
}

class _StudentEditDownloadState extends State<StaffEditDownload> {
  // Sample data for the student (using TextEditingController for editable fields)
late TextEditingController firstNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController homeAddressController;
  late TextEditingController role;
  String? assetImage;
  bool isEdited = false;
  Stafffdetailsmodel? teacherDetails;
 late StaffController controller;


  @override
  void initState() {
    super.initState();
     controller = Get.find<StaffController>();
    initializeFunction();
    }
Future<void> handlePhotoUpdate(String studentId) async {
  String? newPhotoUrl =  await ExceptionDialog().handleExceptionDialog(context, ()async=>await  controller.updateStaffsPhoto(context,studentId ));
  
  if (newPhotoUrl!.isNotEmpty) { 
    setState(() {
      assetImage = newPhotoUrl; // Update UI with new photo URL
    });
  }
}


  Future<void>initializeFunction()async{
  teacherDetails =  await ExceptionDialog().handleExceptionDialog(context, ()async=>await controller.staffDataRead(context,uid: widget.uid));
   if (teacherDetails == null) {
      return;
    }

    // ignore: use_build_context_synchronously
    String? photoUrl =  await ExceptionDialog().handleExceptionDialog(context, ()async=>await controller.getStaffsPhotoUrl(context,teacherDetails!.Id));
    
    setState(() {
       assetImage = photoUrl ?? teacherDetails?.staffProfile;
       role = TextEditingController(text: teacherDetails?.role??'');
    firstNameController = TextEditingController(text:teacherDetails?.staffName??'');
   phoneNumberController = TextEditingController(text:teacherDetails?.staffPhoneNumber??'');
    emailController = TextEditingController(text: teacherDetails?.staffEmail??'');
    homeAddressController = TextEditingController(text: teacherDetails?.staffAddress??'');
   
    });
  }


@override
void dispose() {
  firstNameController.dispose();
  phoneNumberController.dispose();
  emailController.dispose();
  homeAddressController.dispose();
  role.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
     if (teacherDetails == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.green,));
    }
    return SingleChildScrollView(
      child: Row(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
              customIconNavigation(context, '/manage-working-staff/viewStaffDetails'),
        
                    
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                       children: [
          
                    const SizedBox(
                      height: 30,
                    ),
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
                  child:  customIconTextButton(Colors.red, onPressed: ()async{
            await handlePhotoUpdate(teacherDetails!.Id);
                 
                  }, icon: Icons.edit, text: "Change")
                ),
                    ],
                       ),
                      ),
              
                   
                    ],
                    
          ),
                ],
              ),
                const SizedBox(
                      width: 20,
                    ),
          Material(
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                     
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCustomRow("Staff Name", firstNameController),
                      
                        const SizedBox(height: 8),
                        _buildCustomRow("Phone Number", phoneNumberController),
                        const SizedBox(height: 8),
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
     await ExceptionDialog().handleExceptionDialog(context, ()async=> await controller.updateStaffDetails(context,
                    staffAddress: homeAddressController.text.toString(),
                     staffEmail: emailController.text.toString(),
                     staffName: firstNameController.text.toUpperCase(),
                     staffProfile: assetImage??'',
                    userId: widget.uid, 
                   staffrole: role.text,
                   staffPhoneNumber: phoneNumberController.text.toString(),
                   ));
                    if(!context.mounted)return;
     if (Navigator.of(context, rootNavigator: true).canPop()) {
     Navigator.of(context, rootNavigator: true).pop();
} await CustomDialogs().showCustomDialog(context, "✅ Staff details Updated Succecfully");
      
                   setState(() {
                                isEdited = false;
                              });   }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: isEdited ? Colors.blue : Colors.grey,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: Text(isEdited ? 'Save' : 'Edit'
                          ,  style: const TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                          
                          ),
                        ),
                      ),
                      // Download Button
                      SizedBox(height: 50,
                        child: ElevatedButton(
                          onPressed: ()async {
                   if(!context.mounted)return;
                         await PdfStaffDetails().openPdf(context: context,fileName: firstNameController.text, 
                         nameController: firstNameController, phoneNumberController: phoneNumberController, emailController: emailController,
                          homeAddressController: homeAddressController,assetImage: assetImage, role: role);
                          },
                          style: ElevatedButton.styleFrom(
                         
                            foregroundColor: Colors.white,
                            backgroundColor: primaryGreenColors,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: const  Text(
                            'Download',  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16, ),
                    
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
