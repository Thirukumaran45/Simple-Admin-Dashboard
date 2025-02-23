
import 'package:admin_pannel/constant.dart';
import 'package:admin_pannel/provider/CustomNavigation.dart';
import 'package:admin_pannel/views/pages/SchoolDetailsUpdate/widget/customfield.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';

class SchoolUpdateMainScreen extends StatefulWidget {
  const SchoolUpdateMainScreen({super.key});

  @override
  _SchoolGalleryPageState createState() => _SchoolGalleryPageState();
}
class _SchoolGalleryPageState extends State<SchoolUpdateMainScreen> {
  late TextEditingController schoolNameController ; 
  late TextEditingController schoolCityController ;
  late TextEditingController studentPassKeyController ; 
  late TextEditingController teacherPassKeyController ;
  late TextEditingController staffPassKeyController ; 
  late TextEditingController officialPassKeyController ; 
  bool obscureStudentText = true;
  bool obscureTeacherText = true;
  bool obscureStaffText = true;
  bool obscureOfficialText = true;
  bool isEditingSchoolName = false;
  bool isEditingSchoolCity = false;
  bool isNameChanged = false;
  bool isChatAi_api = false;
  bool isTeacherKeyChanged = false;
  bool isStudentKeyChanged = false;
  bool isOfficialKeyChanged = false;
  bool isStaffKeyChanged = false;
  List<String> passkeys = ["Student Passkey", "Teacher Passkey", "Staff Passkey", "Higher Official Passkey"];
  List<String> schoolPhotos = List.generate(12, (index) => "assets/images/profile.png");

  @override
  void initState() {
    super.initState();
    // Adding individual listeners for each passkey field
       schoolNameController = TextEditingController(text: schoolName);
   schoolCityController = TextEditingController(text: "axi12hdjhie83bjbr9823ubbdjb");
   studentPassKeyController = TextEditingController(text: "Student");
   teacherPassKeyController = TextEditingController(text: "Teacher");
   staffPassKeyController = TextEditingController(text: "Staff");
   officialPassKeyController = TextEditingController(text: "official");
    studentPassKeyController.addListener(() {
      setState(() {
        isStudentKeyChanged = studentPassKeyController.text != "Student";
      });
    });
    teacherPassKeyController.addListener(() {
      setState(() {
        isTeacherKeyChanged = teacherPassKeyController.text != "Teacher";
      });
    });
    staffPassKeyController.addListener(() {
      setState(() {
        isStaffKeyChanged = staffPassKeyController.text != "Staff";
      });
    });
    officialPassKeyController.addListener(() {
      setState(() {
        isOfficialKeyChanged = officialPassKeyController.text != "official";
      });
    });

    // School Name and City listeners (unchanged)
    schoolNameController.addListener(() {
      setState(() {
        isNameChanged = schoolNameController.text != schoolName;
      });
    });
    schoolCityController.addListener(() {
      setState(() {
        isChatAi_api = schoolCityController.text != "axi12hdjhie83bjbr9823ubbdjb";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // School Name & City Row
            Row(
              children: [
                Expanded(child: _buildEditableTextField("School Name", schoolNameController, () => setState(() => isEditingSchoolName = true), isEditingSchoolName)),
                const SizedBox(width: 16),
                Expanded(child: _buildEditableTextField("Chat Ai API Key", schoolCityController, () => setState(() => isEditingSchoolCity = true), isEditingSchoolCity)),
              ],
            ),
            const SizedBox(height: 22),
            
            // Passkeys Rows
            _buildPasskeyRow(passkeys.sublist(0, 2)),
            
            
            const SizedBox(height: 30),
            // School Gallery Title with Add Photo Button near it
               Padding(padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: (){
                  customNvigation(context, '/school-details-updation/viewPhoto?assetLink=assets/images/splash.png');
                         
                },
                 child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: BoxDecoration(
                    color: primaryYellowShadeColors,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const  [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.grey
                      )
                    ]
                  ),

                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Upload School Logo , Here",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          fontSize: 20
                        ),
                      ),
                      Icon(Icons.arrow_forward,size: 30, color: Colors.black,)
                    ],
                  ),
                 ),
              )
              ),

             const SizedBox(
              height: 20,
             ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("School Gallery Photos", style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold ,color: Colors.black)),
                ),
                customIconTextButton(Colors.blue, onPressed: (){}, icon: Icons.upload, text: "Add Photo")
              ],
            ),
            
            // Grid Layout for School Photos (scrolls with the page)
           Customfield(schoolPhotos: schoolPhotos,),
            
            // Load More Button
            Padding(
              padding: const EdgeInsets.all(25),
              child: Center(
                child: TextButton(onPressed: (){}, child: const Text("Load more ...", style: TextStyle(color: Colors.blue, fontSize: 20),)) ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableTextField(String label, TextEditingController controller, VoidCallback onEdit, bool isEditing) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
       const SizedBox(height: 8,),
          TextField(
            controller: controller,
            decoration:  InputDecoration(
             border: OutlineInputBorder(
              borderSide: BorderSide(color: primaryGreenColors),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryGreenColors),
            ),
            ),
            onTap: onEdit,
            style:   TextStyle(fontSize: 16, color: Colors.grey[850]),
          ),
          // Show Save button below TextField only when it's being edited and text is changed
          if (isEditing && (label == "School Name" ? isNameChanged : isChatAi_api))
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                width: 120, // Reduced width for the Save button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    setState(() {
                      if (label == "School Name") {
                        isEditingSchoolName = false;
                        isNameChanged = false;
                      } else {
                        isEditingSchoolCity = false;
                        isChatAi_api = false;
                      }
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.save, size: 16 ,color: Colors.white,),
                      SizedBox(width: 4),
                      Text("Save",style: TextStyle(fontSize: 18 ,color: Colors.white),),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
