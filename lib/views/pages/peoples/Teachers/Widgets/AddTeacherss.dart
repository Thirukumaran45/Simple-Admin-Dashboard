
import 'package:admin_pannel/views/pages/peoples/widgets/CustomeTextField.dart';
import 'package:admin_pannel/views/widget/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddTeacherTab extends StatefulWidget {
  const AddTeacherTab({super.key});

  @override
  State<AddTeacherTab> createState() => _AddTeacherTabState();
}

class _AddTeacherTabState extends State<AddTeacherTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final bool _isPasswordObscured = true;

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController addresscontrl = TextEditingController();
  final TextEditingController _empDateController = TextEditingController();

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
                          buildProfilePicker(),
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
                        }),
                        buildTextField('Teacher Last Name', 'Enter last name',
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
                            'Graduated Degree',
                            'Enter Completed Degree course name',
                            TextInputType.text, (value) {
                          if (value == null || value.isEmpty) {
                            return 'Graduated Degree is required';
                          }
                          return null;
                        }),
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
                        }),
                        buildPasswordField(isPasswordObscured: _isPasswordObscured),
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
                                    ),
                                    dialogBackgroundColor:
                                        Colors.white, // Background color
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
                        buildTextField(
                          'Employment Date',
                          'Select start date of employment',
                          TextInputType.datetime,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Employment Date is required';
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
                                    ),
                                    dialogBackgroundColor:
                                        Colors.white, // Background color
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
                      ]),
                      const SizedBox(height: 30),
                      buildAddressField(addressContrl: addresscontrl),
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
