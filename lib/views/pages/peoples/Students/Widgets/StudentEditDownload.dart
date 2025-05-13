
import 'package:admin_pannel/contant/constant.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/StudentController.dart';
import 'package:admin_pannel/modules/studentModels.dart';
import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/contant/pdfApi/PdfStudent/PdfStudentDetails.dart';
import 'package:admin_pannel/views/widget/CustomDialogBox.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst;

class StudentEditDownload extends StatefulWidget {
  final String uid;
  const StudentEditDownload({super.key, required this.uid});

  @override 
  _StudentEditDownloadState createState() => _StudentEditDownloadState();
}

class _StudentEditDownloadState extends State<StudentEditDownload> {
  late TextEditingController studentNameController;
  late TextEditingController fatherNameController;
  late TextEditingController motherNameController;
  late TextEditingController fatherPhoneNumberController;
  late TextEditingController motherPhoneNumberController;
  late TextEditingController emailController;
  late TextEditingController homeAddressController;
  late TextEditingController dobController;
  late TextEditingController studentClassController;
  late TextEditingController sectionController;
  late TextEditingController rollNumberController;
  late TextEditingController totalFeesController;
  late TextEditingController pendingFeesController;
  
  StudentdetailsModel? studentDetails;
  bool isEdited = false;
  late StudentController controller ;
  String? assetImage;

  @override
  void initState() {
    super.initState();
    controller = Get.find<StudentController>();
    initializeFunction(); // Fetch student data asynchronously
  }


Future<void> handlePhotoUpdate(String studentId) async {
  String newPhotoUrl = await  controller.updateStudentPhoto(studentId );
  
  if (newPhotoUrl.isNotEmpty) { 
    setState(() {
      assetImage = newPhotoUrl; // Update UI with new photo URL
    });
  }
}
Future<void> initializeFunction() async {
  
    studentDetails = await controller.studentDataRead(uid: widget.uid);

    if (studentDetails == null) {
      return;
    }

    String? photoUrl = await controller.getStudentPhotoUrl(studentDetails!.stdentId);
    
    setState(() {
      assetImage = photoUrl ?? studentDetails?.profilePhot;
      studentNameController = TextEditingController(text: studentDetails?.studentName ?? '');
      fatherNameController = TextEditingController(text: studentDetails?.fatherName ?? '');
      motherNameController = TextEditingController(text: studentDetails?.motherName ?? '');
      fatherPhoneNumberController = TextEditingController(text: studentDetails?.fatherPhone ?? '');
      motherPhoneNumberController = TextEditingController(text: studentDetails?.motherPhoneNo ?? '');
      emailController = TextEditingController(text: studentDetails?.studentEmail ?? '');
      homeAddressController = TextEditingController(text: studentDetails?.address ?? '');
      dobController = TextEditingController(text: studentDetails?.dob ?? '');
      studentClassController = TextEditingController(text: studentDetails?.studentClass ?? '');
      sectionController = TextEditingController(text: studentDetails?.studentSection ?? '');
      totalFeesController = TextEditingController(text: studentDetails?.allFees ?? '');
      pendingFeesController = TextEditingController(text: studentDetails?.feesStatus ?? '');
      rollNumberController = TextEditingController(text: studentDetails?.rollNo ?? '');
    });
  
}

  @override
  void dispose() {
    studentNameController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    fatherPhoneNumberController.dispose();
    motherPhoneNumberController.dispose();
    emailController.dispose();
    homeAddressController.dispose();
    dobController.dispose();
    studentClassController.dispose();
    sectionController.dispose();
    rollNumberController.dispose();
    totalFeesController.dispose();
    pendingFeesController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (studentDetails == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.green,));
    }


    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Row(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start,
            
              children: [
                
                customIconNavigation(context,'/manage-student/viewStudentDetails'),
              
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
                child: customIconTextButton(Colors.red, onPressed: () async {
  
  await handlePhotoUpdate(studentDetails!.stdentId);
  }, icon: Icons.edit, text: "Change")
                        ), 
                        ],
                      ),
                    ),
                   
                        SizedBox(
                      height:MediaQuery.sizeOf(context).height*0.5,

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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCustomRow("Student Name", studentNameController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Class", studentClassController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Section", sectionController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Roll Number",rollNumberController ),
                            const SizedBox(height: 5),
                            _buildCustomRow("Father's Name", fatherNameController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Father Phone.No", fatherPhoneNumberController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Mother's Name", motherNameController),
                            const SizedBox(height: 5), 
                            _buildCustomRow("Mother Phone.No", motherPhoneNumberController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Date of Birth", dobController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Email", emailController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Home Address", homeAddressController, maxLines: 2),
                            const SizedBox(height: 5),
                            _buildCustomRow("Total Fees", totalFeesController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Fees Status", pendingFeesController),
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
                              onPressed: ()async {
                                if (isEdited) {
                     await showCustomDialog(context, "Student details Updated Succecfully");
                    String name = studentNameController.text.toUpperCase();
                     
                  bool isUpdated = await controller.updateStudentDetails(
                    address: homeAddressController.text.toString(),
                    dob: dobController.text.toString(),
                     email: emailController.text.toString(),
                     fatherName: fatherNameController.text.toString(),
                     fatherNumber: fatherPhoneNumberController.text.toString(),
                     feesStatus: pendingFeesController.text.toString(),
                     motherName:motherNameController.text.toString() ,
                     motherNumber: motherPhoneNumberController.text.toString(),
                     name: name,
                     profilePhotoUrl: assetImage??'',
                     section: sectionController.text.toUpperCase(). toString(),
                     studentClass: studentClassController.text.toString(),
                     totalFee: totalFeesController.text.toString(),
                     uid: widget.uid, 
                     rollNo: rollNumberController.text.toString(),
                   );
                   if(isUpdated) await customSnackbar(context: context, text: "Student Detials Changed updated succesfully");
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
                              child: Text(isEdited ? 'Save' : 'Edit',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              
                              ),
                            ),
                          ),
                           // Download Button
                          SizedBox(height: 50,
                            child: ElevatedButton(
                              onPressed: ()async {
                              await   customSnackbar(context: context, text: "Donloaded Succesfully");
                               await  PdfStudentDetails().openPdf(fileName: studentNameController.text, nameController: studentNameController, 
                               classController: studentClassController, sectionController: sectionController, 
                               fatherNameController: fatherNameController, fatherPhoneController: fatherPhoneNumberController, motherNameController: motherNameController,
                                motherPhoneController: motherPhoneNumberController, dateOfBirthController: dobController, emailController: emailController, homeAddressController: homeAddressController,
                                 totalFeesController: totalFeesController, pendingFeesController: pendingFeesController,assetImage: assetImage,);
                                   },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:primaryGreenColors ,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              ),
                              child: const Text(
                                'Download',
                                style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold),
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

