import '../../../../contant/constant.dart';
import '../../../../contant/CustomNavigation.dart';
import '../../../../contant/pdfApi/PdfBonafied.dart';
import '../../../widget/CustomeButton.dart';
import '../../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';

class StudentBonafied extends StatefulWidget {
  const StudentBonafied({super.key});

  @override
  State<StudentBonafied> createState() => _StudentBonafiedState();
}

class _StudentBonafiedState extends State<StudentBonafied> {
  late final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController ;
  late final TextEditingController parentNameController ;
  late final TextEditingController dobController ;
  late final TextEditingController classController ;
  late final TextEditingController yearController ;
  String selectedOption = "Current Academic";

@override
  void initState() {
    super.initState();
   nameController = TextEditingController();
   parentNameController = TextEditingController();
   dobController = TextEditingController();
   classController = TextEditingController();
   yearController = TextEditingController();
  }
  @override
  void dispose() {
    nameController .dispose();
   parentNameController .dispose();
   dobController .dispose();
   classController .dispose();
   yearController .dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar( 
      backgroundColor: Colors.white,
        leadingWidth: double.infinity,
      leading: Row(
        children: [
          customIconNavigation(context, "/bonafied"),
          const Text(" Student Bonafide Certificate Form", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
        ],
        
      )),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Card(
              shadowColor: primaryBlueShadeColrs,
              color: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Filter Options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<String>(
                          value: "Current Academic",
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                          },
                        ),
                        const Text("Current Academic Student", style: TextStyle(color: Colors.black,fontSize: 16),),
                        const SizedBox(width: 20),
                        Radio<String>(
                          value: "Out Passing Academic",
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value!;
                            });
                          },
                        ),
                        const Text("Out Passing Academic Student",style: TextStyle(color: Colors.black,fontSize: 16)),
                        const Spacer(),
            
                       customIconTextButton(Colors.red, onPressed: ()async{
                         if (_formKey.currentState!.validate()) {
                        await customSnackbar(context: context, text: "Donloaded Succesfully");
                              }
                          await PdfApi().openPdf(academicYear:yearController.text,fileName: nameController.text, studentName: nameController.text,parentName: parentNameController.text, studentClass: classController.text, dob: dobController.text, academicType:selectedOption );

                            
                       }, icon: Icons.generating_tokens, text: "Generate Certificate")
                      ],
                    ),
                    
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTextField(nameController, "Student Name"),
                          _buildTextField(parentNameController, "Parent's Name"),
                          _buildDateField(dobController, "Date of Birth (DD/MM/YYYY)"),
                          if (selectedOption == "Current Academic") ...[
                            _buildTextField(classController, "Current Class"),
                            _buildTextField(yearController, "Academic Year"),
                          ],
                          
                         
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),
        controller: controller,
        decoration: InputDecoration(
        
          labelText: label,
           labelStyle:const TextStyle(color: Colors.red) ,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }
Widget _buildDateField(TextEditingController controller, String label) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: TextFormField(
        style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),
      onTap: () =>dateTheme(controller),
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
         labelStyle:const TextStyle(color: Colors.red) ,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
        suffixIcon: IconButton(
          icon:  const Icon(Icons.calendar_today, color: Colors.black),

          onPressed: () =>dateTheme(controller)
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $label";
        }
        return null;
      },
    ),
  );
}

void dateTheme(TextEditingController controller,)async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: todayDateTime,
              firstDate: DateTime(1900),
              lastDate: todayDateTime,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme:  ColorScheme.light(
                      primary: primaryGreenColors, // Header background color
                      onPrimary: Colors.white, // Header text color
                      onSurface: primaryGreenColors, // Body text color
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: primaryGreenColors, // Button text color
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              setState(() {
                controller.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
              });
            }
          }

}