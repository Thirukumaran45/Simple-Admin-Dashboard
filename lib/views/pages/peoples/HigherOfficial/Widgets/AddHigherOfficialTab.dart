
import 'package:admin_pannel/FireBaseServices/FirebaseAuth.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/HigherOfficialController.dart';
import 'package:admin_pannel/views/pages/peoples/widgets/CustomeTextField.dart';
import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' show Get,Inst;
import '../../../../widget/CustomDialogBox.dart' show showCustomConfirmDialog, showCustomDialog,showLoadingDialogInSec;

class AddHigherOfficialTab extends StatefulWidget {
  const AddHigherOfficialTab({super.key});

  @override
  State<AddHigherOfficialTab> createState() => _AddHigherOfficialTabState();
}

class _AddHigherOfficialTabState extends State<AddHigherOfficialTab> {
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
  late Higherofficialcontroller controller ;
@override
  void initState() {
    super.initState();
   authControlelr = Get.find<FirebaseAuthUser>();
   controller = Get.find<Higherofficialcontroller>();
   addresscontrl = TextEditingController();
   firstNameController = TextEditingController();
   lastNameController = TextEditingController();
   officialMobileController = TextEditingController();
   emailController = TextEditingController();
   passwordController= TextEditingController();
    
  }

Future<void> profileFuntion() async {
  final pickedImage = await controller. addPhoto();
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
   authControlelr.dispose();
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
       bool val = await showCustomConfirmDialog(context: context, text: 'Are you sure about to add the person ?');
     if(val)
     {
     showLoadingDialogInSec(context, 10);
      final user = await authControlelr.createUser(email: emailController.text,password: passwordController.text, context: context);
     String userId = user!.id;
     final url = await controller.photoStorage(image: updatePhotoUrl,userId: userId);
     String name = '${firstNameController.text} ${lastNameController.text}';
  await  controller.registerOfficials(
     userId: userId,
       context: context,
     principalAddress: addresscontrl.text,
     principalEmail: emailController.text,
     principalName: name.toUpperCase(),
     principalPhoneNumber: officialMobileController.text,
     principalProfile: url,
     principalRole: "Higher Official",

     );
     await controller.updateNumberOfOfficials(true);
     customPopNavigation(context, '/manage-higher-official');
     }
     } else
     {

  if(!context.mounted) return;
  await showCustomDialog(context, "Please pick profile photo for the person !");
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
