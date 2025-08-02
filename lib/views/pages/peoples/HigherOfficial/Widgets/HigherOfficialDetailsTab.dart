
import 'package:admin_pannel/utils/ExceptionDialod.dart';

import '../../../../../contant/constant.dart';
import '../../../../../controller/classControllers/peoplesControlelr/HigherOfficialController.dart';
import '../../../../../contant/CustomNavigation.dart';
import '../../../../../contant/pdfApi/PdfOfficial/pdfTotalOfficialDetails.dart';
import '../../widgets/CustomeTextField.dart';
import '../../../../widget/CustomeButton.dart';
import '../../../../widget/CustomeColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst,ever;

import '../../../../widget/CustomDialogBox.dart';

class HigherOfficialDetailsTab extends StatefulWidget {
  const HigherOfficialDetailsTab({super.key});
 
  @override
  State<HigherOfficialDetailsTab> createState() => _TeacherDetailsTabState();
}

class _TeacherDetailsTabState extends State<HigherOfficialDetailsTab> {
  String name = '';
  String phoneNumber = '';
  String emailAddress = '';
 late Higherofficialcontroller controller ;
  List<Map<String, dynamic>> filteredData = [];
final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
     controller = Get.find<Higherofficialcontroller>();
  _scrollController.addListener(() async{
  if (_scrollController.position.pixels ==
      _scrollController.position.maxScrollExtent) {
    await ExceptionDialog().handleExceptionDialog(context, ()async=> controller.fetchMoreOfficials(context));
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
                    if(!context.mounted)return;

                   await  PdfTotalOfficialDetails().openPdf(context: context,fileName: "Higher Official Details $todayDateTime",officials:filteredData );
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
                          onPressed: () async {
  bool val = await CustomDialogs().showCustomConfirmDialog(context: context, text: "Sure about to delete?");
  if (val) {
    if (!context.mounted) return;
    CustomDialogs().showLoadingDialogInSec(context, 30, "Please wait a moment ...", onlyText: true);

    await ExceptionDialog().handleExceptionDialog(context, () async{
  final val =   await controller.deleteOfficials(context, officialId: teacher['id']!,);
  if(val){
   if (!context.mounted) return;
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    } 
  }
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