
import 'package:admin_pannel/utils/ExceptionDialod.dart';

import '../../../../../services/FireBaseServices/FirebaseAuth.dart';
import '../../../../../controller/classControllers/peoplesControlelr/StafffController.dart';
import '../../widgets/CustomeTextField.dart';
import '../../../../../contant/CustomNavigation.dart';
import '../../../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import '../../../../widget/CustomDialogBox.dart' ;
import 'package:flutter/services.dart';
import 'package:get/get.dart' show Get,Inst;

class AddStaffTab extends StatefulWidget {
  const AddStaffTab({super.key});

  @override 
  State<AddStaffTab> createState() => _AddStaffTabState();
} 

class _AddStaffTabState extends State<AddStaffTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 dynamic updatePhotoUrl;
  final bool _isPasswordObscured = true;
  late FirebaseAuthUser authControlelr ;
  late final TextEditingController addresscontrl ;
  late final TextEditingController firstNameController ;
  late final TextEditingController lastNameController ;
  late final TextEditingController officialMobileController ;
  late final TextEditingController emailController ;
  late final TextEditingController passwordController;
  late StaffController controller ;
@override
  void initState() {
    super.initState();
    authControlelr =Get.find<FirebaseAuthUser>();
 controller = Get.find<StaffController>();
   addresscontrl = TextEditingController();
   firstNameController = TextEditingController();
   lastNameController = TextEditingController();
   officialMobileController = TextEditingController();
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
   firstNameController .dispose();
   lastNameController .dispose();
   officialMobileController .dispose();
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
                          
          customIconNavigation(context, '/manage-working-staff'),
               const   SizedBox(width: 10,),
                           buildProfilePicker(
                            image: updatePhotoUrl,
                            onPress: profileFuntion
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      buildTextFieldRow([
                        buildTextField('Staff First Name', 'Enter first name',
                            TextInputType.text, (value) {
                          if (value == null || value.isEmpty) {
                            return 'First name is required';
                          }
                          return null;
                        }, controller: firstNameController),
                        buildTextField('Staff Last Name', 'Enter last name',
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
                          'Staff Mobile',
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly,
                          ],controller: officialMobileController
                        ),

                      buildAddressField(addressContrl: addresscontrl),
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
                        buildPasswordField(
                          passwordController: passwordController,
                          isPasswordObscured: _isPasswordObscured),
                      ]),
                      const SizedBox(height: 30),
                  
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () async{
                            if (_formKey.currentState?.validate() ?? false) {
                             
 
       
     if(updatePhotoUrl!=null)
     {
       bool val = await CustomDialogs().showCustomConfirmDialog(context: context, text: 'Are you sure about to add the person ?');
     if(val)
     {
     if(!context.mounted)return;
      CustomDialogs().showLoadingDialogInSec(context, 10);
     final user = await ExceptionDialog().handleExceptionDialog(context, ()async=> await authControlelr.createUser(email: emailController.text,password: passwordController.text, context: context));
     String userId = user!.id;
     // ignore: use_build_context_synchronously
     final url = await ExceptionDialog().handleExceptionDialog(context, ()async=> await controller.photoStorage(context,image: updatePhotoUrl,userId: userId));   String name = '${firstNameController.text} ${lastNameController.text}';
  if(!context.mounted)return;
  await ExceptionDialog().handleExceptionDialog(context, ()async=> await  controller.registerStaffs(
     userId: userId,
       context: context,
     staffAddress: addresscontrl.text,
    staffEmail: emailController.text,
    staffName: name.toUpperCase(),
    staffPhoneNumber: officialMobileController.text,
    staffProfile: url!,
    staffrole: "Staff",

     ));
      if(!context.mounted)return;
     await ExceptionDialog().handleExceptionDialog(context, ()async=> await controller.updateNumberOfStaffs(context,true));
      
      // ignore: use_build_context_synchronously
      customPopNavigation(context, '/manage-working-staff');
     }
     }
     else 
     {

  if(!context.mounted) return;
  await CustomDialogs().showCustomDialog(context, "Please pick profile photo for the person !");
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
                            'Add Staff',
                            style: TextStyle(
                              fontSize: 16,
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