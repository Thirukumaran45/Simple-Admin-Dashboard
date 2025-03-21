
import 'package:admin_pannel/constant.dart';
import 'package:admin_pannel/controller/HigherOfficialController.dart';
import 'package:admin_pannel/provider/CustomNavigation.dart';
import 'package:admin_pannel/provider/pdfApi/PdfOfficial/pdfTotalOfficialDetails.dart';
import 'package:admin_pannel/views/widget/CustomeButton.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  List<Map<String, String>> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = List.from(controller.officialData);
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

Widget customFilterBox  ( { required String label, required Function(String)?  onfunction })
{
  return  SizedBox(
              width: 150,
              child: TextField(
                decoration:  InputDecoration(
                  labelText: label,
                  labelStyle:const TextStyle(color: Colors.black) ,
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
                onChanged:onfunction
              ),
            );
} 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
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
                   await  PdfTotalOfficialDetails.openPdf(fileName: "Higher Official Details $todayDateTime",officials:filteredData );
                    applyFilters();},
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
                        DataCell(Text(teacher['name']!, style: const TextStyle(color: Colors.black))),
                        DataCell(Text(teacher['email']!, style: const TextStyle(color: Colors.black))),
                        DataCell(Text(teacher['phone']!, style: const TextStyle(color: Colors.black))), DataCell(SizedBox(width: 150,
                          child: ElevatedButton(
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
                              customNvigation(context, '/manage-higher-official/viewHigherOfficailDetails/editHigherOfficialDetails');
                             
      
                            },
                            child: const Text('View More',style: TextStyle(fontSize: 14),),
                          ),
                        )),
                        DataCell(SizedBox(width:150 ,
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
                            onPressed: () {
                              // Implement view more functionality
                            },
                            child: const Row(
                              children: [ Icon(Icons.delete_sharp , color: Colors.white,),
                                 Text(' Delete',style: TextStyle(fontSize: 14),),
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
