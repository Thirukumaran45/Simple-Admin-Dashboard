import 'dart:math';
import 'package:admin_pannel/views/widget/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';

class ClassInchargerDetails extends StatefulWidget {
  const ClassInchargerDetails({super.key});

  @override
  State<ClassInchargerDetails> createState() => _ClassInchargerDetailsState();
}

class _ClassInchargerDetailsState extends State<ClassInchargerDetails> {
  late List<TextEditingController> nameControllers;
  late List<TextEditingController> emailControllers;

  final List<ValueNotifier<bool>> isNameEditing = List.generate(4, (_) => ValueNotifier(false));
  final List<ValueNotifier<bool>> isEmailEditing = List.generate(4, (_) => ValueNotifier(false));

  @override
  void initState() {
    super.initState();
    final random = Random();
    nameControllers = List.generate(4, (index) => TextEditingController(text: "Name ${random.nextInt(100)}"));
    emailControllers = List.generate(4, (index) => TextEditingController(text: "user${random.nextInt(100)}@mail.com"));

    for (int i = 0; i < 4; i++) {
      nameControllers[i].addListener(() => _handleTextChange(i, isNameEditing[i], nameControllers[i]));
      emailControllers[i].addListener(() => _handleTextChange(i, isEmailEditing[i], emailControllers[i]));
    }
  }

  void _handleTextChange(int index, ValueNotifier<bool> notifier, TextEditingController controller) {
    notifier.value = controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    for (var controller in nameControllers) {
      controller.dispose();
    }
    for (var controller in emailControllers) {
      controller.dispose();
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
            children:  List.generate(12, (index) => classRow(index +1)),
           )

          ],
        )
      )
    );
  }

  Widget classRow(int index)
  {
    return  Column(
          children: [
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Center(
                child: Text(
                  "Class $index",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color: Colors.red),
                ),
                           ),
             ),
            const SizedBox(height: 16),
            for (int i = 0; i < 4; i++) classSectionRow(i),
             Padding(
              padding: const EdgeInsets.all(20),
              child:  Divider(

                color: primaryGreenColors,
              ),
            )

          ],
        );
  }

  Widget classSectionRow(int index) {
    List<String> sections = ["A", "B", "C", "D"];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text("Section ${sections[index]} : ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
        
          Expanded(child: _buildEditableField(label: "Name", controller: nameControllers[index], isEditingNotifier: isNameEditing[index])),
          const SizedBox(width: 10),
          Expanded(child: _buildEditableField(label: "Email", controller: emailControllers[index], isEditingNotifier: isEmailEditing[index])),
        ],
      ),
    );
  }

  Widget _buildEditableField({required String label, required TextEditingController controller, required ValueNotifier<bool> isEditingNotifier}) {
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
                labelStyle:TextStyle( color: primaryGreenColors, fontWeight: FontWeight.bold,fontSize: 18) ,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryGreenColors),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryGreenColors),
                ),
              ),
              style: TextStyle(fontSize: 16, color: Colors.grey[850]),
            ),
            if (isEditing)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      isEditingNotifier.value = false; // Hide Save button after saving
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text("Save", style: TextStyle(fontSize: 14, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
