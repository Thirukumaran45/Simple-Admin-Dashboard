import 'package:admin_pannel/FireBaseServices/FirebaseAuth.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/StudentController.dart';
import 'package:admin_pannel/views/pages/peoples/widgets/CustomeTextField.dart';
import 'package:admin_pannel/contant/CustomNavigation.dart';
import '../../../../widget/CustomDialogBox.dart' show showCustomConfirmDialog, showCustomDialog, showLoadingDialogInSec;
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' show Get,Inst;
import 'package:intl/intl.dart';

class AddStudentTab extends StatefulWidget {
  const AddStudentTab({super.key}); 

  @override
  State<AddStudentTab> createState() => _AddStudentTabState();
}

class _AddStudentTabState extends State<AddStudentTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? assetImage;
  dynamic updatePhotoUrl;
  final bool _isPasswordObscured = true;
  late FirebaseAuthUser authControlelr ;
  
  late final TextEditingController _dobController ;
  late final TextEditingController addresscontrl ;
  late final TextEditingController firstNameController ;
  late final TextEditingController lastNameController ;
  late final TextEditingController classNameController ;
  late final TextEditingController sectionController ;
  late final TextEditingController rollNumberController ;
  late final TextEditingController emailController ;
  late final TextEditingController passwordController ;
  late final TextEditingController admissionNumberController ;
late final TextEditingController fatherNameController ;
late final TextEditingController fatherMobileController ;
late final TextEditingController motherNameController ;
late final TextEditingController motherMobileController ; 
late StudentController controller ;

@override
  void initState() {
    controller = Get.find<StudentController>();
    authControlelr = Get.find<FirebaseAuthUser>();
          _dobController = TextEditingController();
   addresscontrl = TextEditingController();
   firstNameController = TextEditingController();
   lastNameController = TextEditingController();
   classNameController = TextEditingController();
   sectionController = TextEditingController();
   rollNumberController = TextEditingController();
   emailController = TextEditingController();
   passwordController = TextEditingController();
   admissionNumberController = TextEditingController();
 fatherNameController = TextEditingController();
 fatherMobileController = TextEditingController();
 motherNameController = TextEditingController();
 motherMobileController = TextEditingController();
    super.initState();
  }
Future<void> profileFuntion() async {
  final pickedImage = await controller. addPhoto();
  if (pickedImage != null &&mounted) {
    setState(() {
      updatePhotoUrl = pickedImage;
    });
  }
}


