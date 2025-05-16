
import 'dart:developer' show log;
import '../../../controller/classControllers/schoolDetailsController/schooldetailsController.dart';
import 'widget/customfield.dart';
import '../../widget/CustomDialogBox.dart';
import '../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst;

class SchoolUpdateMainScreen extends StatefulWidget {
  const SchoolUpdateMainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SchoolGalleryPageState createState() => _SchoolGalleryPageState();
}
class _SchoolGalleryPageState extends State<SchoolUpdateMainScreen> {
  late TextEditingController schoolNameController ; 
  late TextEditingController schoolChatBOtApi ;
  late TextEditingController studentPassKeyController ; 
  late TextEditingController teacherPassKeyController ;
  late TextEditingController staffPassKeyController ; 
  late TextEditingController officialPassKeyController ; 
  
   String? schoolName ;
   String? chatbotAi ;
   String? studentPasskey ;
   String? teacherPasskey ;
   String? staffPassKey;
   String? higherOfficialPassKey;
  bool obscureStudentText = true;
  bool obscureTeacherText = true;
  bool obscureStaffText = true;
  bool obscureOfficialText = true;
  bool isEditingSchoolName = false;
  bool isEditingSchoolCity = false;
  bool isNameChanged = false;
  bool isChatAiapi = false;
  bool isTeacherKeyChanged = false;
  bool isStudentKeyChanged = false;
  bool isOfficialKeyChanged = false;
  bool isStaffKeyChanged = false;
  List<String> passkeys = ["Student Passkey", "Teacher Passkey", "Staff Passkey", "Higher Official Passkey"];
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<CustomfieldState> customfieldKey = GlobalKey<CustomfieldState>();

 late SchooldetailsController detailsController ; 
@override
void initState() {
  super.initState();
  detailsController = Get.find<SchooldetailsController>(); 
  schoolNameController = TextEditingController();
  schoolChatBOtApi = TextEditingController();
  studentPassKeyController = TextEditingController();
  teacherPassKeyController = TextEditingController();
  staffPassKeyController = TextEditingController();
  officialPassKeyController = TextEditingController();
   _scrollController.addListener(() {
      const threshold = 200.0;
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - threshold) {
        // ask the grid to load the next page
        customfieldKey.currentState?.loadMore();
      }
    });
  initializeSchoolDetails();
}

Future<void>getSchoolDetails()async{

  final schoolDetails = await detailsController.getSchoolDetails();
  setState(() {
   schoolName = schoolDetails.schoolName;
   chatbotAi = schoolDetails.chatbotApi;
   studentPasskey = schoolDetails.studentPassKey;
   teacherPasskey = schoolDetails.teacherPassKey;
   staffPassKey = schoolDetails.staffPassKey;
   higherOfficialPassKey = schoolDetails.higherOfficialPassKey;
  });

}

Future<void>initializeSchoolDetails()async{
await getSchoolDetails();
setState(() {
  schoolNameController.text = schoolName??" ";
   schoolChatBOtApi.text = chatbotAi??" ";
   studentPassKeyController.text = studentPasskey?? " ";
   teacherPassKeyController.text =  teacherPasskey??" ";
   staffPassKeyController.text =  staffPassKey??" ";
   officialPassKeyController.text = higherOfficialPassKey??" ";  
});
 
    studentPassKeyController.addListener(() {
      setState(() {
        isStudentKeyChanged = studentPassKeyController.text != studentPasskey;
      });
    });
    teacherPassKeyController.addListener(() {
      setState(() {
        isTeacherKeyChanged = teacherPassKeyController.text != teacherPasskey;
      });
    });
    staffPassKeyController.addListener(() {
      setState(() {
        isStaffKeyChanged = staffPassKeyController.text != staffPassKey;
      });
    });
    officialPassKeyController.addListener(() {
    
      setState(() {
        isOfficialKeyChanged = officialPassKeyController.text != higherOfficialPassKey;
      });
    });

    // School Name and City listeners (unchanged)
    schoolNameController.addListener(() {
      setState(() {
        isNameChanged = schoolNameController.text != schoolName;
      });
    });
    schoolChatBOtApi.addListener(() {
      setState(() {
        isChatAiapi = schoolChatBOtApi.text != chatbotAi;
      });
    });
}
  
Future<bool> addAndUpdateDetails()async{ 
  
   final isupdate = await detailsController.addAndUpdateSchoolDetails(
    schoolName: schoolNameController.text,
    chatbotApi: schoolChatBOtApi.text,
    studentPassKey: studentPassKeyController.text,
    teacherPassKey: teacherPassKeyController.text,
    higherOfficialPassKey: officialPassKeyController.text,
    staffPassKey: staffPassKeyController.text,
  );


  return isupdate;
}  

@override
  void dispose() {
    _scrollController.dispose();
      schoolNameController.dispose();
  schoolChatBOtApi.dispose();
  studentPassKeyController.dispose();
  teacherPassKeyController.dispose();
  staffPassKeyController.dispose();
  officialPassKeyController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,  
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // School Name & City Row
            Row(
              children: [
                Expanded(child: _buildEditableTextField("School Name", schoolNameController, () => setState(() => isEditingSchoolName = true), isEditingSchoolName)),
                const SizedBox(width: 16),
                Expanded(child: _buildEditableTextField("Chat Ai API Key", schoolChatBOtApi, () => setState(() => isEditingSchoolCity = true), isEditingSchoolCity)),
              ],
            ),
            const SizedBox(height: 22),
            
            // Passkeys Rows
            _buildPasskeyRow(passkeys.sublist(0, 2)),
            
            
            const SizedBox(height: 30),
            // School Gallery Title with Add Photo Button near it
             schoolDetailsGallery(context, detailsController, customfieldKey),
            
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
          if (isEditing && (label == "School Name" ? isNameChanged : isChatAiapi))
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SizedBox(
                width: 120, // Reduced width for the Save button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () async {
  final isupdate = await detailsController.addAndUpdateSchoolDetails(
    schoolName: schoolNameController.text,
    chatbotApi: schoolChatBOtApi.text,
    studentPassKey: studentPassKeyController.text,
    teacherPassKey: teacherPassKeyController.text,
    higherOfficialPassKey: officialPassKeyController.text,
    staffPassKey: staffPassKeyController.text,
  );
  log(isupdate ? "Updated the function" : "Not updating");
  setState(() {
    if (label == "School Name") {
      isEditingSchoolName = false;
      isNameChanged = false;
    } else {
      isEditingSchoolCity = false;
      isChatAiapi = false;
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
                onPressed: () async {
final isupdate = await addAndUpdateDetails(); 
  isupdate?showCustomDialog(context, "School Details Updated Succesfully"):
  showCustomDialog(context, "Something went wrong, please check the details !");
  setState(() {
    if (label == "School Name") {
      isEditingSchoolName = false;
      isNameChanged = false;
    } else {
      isEditingSchoolCity = false;
      isChatAiapi = false;
    }
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