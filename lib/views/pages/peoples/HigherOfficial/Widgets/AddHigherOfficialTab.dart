
// ignore_for_file: use_build_context_synchronously

import 'package:admin_pannel/utils/ExceptionDialod.dart';
import '../../../../../controller/classControllers/peoplesControlelr/HigherOfficialController.dart';
import '../../widgets/CustomeTextField.dart';
import '../../../../../contant/CustomNavigation.dart';
import '../../../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' show Get,Inst;
import '../../../../widget/CustomDialogBox.dart' ;
class AddHigherOfficialTab extends StatefulWidget {
  const AddHigherOfficialTab({super.key});

  @override
  State<AddHigherOfficialTab> createState() => _AddHigherOfficialTabState();
}

class _AddHigherOfficialTabState extends State<AddHigherOfficialTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic updatePhotoUrl;
  final bool _isPasswordObscured = true;
  late final TextEditingController addresscontrl ;
  late final TextEditingController firstNameController ;
  late final TextEditingController lastNameController ;
  late final TextEditingController officialMobileController ;
  late final TextEditingController emailController ;
  late final TextEditingController passwordController;
  late Higherofficialcontroller controller ;
@override
  void initState() {
    super.initState();
   controller = Get.find<Higherofficialcontroller>();
   addresscontrl = TextEditingController();
   firstNameController = TextEditingController();
   lastNameController = TextEditingController();
   officialMobileController = TextEditingController();
   emailController = TextEditingController();
   passwordController= TextEditingController();
    
  }

Future<void> profileFuntion() async {
  final pickedImage = await ExceptionDialog().handleExceptionDialog(context, ()async=> await controller. addPhoto(context));
  if (pickedImage != null && mounted) {
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
    return 
        Column(
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
                              
              customIconNavigation(context, '/manage-higher-official'),
                    const   SizedBox(width: 10),
                buildProfilePicker(
                            image: updatePhotoUrl,
                            onPress: profileFuntion
                          ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          buildTextFieldRow([
                            buildTextField('Higher Official First Name', 'Enter first name',
                                TextInputType.text, (value) {
                              if (value == null || value.isEmpty) {
                                return 'First name is required';
                              }
                              return null;
                            }, controller: firstNameController),
                            buildTextField('Higher Official Last Name', 'Enter last name',
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
                              isPasswordObscured: _isPasswordObscured,
                              passwordController: passwordController),
                          ]),
                          const SizedBox(height: 30),
                           buildTextFieldRow([
                          buildTextField(
                              'Higher Official Mobile',
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
                                FilteringTextInputFormatter
                                    .digitsOnly, // Only allow digits
                              ],controller: officialMobileController
                            ),
                             buildAddressField(addressContrl: addresscontrl),
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
  CustomDialogs().showLoadingDialogInSec(context, 10,"Creating higher official, please wait a moment  !");
   String name = '${firstNameController.text} ${lastNameController.text}';
                      if(!context.mounted)return;
                      await ExceptionDialog().handleExceptionDialog(context, ()async=>await  controller.registerOfficials(
 password: passwordController.text,
    context: context,
    updatePhotoUrl:updatePhotoUrl, 
  principalAddress: addresscontrl.text,
  principalEmail: emailController.text,
  principalName: name.toUpperCase(),
  principalPhoneNumber: officialMobileController.text,

  principalRole: "Higher Official",
  
  ));
  if(!context.mounted)return;
    await ExceptionDialog().handleExceptionDialog(context, ()async=>await controller.updateNumberOfOfficials(context,true));    
    customPopNavigation(context, '/manage-higher-official');
  }
  } else
  {
  
                      if(!context.mounted) return;
                      await CustomDialogs().showCustomDialog(context, "Please pick profile photo for the person ❓ ");
  }




                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: primaryGreenColors,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 35,
                                  vertical: 20,
                                ),
                              ),
                              child: const Text(
                                'Add Higher Official',
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
