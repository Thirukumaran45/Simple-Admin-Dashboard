
import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/controller/classControllers/schoolController/schooldetailsController.dart';
import 'package:admin_pannel/views/widget/CustomDialogBox.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Photoviewpage extends StatefulWidget {
  const Photoviewpage({super.key, });

  @override
  State<Photoviewpage> createState() => _PhotoviewpageState();
}

class _PhotoviewpageState extends State<Photoviewpage> {

  String? assetImage;
  String defaultSchoolPhoto ="assets/images/splash.png";
  SchooldetailsController controller=Get.find();
@override
  void initState() {
    super.initState();
    initializeFunction();
  }
Future<void> handlePhotoUpdate() async {
  String newPhotoUrl = await  controller.updateSchoolPhorilfePhoto();
  
  if (newPhotoUrl.isNotEmpty&&mounted) { 
    setState(() {
      assetImage = newPhotoUrl; 
    });
  }
}

Future<void> initializeFunction() async {

   String? photoUrl = await controller.getSchoolPhotoUrl();

   if (!mounted) return; // ✅ Check before updating UI
   setState(() {
     assetImage = photoUrl ?? defaultSchoolPhoto;
       
   });
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
          IconButton(
            onPressed: () => customNvigation(context, '/school-details-updation'),
            icon: const Icon(Icons.arrow_back),
          ),
          const Spacer(),
          Row(
            children: [
              customIconTextButton(Colors.red, onPressed: () async {
                bool val = await controller.deleteSchoolPhoto();
                if (val) {
                  if (!context.mounted) return;
                  bool isUpdate = await showCustomConfirmDialog(context: context, text: "Succesfully deleted, back to the page?");
                  if (!context.mounted) return;
                  if (isUpdate) customNvigation(context, '/school-details-updation');
                }
              }, icon: Icons.delete_rounded, text: "Delete"),
              const SizedBox(width: 40,),
              customIconTextButton(Colors.blue, onPressed: () async {
                await handlePhotoUpdate();
              }, icon: Icons.add_a_photo_rounded, text: "Update")
            ],
          )
        ],
      ),
    ),
    body: Center(
      child: assetImage == null
          ? const CircularProgressIndicator() // Show a loader until the image is loaded
          : InteractiveViewer(
              child: Image.network(assetImage!,),
            ),
    ),
  );
}
}