
import 'package:admin_pannel/contant/constant.dart';
import 'package:admin_pannel/controller/classControllers/peoplesControlelr/HigherOfficialController.dart';
import 'package:admin_pannel/contant/CustomNavigation.dart';
import 'package:admin_pannel/contant/pdfApi/PdfOfficial/pdfTotalOfficialDetails.dart';
import 'package:admin_pannel/views/pages/peoples/widgets/CustomeTextField.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widget/CustomDialogBox.dart' show showCustomConfirmDialog;

class HigherOfficialDetailsTab extends StatefulWidget {
  const HigherOfficialDetailsTab({super.key});
 
  @override
  State<HigherOfficialDetailsTab> createState() => _TeacherDetailsTabState();
}

class _TeacherDetailsTabState extends State<HigherOfficialDetailsTab> {
  String name = '';
  String phoneNumber = '';
  String emailAddress = '';
Higherofficialcontroller controller = Get.find();
  List<Map<String, dynamic>> filteredData = [];
final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
  _scrollController.addListener(() {
  if (_scrollController.position.pixels ==
      _scrollController.position.maxScrollExtent) {
    controller.fetchMoreOfficials();
  }
});

     setState(() {
      filteredData = List.from(controller.officialData);
    });
  ever(controller.officialData, (_) {
    if (mounted) {
  setState(() {
    filteredData = List.from(controller.officialData);
  });
}
  });
  }

  void applyFilters() {
    setState(() {
      filteredData =controller.officialData .where((teacher) {
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
void dispose() {        // Properly dispose of the GetX Worker
  filteredData.clear();
     _scrollController.dispose();        // Clear the filtered list
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, 
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
        customIconNavigation(context, '/manage-higher-official'),
              
              const
              Text(" Filter by : ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
             customFilterBox(label: 'Search by name', onfunction:(value) {
                    setState(() {
                      name = value;
                    });
                     applyFilters();
                  }, ),
              customFilterBox(label: "Search by Phone.No", onfunction:  (value) {
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
                 await   customSnackbar(context: context, text: "Downloaded Succesfullly");
                   await  PdfTotalOfficialDetails().openPdf(fileName: "Higher Official Details $todayDateTime",officials:filteredData );
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
                        label: Text('Email Address',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                     DataColumn(
                        label: Text('Acting role',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16))),
                    
                      DataColumn(
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
                        DataCell(SizedBox(
                          width: MediaQuery.sizeOf(context).width*0.14,
                          
                        child: Text(teacher['name']!, style: const TextStyle(color: Colors.black),overflow: TextOverflow.ellipsis,))),
                        DataCell(SizedBox(
                          width: MediaQuery.sizeOf(context).width*0.14,

                          child: Text(teacher['email']!, style: const TextStyle(color: Colors.black),overflow: TextOverflow.ellipsis,))),
                        DataCell(Text(teacher['role']!, style: const TextStyle(color: Colors.black))),
                         DataCell(ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               foregroundColor: Colors.white,
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
                             customNvigation(context, '/manage-higher-official/viewHigherOfficailDetails/editHigherOfficialDetails?uid=${teacher['id']!}');
                            
                               
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
                          onPressed: ()async {           bool val = await showCustomConfirmDialog(context: context, text: "Sure about to delete?");
                          if (val) {
                            await controller.deleteOfficials(officialId: teacher['id']!,);
                           ever(controller.officialData, (_) {
                            setState(() {
                              filteredData = List.from(controller.officialData);
                            });
                          });
                          }
                          },
                          child: const Row(
                            children: [ Icon(Icons.delete_sharp , color: Colors.white,),
                               Text(' Delete',style: TextStyle(fontSize: 14),),
                            ],
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