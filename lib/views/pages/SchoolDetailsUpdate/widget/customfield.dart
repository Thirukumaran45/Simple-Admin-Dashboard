

import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/controller/classControllers/schoolDetailsController/schooldetailsController.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';

class Customfield extends StatefulWidget {
  final SchooldetailsController controller;
  
  const Customfield({super.key, required this.controller});

  @override
  State<Customfield> createState() => _CustomfieldState();
}

class _CustomfieldState extends State<Customfield> {
  bool isLoading = true;
  List<String> schoolPhotos = [];
  
  @override
  void initState() {
    super.initState();
    fetchGalleryImages();
  }
Future<void> fetchGalleryImages() async {
   List<String> images = await widget.controller.getGalleryImages();
   if (!mounted) return; // ✅ Check if widget is still in the tree
   setState(() {
     schoolPhotos.clear();
     schoolPhotos.addAll(images);
     isLoading = false;
   });
}


 Future<void> uploadImage() async {
   final pickedImage = await widget.controller.addPhoto();
   if (pickedImage != null) {
     await widget.controller.uploadImageGallery(image: pickedImage);
     if (mounted) {  // ✅ Check if widget is still in the tree
       fetchGalleryImages(); // ✅ Direct call, no need for setState()
     }
   }
}


Future<void> deleteImage(int index) async {
  if (index < schoolPhotos.length) {
    String imageUrl = schoolPhotos[index];
    await widget.controller.deleteImageFromGallery(imageUrl: imageUrl);
    if (mounted) { 
      setState(() => schoolPhotos.removeAt(index));
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: primaryRedShadeColrs,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(offset: Offset(4, 4), blurRadius: 5, color: Colors.black)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.grey, blurRadius: 10),
              ],
            ),
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.green,))
                : GridView.builder(
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
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                          
onTap: () {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            // Container with rounded corners
            Container(
              decoration: BoxDecoration(
                color: Colors.black, // You can choose a background color
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: InteractiveViewer(
                  child: Image.network(
                    schoolPhotos[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            // Positioned X button at the top-right corner
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                  decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
},


                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: NetworkImage(schoolPhotos[index]),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.grey, offset: Offset(2, 2))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: customIconTextButton(
                              Colors.red,
                              onPressed: () => deleteImage(index),
                              icon: Icons.delete,
                              text: "Delete",
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

Widget schoolDetailsGallery(BuildContext context, SchooldetailsController controller) {
  // Create a GlobalKey to access the Customfield state
  final GlobalKey<_CustomfieldState> customfieldKey = GlobalKey<_CustomfieldState>();

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          onTap: () {
            customNvigation(context, '/school-details-updation/viewPhoto');
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: BoxDecoration(
              color: primaryYellowShadeColors,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(blurRadius: 10, color: Colors.grey),
              ],
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
                    fontSize: 20,
                  ),
                ),
                Icon(Icons.arrow_forward, size: 30, color: Colors.black),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "School Gallery Photos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          customIconTextButton(
            Colors.blue,
            onPressed: () async {
              // Use the GlobalKey to access the actual state
              await customfieldKey.currentState?.uploadImage();
            },
            icon: Icons.upload,
            text: "Add Photo",
          ),
        ],
      ),
      // Pass the key to the Customfield widget
      Customfield(key: customfieldKey, controller: controller),
      Padding(
        padding: const EdgeInsets.all(25),
        child: Center(
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Load more ...",
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
          ),
        ),
      ),
    ],
  );
}
