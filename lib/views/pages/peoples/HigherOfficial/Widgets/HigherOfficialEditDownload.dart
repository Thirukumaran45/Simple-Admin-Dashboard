
import 'package:admin_pannel/utils/ExceptionDialod.dart';
import '../../../../../controller/classControllers/peoplesControlelr/HigherOfficialController.dart';
import '../../../../../modules/higherOfficialModels.dart';
import '../../../../../contant/CustomNavigation.dart';
import '../../../../../contant/pdfApi/PdfOfficial/pdfOfficialDetails.dart';
import '../../../../widget/CustomDialogBox.dart';
import '../../../../widget/CustomeButton.dart';
import '../../../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst;

class HigherOfficialEditDownload extends StatefulWidget {
final String uid;
  const HigherOfficialEditDownload({super.key, required this. uid});
 
  @override
  _StudentEditDownloadState createState() => _StudentEditDownloadState();
}

class _StudentEditDownloadState extends State<HigherOfficialEditDownload> {
  // Sample data for the student (using TextEditingController for editable fields)
  late TextEditingController firstNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController homeAddressController;
  late TextEditingController role;
 String? assetImage;
  bool isEdited = false;
  Principaldetailmodel? teacherDetails;
  late Higherofficialcontroller controller ;



  @override
  void initState() {
    super.initState();
    controller = Get.find<Higherofficialcontroller>();
    initializeFunction();
   }

Future<void> handlePhotoUpdate(String studentId) async {
  final newPhotoUrl = await ExceptionDialog().handleExceptionDialog(context, ()async=> await  controller.updateOfficialsPhoto(context,studentId));
  
  if (newPhotoUrl!.isNotEmpty) { 
    setState(() {
      assetImage = newPhotoUrl; // Update UI with new photo URL
    });
  }
}
  Future<void>initializeFunction()async{
  teacherDetails =  await ExceptionDialog().handleExceptionDialog(context, ()async=> await controller.officialDataRead(context,uid: widget.uid));
   if (teacherDetails == null) {
      return;
    }

    // ignore: use_build_context_synchronously
    String? photoUrl = await ExceptionDialog().handleExceptionDialog(context, ()async=> await controller.getOfficialsPhotoUrl(context,teacherDetails!.Id));
    
    setState(() {
       assetImage = photoUrl ?? teacherDetails?.principalProfile;
       role = TextEditingController(text: teacherDetails?.role??'');
    firstNameController = TextEditingController(text:teacherDetails?.principalName??'');
   phoneNumberController = TextEditingController(text:teacherDetails?.principalPhoneNumber??'');
    emailController = TextEditingController(text: teacherDetails?.principalEmail??'');
    homeAddressController = TextEditingController(text: teacherDetails?.principalAddress??'');
   
    });
  }

  @override
  void dispose() {
    role.dispose();
    firstNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    homeAddressController.dispose();
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
                customIconNavigation(context, '/manage-higher-official/viewHigherOfficailDetails'),
            
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
            await handlePhotoUpdate(teacherDetails!.Id);
            
            }, icon: Icons.edit, text: "Change")
          ),
                    ],
                  ),
                ),
                 SizedBox(
                      height:MediaQuery.sizeOf(context).height*0.1,

                    ), 
              ],
            ),
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
                            _buildCustomRow("Higher Official Name", firstNameController),                          
                            const SizedBox(height: 8),
                            _buildCustomRow("Phone Number", phoneNumberController),
                            const SizedBox(height: 8),
                            _buildCustomRow("Acting role", role),
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
                           await ExceptionDialog().handleExceptionDialog(context, ()async=> await controller.updateOfficialDetails(context,
                    principalAddress: homeAddressController.text.toString(),
                     principalEmail: emailController.text.toString(),
                     principalName: firstNameController.text.toUpperCase(),
                     principalProfile: assetImage??'',
                    userId: widget.uid, 
                   principalRole: role.text,
                   principalPhoneNumber: phoneNumberController.text.toString(),
                   ));
                   if(!context.mounted)return;
     if (Navigator.of(context, rootNavigator: true).canPop()) {
     Navigator.of(context, rootNavigator: true).pop();
}  await CustomDialogs().showCustomDialog(context, "✅ Higher official details Updated Succecfully");
      
                   
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
                              ,  style:  const TextStyle(color: Colors.white, fontSize: 16, fontWeight:FontWeight.bold ),
                              
                              ),
                            ),
                          ),
                          // Download Button
                          SizedBox(height: 50,
                            child: ElevatedButton(
                              onPressed: ()async {
                                 if(!context.mounted)return;

                                   await PdfOfficialsDetails().openPdf(context: context,fileName: firstNameController.text, nameController: firstNameController,
                                  phoneNumberController: phoneNumberController, 
                                     emailController: emailController,
                                    homeAddressController: homeAddressController, roleController: role, assetImage: assetImage);
                                },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: primaryGreenColors,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              ),
                              child: const Text(
                                'Download', style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                  
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
