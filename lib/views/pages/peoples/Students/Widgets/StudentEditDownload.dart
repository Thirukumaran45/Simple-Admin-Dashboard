
import 'package:admin_pannel/provider/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';

class StudentEditDownload extends StatefulWidget {
  const StudentEditDownload({super.key});

  @override
  _StudentEditDownloadState createState() => _StudentEditDownloadState();
}

class _StudentEditDownloadState extends State<StudentEditDownload> {
  // Sample data for the student (using TextEditingController for editable fields)
  late TextEditingController studentNameController;
  late TextEditingController fatherNameController;
  late TextEditingController motherNameController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController homeAddressController;
  late TextEditingController dobController;
  late TextEditingController studentClassController;
  late TextEditingController sectionController;
  late TextEditingController currentYearController;

  late TextEditingController totalFeesController;
  late TextEditingController pendingFeesController;

  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    studentNameController = TextEditingController(text: "John Doe");
    fatherNameController = TextEditingController(text: "Mark Doe");
    motherNameController = TextEditingController(text: "Saroja samanikka");
    phoneNumberController = TextEditingController(text: "9876543210");
    emailController = TextEditingController(text: "johndoe@example.com");
    homeAddressController = TextEditingController(text: "123 Main St, Apartment 456, City, Country");
    dobController = TextEditingController(text: "01/01/2000");
    studentClassController = TextEditingController(text: "10th Grade");
    sectionController = TextEditingController(text: "A");
    currentYearController = TextEditingController(text: "2025");
    totalFeesController = TextEditingController(text: "1000.00");
    pendingFeesController = TextEditingController(text: "500.00");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Row(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                customIconNavigation(context,'/manage-student/viewStudentDetails'),
              
                Column(
                  children: [
                    const SizedBox(height: 30,),
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
                child: customIconTextButton(Colors.red, onPressed: (){}, icon: Icons.edit, text: "Change")
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
                      child: const Text(overflow:TextOverflow.visible ,"Govindhan Gopalan S", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),)),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(" 10 - A ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black)),],
                    ),
                      const  SizedBox(
                      height:150,
                    ), 
                  ],
                ),
              ], 
            ),
          const SizedBox(
                      width: 20,
                    ),
            Center(
              child: Material(
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
                            _buildCustomRow("Student Name", studentNameController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Class", studentClassController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Section", sectionController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Father's Name", fatherNameController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Mother's Name", motherNameController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Phone Number", phoneNumberController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Date of Birth", dobController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Email", emailController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Home Address", homeAddressController, maxLines: 2),
                            const SizedBox(height: 5),
                            _buildCustomRow("Total Fees", totalFeesController),
                            const SizedBox(height: 5),
                            _buildCustomRow("Pending Fees", pendingFeesController),
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
                              onPressed: () {
                                if (isEdited) {
                                  setState(() {
                                    isEdited = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Changes saved successfully")));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: isEdited ? Colors.blue : Colors.grey,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              ),
                              child: Text(isEdited ? 'Save' : 'Edit',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              
                              ),
                            ),
                          ),
                          // Download Button
                          SizedBox(height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Download functionality")));
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:primaryGreenColors ,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              ),
                              child: const Text(
                                'Download',
                                style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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

