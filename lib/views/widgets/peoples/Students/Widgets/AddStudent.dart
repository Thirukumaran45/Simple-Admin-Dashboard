import 'package:admin_pannel/views/widgets/peoples/widgets/CustomeTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddStudentTab extends StatefulWidget {
  const AddStudentTab({super.key});

  @override
  State<AddStudentTab> createState() => _AddStudentTabState();
}

class _AddStudentTabState extends State<AddStudentTab> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final bool _isPasswordObscured = true;

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController addresscontrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                      buildProfilePicker(),
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
                    }),
                    buildTextField('Student Last Name', 'Enter last name',
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
                    }),
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
                    buildTextField('Student Admission Number',
                        'Enter Admission No*', TextInputType.text, (value) {
                      if (value == null || value.isEmpty) {
                        return 'Admisson Number is required';
                      }
                      return null;
                    }),
                  ]),
                  const SizedBox(height: 30),
                  buildParentDetailsRow(),
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
                        backgroundColor: Colors.green,
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
    );
  }
}
