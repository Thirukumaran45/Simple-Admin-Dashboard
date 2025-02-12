
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:flutter/material.dart';

class SchoolUpdateMainScreen extends StatefulWidget {
  const SchoolUpdateMainScreen({super.key});

  @override
  _SchoolGalleryPageState createState() => _SchoolGalleryPageState();
}
class _SchoolGalleryPageState extends State<SchoolUpdateMainScreen> {
  TextEditingController schoolNameController = TextEditingController(text: "ABC Public School");
  TextEditingController schoolCityController = TextEditingController(text: "New York");
  TextEditingController studentPassKeyController = TextEditingController(text: "Student");
  TextEditingController teacherPassKeyController = TextEditingController(text: "Teacher");
  TextEditingController staffPassKeyController = TextEditingController(text: "Staff");
  TextEditingController officialPassKeyController = TextEditingController(text: "official");

  bool isEditingSchoolName = false;
  bool isEditingSchoolCity = false;
  bool isNameChanged = false;
  bool isCityChanged = false;
  bool isTeacherKeyChanged = false;
  bool isStudentKeyChanged = false;
  bool isOfficialKeyChanged = false;
  bool isStaffKeyChanged = false;
 bool _obscureText =true;
  List<String> passkeys = ["Student Passkey", "Teacher Passkey", "Staff Passkey", "Higher Official Passkey"];
  List<String> schoolPhotos = List.generate(12, (index) => "assets/images/profile.png");

  @override
  void initState() {
    super.initState();
    // Adding individual listeners for each passkey field
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
        isNameChanged = schoolNameController.text != "ABC Public School";
      });
    });
    schoolCityController.addListener(() {
      setState(() {
        isCityChanged = schoolCityController.text != "New York";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Expanded(child: _buildEditableTextField("School City & district", schoolCityController, () => setState(() => isEditingSchoolCity = true), isEditingSchoolCity)),
              ],
            ),
            const SizedBox(height: 22),
            
            // Passkeys Rows
            _buildPasskeyRow(passkeys.sublist(0, 2)),
            
            
            const SizedBox(height: 16),
            // School Gallery Title with Add Photo Button near it
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("School Gallery Photos", style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold ,color: Colors.black)),
                customIconTextButton(Colors.blue, onPressed: (){}, icon: Icons.upload, text: "Add Photo")
              ],
            ),
            
            const SizedBox(height: 16),
            // Grid Layout for School Photos (scrolls with the page)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: schoolPhotos.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage(schoolPhotos[index]),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 4), // Shadow below the image
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: customIconTextButton(Colors.red, onPressed: () {
                        setState(() => schoolPhotos.removeAt(index));
                      }, icon: Icons.delete, text: "Delete")
                    ),
                  ],
                );
              },
            ),
            
            // Load More Button
            Padding(
              padding: const EdgeInsets.all(25),
              child: Center(
                child: SizedBox(height: 60 , width: 200,
                  child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {},
                    child: const Text("Load More ...", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ),
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
          Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
               border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              ),
              onTap: onEdit,
            ),
          ),
          // Show Save button below TextField only when it's being edited and text is changed
          if (isEditing && (label == "School Name" ? isNameChanged : isCityChanged))
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
                        isCityChanged = false;
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
          Expanded(child: _buildEditablePasskeyField("Student PassKey", studentPassKeyController, isStudentKeyChanged)),
          const SizedBox(width: 22),
          Expanded(child: _buildEditablePasskeyField("Teacher PassKey", teacherPassKeyController, isTeacherKeyChanged)),
        ],
        
      ),
            const SizedBox(height: 22),

      Row(
        children: [
          Expanded(child: _buildEditablePasskeyField("Staff PassKey", staffPassKeyController, isStaffKeyChanged)),
          const SizedBox(width: 22),
          Expanded(child: _buildEditablePasskeyField("Official PassKey", officialPassKeyController, isOfficialKeyChanged)),
        ],
      ),
    ],
  );
}

Widget _buildEditablePasskeyField(String label, TextEditingController controller, bool isEditing) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.all(15),
          child: TextField(
            controller: controller,
            obscureText: _obscureText, // Toggle visibility for passkey
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.green,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText; // Toggle visibility
                  });
                },
              ),
            ),
          ),
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