@override
  void dispose() {
       _dobController .dispose();
   addresscontrl .dispose();
   firstNameController .dispose();
   lastNameController .dispose();
   classNameController .dispose();
   sectionController .dispose();
   rollNumberController .dispose();
   emailController .dispose();
   passwordController .dispose();
   admissionNumberController .dispose();
 fatherNameController .dispose();
 fatherMobileController .dispose();
 motherNameController .dispose();
 motherMobileController .dispose();
    super.dispose();
 
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: 
          Column(
            children: [
              Expanded(
                flex: 1, 
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 10,
                                color: Colors.grey,
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                
                                customIconNavigation(context, '/manage-student'),
                            const    SizedBox( width: 10,),
                              buildProfilePicker(
                           image: updatePhotoUrl, 
                           onPress: profileFuntion,
                          ),

                              ],
                            ),
                            const SizedBox(height: 40),
                            buildTextFieldRow([
                              buildTextField('Student First Name', 'Enter first name',
                                  TextInputType.text, (value) {
                                if (value == null || value.isEmpty) {
                                  return 'First name is required';
                                }
                                return null;
                              }, controller: firstNameController),
                              buildTextField('Student Last Name', 'Enter last name',
                                  TextInputType.text, (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Last name is required';
                                }
                                return null;
                              }, controller: lastNameController),
                            ]),
                            const SizedBox(height: 30),
                            buildTextFieldRow([
                              buildTextField(
                                'Class Name',
                                'Enter class (up to 2 digits)',
                                TextInputType.number,
                                (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Class name is required';
                                  } else if (!RegExp(r'^\d{1,2}$').hasMatch(value)) {
                                    return 'Enter a valid class (1-2 digits)';
                                  }
                                  return null;
                                },
                                controller: classNameController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(2)
                                ], // Maximum length is 2
                              ),
                              buildTextField(
                                'Section',
                                'Enter section (1 letter)',
                                TextInputType.text,
                                (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Section is required';
                                  } else if (!RegExp(r'^[A-Za-z]{1}$').hasMatch(value)) {
                                    return 'Enter a valid section (1 letter)';
                                  }
                                  return null;
                                },
                                controller: sectionController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1)
                                ], // Maximum length is 1
                              ),
                              buildTextField('Roll Number', 'Enter roll number',
                                  TextInputType.number, (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Roll number is required';
                                }
                                return null;
                              }, controller: rollNumberController),
                            ]),
                            const SizedBox(height: 30),
                            buildTextFieldRow([
                              buildTextField(
                                  'Email', 'Enter email', TextInputType.emailAddress,
                                  (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                } else if (!RegExp(
                                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              }, controller: emailController),
                              buildPasswordField(isPasswordObscured: _isPasswordObscured, passwordController: passwordController  ),
                            ]),
                            const SizedBox(height: 30),
                            buildTextFieldRow([
                              buildTextField(
                                'Date of Birth',
                                'Select date of birth',
                                TextInputType.datetime,
                                (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Date of birth is required';
                                  }
                                  return null;
                                },
                                controller: _dobController,
                                onTap: () async {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: Colors.green, // Selection color
                                            onPrimary:
                                                Colors.white, // Text color on selection
                                            onSurface: Colors.black, // Default text color
                                          ), dialogTheme: const DialogThemeData(backgroundColor: Colors.white), // Background color
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedDate != null) {
                                    _dobController.text =
                                        DateFormat('dd-MM-yyyy').format(pickedDate);
                                  }
                                },
                              ),
                              buildTextField('Student Admission Number',
                                  'Enter Admission No*', TextInputType.text, (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Admisson Number is required';
                                }
                                return null;
                              }, controller: admissionNumberController),
                            ]),
                            const SizedBox(height: 30),
                            buildParentDetailsRow(fatherNameController: fatherNameController,fatherMobileController: fatherMobileController
                           , motherMobileController: motherMobileController, motherNameController: motherNameController),
                            const SizedBox(height: 30),
                            buildAddressField(addressContrl: addresscontrl),
                            const SizedBox(height: 30),
                            Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                               onPressed: ()async {
  if (_formKey.currentState?.validate() ?? false) {
       
 
   if(updatePhotoUrl!=null)
   {
    bool val = await showCustomConfirmDialog(context: context, text: 'Are you sure about to add the student');
   if(val)
   {
     showLoadingDialogInSec(context, 10);

     final user = await authControlelr.createUser(email: emailController.text,password: passwordController.text, context: context);
   String userId = user!.id;
   final url = await controller.photoStorage(image: updatePhotoUrl,userId: userId);
   String name = '${firstNameController.text} ${lastNameController.text}';
await  controller.registerUser(
   userId: userId,
     context: context,
     stuAddress: addresscontrl.text,
     stuAdminNo: admissionNumberController.text,
     stuClass: classNameController.text,
     stuDob: _dobController.text,
     stuEmail: emailController.text,
     stuSection: sectionController.text.toUpperCase(),
     studentName: name.toUpperCase() ,
     stufatherName: fatherNameController.text,
     stufatherNo: fatherMobileController.text,
     stumotherName: motherNameController.text,
     stumotherNo: motherMobileController.text,
     sturollNo: rollNumberController.text, stupicUrl: url
  
   );
   await controller.updateNumberOfStudent(true);
   
    customPopNavigation(context, '/manage-student');
   }
   }
 else
     {

  if(!context.mounted) return;
  await showCustomDialog(context, "Please pick profile photo for the person !");
     }



  }
},

                                style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:primaryGreenColors,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 35,
                                    vertical: 20,
                                  ),
                                ),
                                child: const Text(
                                  'Add Student',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
