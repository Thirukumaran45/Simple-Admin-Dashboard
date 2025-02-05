
import 'package:admin_pannel/controller/TeacherController.dart';
import 'package:admin_pannel/views/widgets/peoples/Teachers/Widgets/TeacherEditDownload.dart';
import 'package:admin_pannel/views/widgets/peoples/widgets/CustomeButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherDetailsTab extends StatefulWidget {
  const TeacherDetailsTab({super.key});

  @override
  State<TeacherDetailsTab> createState() => _TeacherDetailsTabState();
}

class _TeacherDetailsTabState extends State<TeacherDetailsTab> {
  String name = '';
  String phoneNumber = '';
  String emailAddress = '';

  
Teachercontroller controller = Get.find();
  List<Map<String, String>> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = List.from(controller.teacherData);
  }

  void applyFilters() {
    setState(() {
      filteredData = controller.teacherData.where((teacher) {
        final matchesName = name.isEmpty ||
            teacher['name']!.toLowerCase().contains(name.toLowerCase());
        final matchesPhoneNumber =
            phoneNumber.isEmpty || teacher['phone']!.contains(phoneNumber);
        final matchesEmailAddress = emailAddress.isEmpty ||
            teacher['email']!
                .toLowerCase()
                .contains(emailAddress.toLowerCase());
        return matchesName && matchesPhoneNumber && matchesEmailAddress;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [const
              Text(" Filter by Options : ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              SizedBox(
                width: 150,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search by Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 150,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search by Phone',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                  },
                ),
              ),
              SizedBox(
                width: 150,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search by Email',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      emailAddress = value;
                    });
                  },
                ),
              ),
              customIconTextButton(Colors.blue,
                  icon: Icons.search, onPressed: applyFilters, text: "Search"),
              customIconTextButton(Colors.green,
                  icon: Icons.download_sharp,
                  onPressed: applyFilters,
                  text: "Download"),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                child: DataTable(
                  columns: const [
                    DataColumn(
                        label: Text(
                      'S.No',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
                    DataColumn(
                        label: Text('Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(
                        label: Text('Graduated Degree Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(
                        label: Text('Email Address',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(
                        label: Text('Phone Number',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),   DataColumn(
                        label: Text('Update',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    DataColumn(
                        label: Text('Delete',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                  ],
                  rows: filteredData.map((teacher) {
                    return DataRow(
                      cells: [
                        DataCell(Text(
                          teacher['sNo']!,
                        )),
                        DataCell(Text(teacher['name']!)),
                        DataCell(Text(teacher['degree']!)),
                        DataCell(Text(teacher['email']!)),
                        DataCell(Text(teacher['phone']!)), DataCell(SizedBox(width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                            showDialog(
  context: context,
  builder: (BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Main content of the dialog
          Container(
            width: MediaQuery.of(context).size.width * 0.6, // 80% of the screen width
            height: MediaQuery.of(context).size.height * 0.9, // 80% of the screen height
            padding: const EdgeInsets.all(20
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 50),
              child: TeacherEditDownload(),
            ),
          ),
          // Close button at the top-right corner
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  },
);

                            },
                            child: const Text('View More'),
                          ),
                        )),
                        DataCell(SizedBox(width:150 ,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red, // Button background color
                              elevation: 10, // Elevation for shadow effect
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12), // Button padding
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20), // Rounded corners
                              ),
                            ),
                            onPressed: () {
                              // Implement view more functionality
                            },
                            child: const Row(
                              children: [ Icon(Icons.delete_sharp , color: Colors.white,),
                                 Text(' Delete'),
                              ],
                            ),
                          ),
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
