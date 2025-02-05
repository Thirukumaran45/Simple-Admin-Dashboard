import 'package:admin_pannel/views/widgets/peoples/widgets/CustomeButton.dart';
import 'package:flutter/material.dart';

class TeacherEditDownload extends StatefulWidget {
  const TeacherEditDownload({super.key});

  @override
  _StudentEditDownloadState createState() => _StudentEditDownloadState();
}

class _StudentEditDownloadState extends State<TeacherEditDownload> {
  // Sample data for the student (using TextEditingController for editable fields)
  late TextEditingController firstNameController;
  late TextEditingController degreeController;
  late TextEditingController phoneNumberController;
  late TextEditingController emailController;
  late TextEditingController homeAddressController;
  late TextEditingController dobController;
  late TextEditingController emplymentDateController;
  late TextEditingController experienceController;

  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    experienceController = TextEditingController(text: "5 years");
    firstNameController = TextEditingController(text: " dong lee ");
    degreeController = TextEditingController(text: "B.E Computer science and engineering");
    phoneNumberController = TextEditingController(text: "9876543210");
    emailController = TextEditingController(text: "johndoe@example.com");
    homeAddressController = TextEditingController(text: "123 Main St, Apartment 456, City, Country");
    dobController = TextEditingController(text: "01/01/2000");
    emplymentDateController = TextEditingController(text: "12/1/2025");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
             const Text(" T E A C H E R ", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35,color: Colors.red),),
              const SizedBox(height: 50),
              // Profile Photo
              Center(
                child: Stack(
                  children: [
                    Container(
                      width:350,
                      height: 450,
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
          child: customIconTextButton(Colors.blue, onPressed: (){}, icon: Icons.edit, text: "change")
        ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(" Thiru Kumaran N R", style: TextStyle(fontSize: 35,fontWeight: FontWeight.normal,color: Colors.black),),
              ),
             
            ],
          ),
       
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
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
                      const SizedBox(height: 50),
                      // Background container with school logo
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
                            _buildCustomRow("Teacher Name", firstNameController),
                            const SizedBox(height: 8),
                            _buildCustomRow("Graduated Degree", degreeController),
                            const SizedBox(height: 8),
                            _buildCustomRow("year of Experience", experienceController),
                            const SizedBox(height: 8),
                            _buildCustomRow("Employment Date", emplymentDateController),
                          
                            const SizedBox(height: 8),
                            _buildCustomRow("Phone Number", phoneNumberController),
                            const SizedBox(height: 8),
                            _buildCustomRow("Date of Birth", dobController),
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
                              child: Text(isEdited ? 'Save' : 'Edit'
                              ,  style: const TextStyle(color: Colors.white, fontSize: 20),
                              
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
                                foregroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              ),
                              child: const Text(
                                'Download',                                style: TextStyle(color: Colors.white, fontSize: 20),

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
              style: const TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            flex: 7,
            child: TextField(cursorColor :Colors.green,
              controller: controller,
              decoration: InputDecoration(border:  OutlineInputBorder( 
                
                  borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.green),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
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
