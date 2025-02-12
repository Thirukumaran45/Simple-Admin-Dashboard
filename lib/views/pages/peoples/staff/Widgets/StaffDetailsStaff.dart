
import 'package:admin_pannel/controller/StafffController.dart';
import 'package:admin_pannel/views/widget/CustomNavigation.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaffDetailsTab extends StatefulWidget {
  const StaffDetailsTab({super.key});

  @override
  State<StaffDetailsTab> createState() => _StaffDetailsTabState();
}

class _StaffDetailsTabState extends State<StaffDetailsTab> {
  String name = '';
  String phoneNumber = '';
  String emailAddress = '';

  StaffController controller = Get.find();
  List<Map<String, String>> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = List.from(controller.staffData);
  }

  void applyFilters() {
    setState(() {
      filteredData = controller.staffData.where((staff) {
        final matchesName = name.isEmpty ||
            staff['name']!.toLowerCase().contains(name.toLowerCase());
        final matchesPhoneNumber =
            phoneNumber.isEmpty || staff['phone']!.contains(phoneNumber);
        final matchesEmailAddress = emailAddress.isEmpty ||
            staff['email']!
                .toLowerCase()
                .contains(emailAddress.toLowerCase());
        return matchesName && matchesPhoneNumber && matchesEmailAddress;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
    
      customIconNavigation(context, '/manage-working-staff'),
    
            const Text(" Filter by : ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(
              width: 150,
              child: TextField(
                decoration:  InputDecoration(
                  labelText: 'Search by Name',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
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
                decoration:  InputDecoration(
                  labelText: 'Search by Phone',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
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
                decoration:  InputDecoration(
                  labelText: 'Search by Email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryGreenColors),
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
            customIconTextButton(primaryGreenColors,
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
                  DataColumn(label: Text('S.No', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  DataColumn(label: Text('Email Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  DataColumn(label: Text('Phone Number', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  DataColumn(label: Text('Update', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  DataColumn(label: Text('Delete', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                ],
                rows: filteredData.map((staff) {
                  return DataRow(
                    cells: [
                      DataCell(Text(staff['sNo']!)),
                      DataCell(Text(staff['name']!)),
                      DataCell(Text(staff['email']!)),
                      DataCell(Text(staff['phone']!)),
                      DataCell(SizedBox(
                        width: 150,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                          foregroundColor:Colors.white,
                          backgroundColor:
                            primaryGreenColors, // Button background color
                          elevation: 10, // Elevation for shadow effect
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12), // Button padding
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                        ),
                          onPressed: () {
                            Beamer.of(context).beamToNamed('/manage-working-staff/viewStaffDetails/editWorkingStaffDetails');
                          },
                          child: const Text('View More',style: TextStyle(fontSize: 14),),
                        ),
                      )),
                      DataCell(SizedBox(
                        width: 150,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
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
                          onPressed: () {},
                          child: const Row(
                            children: [Icon(Icons.delete_sharp, color: Colors.white), Text(' Delete',style: TextStyle(fontSize: 14),)],
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
    );
  }
}