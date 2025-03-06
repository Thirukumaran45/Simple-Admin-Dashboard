
import 'package:admin_pannel/constant.dart';
import 'package:admin_pannel/provider/CustomNavigation.dart';
import 'package:admin_pannel/provider/pdfApi/PdfStaff/pdfStaffDetails.dart';
import 'package:admin_pannel/views/widget/CustomDialogBox.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';

class StaffEditDownload extends StatefulWidget {
  const StaffEditDownload({super.key});

  @override
  _StudentEditDownloadState createState() => _StudentEditDownloadState();
}

class _StudentEditDownloadState extends State<StaffEditDownload> {
  // Sample data for the student (using TextEditingController for editable fields)
  late TextEditingController firstNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController homeAddressController;

  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: " dong lee ");
    phoneNumberController = TextEditingController(text: "9876543210");
    emailController = TextEditingController(text: "johndoe@example.com");
    homeAddressController = TextEditingController(text: "123 Main St, Apartment 456, City, Country");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
              customIconNavigation(context, '/manage-working-staff/viewStaffDetails'),
        
                    
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                       children: [
          
                    
                      Center(
          child: Stack(
            children: [
              Container(
                width:320,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  image: const DecorationImage(
                    image: AssetImage("assets/images/profile.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ), Positioned(
                  bottom: 0,
                  right: 0,
                  child:  customIconTextButton(Colors.red, onPressed: (){
                  }, icon: Icons.edit, text: "Change")
                ),
                    ],
                       ),
                      ),
              
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.all(20),
                      child: const Text(" Thiru Kumaran N R",overflow:TextOverflow.visible , style: TextStyle(fontSize: 25,fontWeight: FontWeight.normal,color: Colors.black),)),
                   
                    ],
                    
          ),
                ],
              ),
                const SizedBox(
                      width: 20,
                    ),
          Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: 700,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/splash.png"),
                        fit: BoxFit.cover,
                        opacity: 0.1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCustomRow("Staff Name", firstNameController),
                      
                        const SizedBox(height: 8),
                        _buildCustomRow("Phone Number", phoneNumberController),
                        const SizedBox(height: 8),
                        const SizedBox(height: 8),
                        _buildCustomRow("Email", emailController),
                        const SizedBox(height: 8),
                        _buildCustomRow("Home Address", homeAddressController, maxLines: 2),
                        
                      
                        
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                    
                  // Action Buttons (Edit and Download)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Edit/Save Button
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async{
                            if (isEdited) {
                     await showCustomDialog(context, "Staff details Updated Succecfully");

                              setState(() {
                                isEdited = false;
                              });   }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: isEdited ? Colors.blue : Colors.grey,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: Text(isEdited ? 'Save' : 'Edit'
                          ,  style: const TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                          
                          ),
                        ),
                      ),
                      // Download Button
                      SizedBox(height: 50,
                        child: ElevatedButton(
                          onPressed: ()async {
                         await customSnackbar(context: context, text: "Downloaded Succesfully");
                         await PdfStaffDetails.openPdf(fileName: firstNameController.text, nameController: firstNameController, phoneNumberController: phoneNumberController, emailController: emailController, homeAddressController: homeAddressController);
                          },
                          style: ElevatedButton.styleFrom(
                         
                            foregroundColor: Colors.white,
                            backgroundColor: primaryGreenColors,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          ),
                          child: const  Text(
                            'Download',  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16, ),
                    
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom row builder for label and editable value
  Widget _buildCustomRow(String labelText, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: Text(
              labelText,
              style:  TextStyle(color: primaryGreenColors, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            flex: 7,
            child: TextField(cursorColor :primaryGreenColors,
             style: const TextStyle( color: Colors.black),
           
              controller: controller,
              decoration: InputDecoration(border:  OutlineInputBorder( 
                
                  borderRadius: BorderRadius.circular(8.0),
                borderSide:  BorderSide(color: primaryGreenColors),
              ),
              focusedBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: primaryGreenColors),
              ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
               
              ),
              maxLines: maxLines,
              onChanged: (value) {
                setState(() {
                  isEdited = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