Widget _buildPasskeyRow(List<String> passkeys) {
  return Column(
    children: [
      Row(
        children: [
         Expanded(child: _buildEditablePasskeyField("Student PassKey", studentPassKeyController, isStudentKeyChanged, obscureStudentText, (value) {
              setState(() {
                obscureStudentText = value;
              });
            })),  const SizedBox(width: 22),
          Expanded(child: _buildEditablePasskeyField("Teacher PassKey", teacherPassKeyController, isTeacherKeyChanged , obscureTeacherText, (value) {
              setState(() {
                obscureTeacherText = value;
              });
            })),
        ],
        
      ),
            const SizedBox(height: 20),

      Row(
        children: [
          Expanded(child: _buildEditablePasskeyField("Staff PassKey", staffPassKeyController, isStaffKeyChanged, obscureStaffText, (value) {
              setState(() {
                obscureStaffText = value;
              });
            })),
          const SizedBox(width: 22),
          Expanded(child: _buildEditablePasskeyField("Official PassKey", officialPassKeyController, isOfficialKeyChanged, obscureOfficialText, (value) {
              setState(() {
                obscureOfficialText = value;
              });
            })),
        ],
      ),
    ],
  );
}
 Widget _buildEditablePasskeyField(String label, TextEditingController controller, bool isEditing, bool obscureText, Function(bool) onToggle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: obscureText, // Toggle visibility for passkey
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: primaryGreenColors),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryGreenColors),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color:obscureText? primaryGreenColors: Colors.red,
                ),
                onPressed: () {
                  onToggle(!obscureText); // Toggle visibility for this field only
                },
              ),
            ),
               style:   TextStyle(fontSize: 16, color: Colors.grey[850]),
          ),
          // Show Save button if there is a change in the value
          if (isEditing)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                width: 120, // Reduced width for the Save button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    setState(() {
                      if (label == "Student PassKey") {
                        isStudentKeyChanged = false;
                      } else if (label == "Teacher PassKey") {
                        isTeacherKeyChanged = false;
                      } else if (label == "Staff PassKey") {
                        isStaffKeyChanged = false;
                      } else if (label == "Official PassKey") {
                        isOfficialKeyChanged = false;
                      }
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.save, size: 16, color: Colors.white),
                      SizedBox(width: 4),
                      Text("Save", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}