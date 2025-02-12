
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget buildProfilePicker() {
  return Center(
    child: Stack(
      children: [
        CircleAvatar(
          radius: 80,
          backgroundImage: const AssetImage('assets/images/profile.png'),
          backgroundColor: Colors.grey.shade300,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt,
                color: Colors.red,
              ),
              onPressed: () {
                // Add image picker logic here
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildTextField(String label, String hint, TextInputType keyboardType,
    String? Function(String?)? validator,
    {TextEditingController? controller,
    VoidCallback? onTap,
    List<TextInputFormatter>? inputFormatters}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const  TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        cursorColor: Colors.green,
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
        validator: validator,
        inputFormatters: inputFormatters,
        onTap: onTap,
      ),
    ],
  );
}

Widget buildTextFieldRow(List<Widget> fields) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: fields
        .map((field) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: field,
              ),
            ))
        .toList(),
  );
}
Widget buildAddressField({required TextEditingController addressContrl}) {
  return Padding(             
     padding: const EdgeInsets.only(left: 8.2),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         const Text(
          'Address',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        // Wrap the TextFormField in a FormField to handle validation
        FormField<String>(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Address is required';
            }
            return null;
          },
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    cursorColor: Colors.green,
                    controller: addressContrl,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      hintText: "  Enter your native address",
                    ),
                  ),
                ),
                // Error message below the container if validation fails
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    ),
  );
}

Widget buildPasswordField({required bool isPasswordObscured}) {
  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         const  Text(
            'Password',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            cursorColor: Colors.green,
            obscureText: isPasswordObscured,
            decoration: InputDecoration(
              hintText: 'Enter password',
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                  color: isPasswordObscured ? Colors.green : Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordObscured = !isPasswordObscured;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              } else if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ],
      );
    },
  );
}

Widget buildParentDetailsRow() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.2),
              child: buildTextField(
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  'Father Name',
                  'Enter father\'s name',
                  TextInputType.text, (value) {
                if (value == null || value.isEmpty) {
                  return 'Father\'s name is required';
                }
                return null;
              }),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: buildTextField(
              'Father Mobile',
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
                FilteringTextInputFormatter.digitsOnly, // Only allow digits
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(              
              padding: const EdgeInsets.only(left: 8.2),

              child: buildTextField(
                  'Mother Name', 'Enter mother\'s name', TextInputType.text,
                  (value) {
                if (value == null || value.isEmpty) {
                  return 'Mother\'s name is required';
                }
                return null;
              }),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: buildTextField(
              'Mother Mobile',
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
                FilteringTextInputFormatter.digitsOnly, // Only allow digits
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
