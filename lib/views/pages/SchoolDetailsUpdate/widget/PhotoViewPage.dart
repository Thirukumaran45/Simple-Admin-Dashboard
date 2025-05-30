
import 'package:admin_pannel/utils/ExceptionDialod.dart';

import '../../../../contant/CustomNavigation.dart';
import '../../../../controller/classControllers/schoolDetailsController/schooldetailsController.dart';
import '../../../widget/CustomDialogBox.dart';
import '../../../widget/CustomeButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:get/get.dart' show Get,Inst;

class Photoviewpage extends StatefulWidget {
  const Photoviewpage({super.key, });

  @override
  State<Photoviewpage> createState() => _PhotoviewpageState();
}

class _PhotoviewpageState extends State<Photoviewpage> {

  String? assetImage;
  String defaultSchoolPhoto ="assets/images/splash.svg";
  late SchooldetailsController controller;
@override
  void initState() {
    super.initState();
     controller=Get.find<SchooldetailsController>();
    initializeFunction();
  }
Future<void> handlePhotoUpdate() async {
  String? newPhotoUrl = await ExceptionDialog().handleExceptionDialog(context, ()async=> await  controller.updateSchoolPhorilfePhoto(context,));
  
  if (newPhotoUrl!.isNotEmpty&&mounted) { 
    setState(() {
      assetImage = newPhotoUrl; 
    });
  }
}

Future<void> initializeFunction() async {

   String? photoUrl =await ExceptionDialog().handleExceptionDialog(context, ()async=> await controller.getSchoolPhotoUrl(context,));

   if (!mounted) return; // ✅ Check before updating UI
   setState(() {
     assetImage = photoUrl ?? defaultSchoolPhoto;
       
   });
}

@override
  void dispose() {
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
          IconButton(
            onPressed: () => customNvigation(context, '/school-details-updation'),
            icon: const Icon(Icons.arrow_back),
          ),
          const Spacer(),
          Row(
            children: [
              customIconTextButton(Colors.red, onPressed: () async {
                bool? val = await ExceptionDialog().handleExceptionDialog(context, ()async=>await controller.deleteSchoolPhoto(context,));
                if (val!) {
                  if (!context.mounted) return;
                  bool isUpdate = await CustomDialogs().showCustomConfirmDialog(context: context, text: "Succesfully deleted, back to the page?");
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
        ? const CircularProgressIndicator(color: Colors.green)
        : assetImage!.endsWith(".svg")
            ? SvgPicture.asset(assetImage!) // for local assets
            : InteractiveViewer(
                child: Image.network(assetImage!), // for network images
              ),
  )
  );
}
}