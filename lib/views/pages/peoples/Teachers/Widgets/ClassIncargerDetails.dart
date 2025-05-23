import '../../../../../controller/classControllers/peoplesControlelr/TeacherController.dart';
import '../../../../../contant/CustomNavigation.dart';
import '../../../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst;

class ClassInchargerDetails extends StatefulWidget {
  const ClassInchargerDetails({super.key});

  @override
  State<ClassInchargerDetails> createState() => _ClassInchargerDetailsState();
}

class _ClassInchargerDetailsState extends State<ClassInchargerDetails> {
  late List<List<TextEditingController>> nameControllers;
  late List<List<TextEditingController>> phoneNumberControllers;
  late List<List<TextEditingController>> emailControllers;

  final List<List<ValueNotifier<bool>>> isNameEditing =
      List.generate(12, (_) => List.generate(4, (_) => ValueNotifier(false)));
  final List<List<ValueNotifier<bool>>> isPhoneNumberEditing =
      List.generate(12, (_) => List.generate(4, (_) => ValueNotifier(false)));
  final List<List<ValueNotifier<bool>>> isEmailEditing =
      List.generate(12, (_) => List.generate(4, (_) => ValueNotifier(false)));

  final List<ValueNotifier<bool>> isClassEditing = List.generate(12, (_) => ValueNotifier(false));

 late Teachercontroller controller ;

  @override
  void initState() {
    super.initState();
    controller = Get.find<Teachercontroller>();
    nameControllers = List.generate(12, (_) => List.generate(4, (_) => TextEditingController()));
    phoneNumberControllers = List.generate(12, (_) => List.generate(4, (_) => TextEditingController()));
    emailControllers = List.generate(12, (_) => List.generate(4, (_) => TextEditingController()));
   controller.fetchAllClassInchargeDetails(context,nameControllers, phoneNumberControllers, emailControllers);
  
  }


  @override
  void dispose() {
    for (var list in nameControllers) {
      for (var controller in list) {
        controller.dispose();
      }
    }
    for (var list in phoneNumberControllers) {
      for (var controller in list) {
        controller.dispose();
      }
    }
    for (var list in emailControllers) {
      for (var controller in list) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [customIconNavigation(context, '/manage-teacher')],
            ),
            Column(
              children: List.generate(12, (index) => classRow(index)),
            )
          ],
        ),
      ),
    );
  }

  Widget classRow(int classIndex) {
    return ValueListenableBuilder<bool>(
      valueListenable: isClassEditing[classIndex],
      builder: (context, isEditing, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Class ${classIndex + 1}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  if (isEditing)
                    Padding(
                      padding: const EdgeInsets.only(left: 200),
                      child: 
               ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    elevation: 10, // Elevation for shadow effect
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Button padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // Rounded corners
    ),
  ),
  onPressed: () async {
    for (int i = 0; i < 4; i++) {
      String stuClass = (classIndex + 1).toString(); // Convert class index to class number
      String stuSec = String.fromCharCode(65 + i); // Convert section index to 'A', 'B', 'C', 'D'
      String name = nameControllers[classIndex][i].text.trim();
      String phoneNo = phoneNumberControllers[classIndex][i].text.trim();
      String email = emailControllers[classIndex][i].text.trim();

      if (name.isNotEmpty && phoneNo.isNotEmpty && email.isNotEmpty) {
        await controller.addAndUpdateClassInchargers(context,
          stuClass: stuClass,
          stuSec: stuSec,
          name: name,
          phoneNo: phoneNo,
          email: email,
        );
      }
    }
    
    isClassEditing[classIndex].value = false; // Exit edit mode after saving
  },
  child: const Text('Save changes', style: TextStyle(fontSize: 17)),
),

                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < 4; i++) classSectionRow(classIndex, i),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Divider(color: primaryGreenColors),
            )
          ],
        );
      },
    );
  }

  Widget classSectionRow(int classIndex, int sectionIndex) {
    List<String> sections = ["A", "B", "C", "D"];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text("Section ${sections[sectionIndex]} : ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Expanded(child: _buildEditableField(classIndex, "Name", nameControllers[classIndex][sectionIndex], isNameEditing[classIndex][sectionIndex])),
          const SizedBox(width: 10),
          Expanded(child: _buildEditableField(classIndex, "Phone.No", phoneNumberControllers[classIndex][sectionIndex], isPhoneNumberEditing[classIndex][sectionIndex])),
          const SizedBox(width: 10),
          Expanded(child: _buildEditableField(classIndex, "Email", emailControllers[classIndex][sectionIndex], isEmailEditing[classIndex][sectionIndex])),
        ],
      ),
    );
  }
  Widget _buildEditableField(int classIndex, String label, TextEditingController controller, ValueNotifier<bool> isEditingNotifier) {
    return ValueListenableBuilder<bool>(
      valueListenable: isEditingNotifier,
      builder: (context, isEditing, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: primaryGreenColors, fontWeight: FontWeight.bold, fontSize: 18),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryGreenColors),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryGreenColors),
                ),
              ),
              style: TextStyle(fontSize: 16, color: Colors.grey[850]),
              onChanged: (value) {
                isEditingNotifier.value = true;
                isClassEditing[classIndex].value = true;
              },
            ),
          ],
        );
      },
    );
  }
}
