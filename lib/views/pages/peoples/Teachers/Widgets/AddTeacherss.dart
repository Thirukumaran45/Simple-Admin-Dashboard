
// ignore_for_file: use_build_context_synchronously

import 'package:admin_pannel/utils/ExceptionDialod.dart';
import '../../../../../controller/classControllers/peoplesControlelr/TeacherController.dart';
import '../../widgets/CustomeTextField.dart';
import '../../../../../contant/CustomNavigation.dart';
import '../../../../widget/CustomDialogBox.dart';
import '../../../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' show Get,Inst;
import 'package:intl/intl.dart';

class AddTeacherTab extends StatefulWidget {
  const AddTeacherTab({super.key});
  
  @override
  State<AddTeacherTab> createState() => _AddTeacherTabState();
}

class _AddTeacherTabState extends State<AddTeacherTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic updatePhotoUrl;
  final bool _isPasswordObscured = true;
  late final TextEditingController addresscontrl ;
  late final TextEditingController _empDateController ;
  late final TextEditingController firstNameController ;
  late final TextEditingController lastNameController ;
  late final TextEditingController yearOfExperienceController ;
  late final TextEditingController graduateDegreeController ;
  late final TextEditingController teacherMobileController ;
  late final TextEditingController emailController ;
  late final TextEditingController passwordController;
  late Teachercontroller controller ;

  @override
  void initState() {
    super.initState();
    controller = Get.find<Teachercontroller>();
   addresscontrl = TextEditingController();
   _empDateController = TextEditingController();
   firstNameController = TextEditingController();
   lastNameController = TextEditingController();
   yearOfExperienceController = TextEditingController();
   graduateDegreeController = TextEditingController();
   teacherMobileController = TextEditingController();
   emailController = TextEditingController();
   passwordController= TextEditingController();

  }
Future<void> profileFuntion() async {
  final pickedImage = await ExceptionDialog().handleExceptionDialog(context, ()async=> await controller. addPhoto(context));
  if (pickedImage != null&&mounted) {
    setState(() {
      updatePhotoUrl = pickedImage;
    });
  }
}

@override
  void dispose() {

   addresscontrl .dispose();
   _empDateController .dispose();
   firstNameController .dispose();
   lastNameController .dispose();
   yearOfExperienceController .dispose();
   graduateDegreeController .dispose();
   teacherMobileController .dispose();
   emailController .dispose();
   passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15),
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
                          
          customIconNavigation(context, '/manage-teacher'),
          const SizedBox(width: 10,),
                          buildProfilePicker(
                            image: updatePhotoUrl,
                            onPress: profileFuntion
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      buildTextFieldRow([
                        buildTextField('Teacher First Name', 'Enter first name',
                            TextInputType.text, (value) {
                          if (value == null || value.isEmpty) {
                            return 'First name is required';
                          }
                          return null;
                        } , controller: firstNameController ),
                        buildTextField('Teacher Last Name', 'Enter last name',
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
                            'Graduated Degree',
                            'Enter Completed Degree course name',
                            TextInputType.text, (value) {
                          if (value == null || value.isEmpty) {
                            return 'Graduated Degree is required';
                          }
                          return null;
                        }, controller:graduateDegreeController ),
                        buildTextField(
                          'Year of Experience',
                          'Enter your experience (up to 2 digits)',
                          TextInputType.number,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Class name is required';
                            } else if (!RegExp(r'^\d{1,2}$').hasMatch(value)) {
                              return 'Enter a valid class (1-2 digits)';
                            }
                            return null;
                          },
                          controller: yearOfExperienceController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2)
                          ], // Maximum length is 2
                        ),
                        buildTextField(
                          'Teacher Mobile',
                          'Enter mobile number',
                          TextInputType.number,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mobile number is required';
                            } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                              return 'Enter a valid 10-digit number';
                            }
                            return null;
                          },
                          controller: teacherMobileController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter
                                .digitsOnly, // Only allow digits
                          ],
                        ),
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
                        buildPasswordField(isPasswordObscured: _isPasswordObscured, passwordController: passwordController),
                      ]),
                      const SizedBox(height: 30),
                      buildTextFieldRow([
                        buildTextField(
                          'Employment Date',
                          'Select start date of employment',
                          TextInputType.datetime,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Date of birth is required';
                            }
                            return null;
                          },
                          controller: _empDateController,
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
                              _empDateController.text =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                            }
                          },
                        ),
                     
                      ]),
                      const SizedBox(height: 30),
                      buildAddressField(addressContrl: addresscontrl),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () async{
                            if (_formKey.currentState?.validate() ?? false) {
                    
        
  if(updatePhotoUrl!=null)
  {
    bool val = await CustomDialogs().showCustomConfirmDialog(context: context, text: 'Are you sure about to add the teacher ?');
     if(val)
     {
         if(!context.mounted)return;
  
  CustomDialogs().showLoadingDialogInSec(context, 10,"Creating teacher profile, please wait a moment !");
  
     String name = '${firstNameController.text} ${lastNameController.text}';
                if(!context.mounted)return;
      await ExceptionDialog().handleExceptionDialog(context, ()async=>await  controller.registerTeacher(
   password: passwordController.text,
   updatePhotoUrl: updatePhotoUrl,
    context: context,
   collegedegree: graduateDegreeController.text,
   dateofemployment: _empDateController.text,
   role: 'Teacher',
   teacherAddress: addresscontrl.text,
   teacherEmail: emailController.text,
   teacherName: name.toUpperCase(),
   teacherPhoneNumber: teacherMobileController.text,
   teacherSubjectHandling: "",
   yearofexperience: yearOfExperienceController.text
  ));
                if(!context.mounted)return;
   await ExceptionDialog().handleExceptionDialog(context, ()async=>await controller.updateNumberOfTeacher(context,true));
   customPopNavigation(context, '/manage-teacher');
  
     }
      else
  {
  
    if(!context.mounted) return;
    await CustomDialogs().showCustomDialog(context, "Please pick profile photo for the person ❓ ");
  }
  
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
                            'Add Teacher',
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
    );
  }
}
