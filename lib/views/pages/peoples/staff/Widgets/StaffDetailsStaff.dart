
import 'package:admin_pannel/contant/constant.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/StafffController.dart';
import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/contant/pdfApi/PdfStaff/pdfTotalstaffDetails.dart';
import 'package:admin_pannel/views/pages/peoples/widgets/CustomeTextField.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widget/CustomDialogBox.dart' show showCustomConfirmDialog;

class StaffDetailsTab extends StatefulWidget {
  const StaffDetailsTab({super.key});
 
  @override
  State<StaffDetailsTab> createState() => _StaffDetailsTabState();
}

class _StaffDetailsTabState extends State<StaffDetailsTab> {
  String name = '';
  String phoneNumber = '';
  String emailAddress = '';
final ScrollController _scrollController = ScrollController();
  StaffController controller = Get.find();
  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
     setState(() {
      filteredData = List.from(controller.staffData);
    });
  ever(controller.staffData, (_) {
    if(mounted)
    {
   setState(() {
      filteredData = List.from(controller.staffData);
    });
    }
    
  });

  _scrollController.addListener(() {
  if (_scrollController.position.pixels ==
      _scrollController.position.maxScrollExtent) {
    controller.fetchStaffData();
  }
});

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
void dispose() {        // Properly dispose of the GetX Worker
  filteredData.clear();
   _scrollController.dispose();          // Clear the filtered list
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
        
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
      
        customIconNavigation(context, '/manage-working-staff'),
      
              const Text(" Filter by : ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
             customFilterBox(label: "Search by name", onfunction: (value) {
                    setState(() {
                      name = value;
                    });
                     applyFilters();
                  },),
             customFilterBox(label: "Search by Phone.no", onfunction:  (value) {
                    setState(() {
                      phoneNumber = value;
                    });
                     applyFilters();
                  },),
             customFilterBox(label: "Search by Email", onfunction: (value) {
                    setState(() {
                      emailAddress = value;
                    });
                     applyFilters();
                  },),
              customIconTextButton(Colors.blue,
                  icon: Icons.search, onPressed: applyFilters, text: "Search"),
              customIconTextButton(primaryGreenColors,
                  icon: Icons.download_sharp,
                  onPressed:() async{
                    await customSnackbar(context: context, text: "Downloaded Succesfully");
                    await PdfTotalStaffDetails().openPdf(fileName: "Working Staff Details $todayDateTime",staff: filteredData);
                    applyFilters();},
                  text: "Download"),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
                controller: _scrollController, 
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
                        DataCell(Text(staff['sNo']!, style: const TextStyle(color: Colors.black))),
                        DataCell(SizedBox(
                          width: MediaQuery.sizeOf(context).width*0.07,

                          child: Text(staff['name']!, style: const TextStyle(color: Colors.black),overflow: TextOverflow.ellipsis,))),
                        DataCell(SizedBox(
                          width: MediaQuery.sizeOf(context).width*0.14,

                          child: Text(staff['email']!, style: const TextStyle(color: Colors.black),overflow: TextOverflow.ellipsis,))),
                        DataCell(Text(staff['phone']!, style: const TextStyle(color: Colors.black))),
                        DataCell(ElevatedButton(
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
                            customNvigation(context, '/manage-working-staff/viewStaffDetails/editWorkingStaffDetails?uid=${staff['id']!}');
                            },
                          child: const Text('View More',style: TextStyle(fontSize: 14),),
                        )),
                        DataCell(ElevatedButton(
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
                          onPressed: ()async {
                          bool val = await showCustomConfirmDialog(context: context, text: "Sure about to delete?");
                          if (val) {
                            await controller.deleteStaffs(staffId: staff['id']!,);
                           ever(controller.staffData, (_) {
                            setState(() {
                              filteredData = List.from(controller.staffData);
                            });
                          });
                          }
                        
                          },
                          child: const Row(
                            children: [Icon(Icons.delete_sharp, color: Colors.white), Text(' Delete',style: TextStyle(fontSize: 14),)],
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