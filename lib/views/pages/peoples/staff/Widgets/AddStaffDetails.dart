
import 'package:admin_pannel/views/pages/peoples/widgets/CustomeTextField.dart';
import 'package:admin_pannel/provider/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddStaffTab extends StatefulWidget {
  const AddStaffTab({super.key});

  @override
  State<AddStaffTab> createState() => _AddStaffTabState();
}

class _AddStaffTabState extends State<AddStaffTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final bool _isPasswordObscured = true;

  final TextEditingController addresscontrl = TextEditingController();

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
                          buildProfilePicker(),
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
                        }),
                        buildTextField('Staff Last Name', 'Enter last name',
                            TextInputType.text, (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last name is required';
                          }
                          return null;
                        }),
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
                          ],
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
                        }),
                        // buildPasswordField(isPasswordObscured: _isPasswordObscured),
                      ]),
                      const SizedBox(height: 30),
                  
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              // Add submit logic here
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