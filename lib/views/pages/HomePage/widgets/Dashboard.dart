
import '../../../../services/FireBaseServices/FirebaseAuth.dart' ;
import '../../../../contant/CustomNavigation.dart';
import '../../../../controller/classControllers/schoolDetailsController/schooldetailsController.dart';
import '../RoutingPage.dart';
import 'SideNav.dart';
import '../../../widget/CustomDialogBox.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get,Inst;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _beamerKey = GlobalKey<BeamerState>();
  late FirebaseAuthUser collectionVar;

  late SchooldetailsController controller;
 

  @override
  void initState() {
    super.initState();
    collectionVar = Get.find<FirebaseAuthUser>();
    controller=Get.find<SchooldetailsController>();
 
  }

Future<String?> _fetchSchoolName() async {
  final schoolDetails = await controller.getSchoolDetails(context);
  return schoolDetails.schoolName;
}

  Widget _buildHeader() {
     return FutureBuilder<String?>(
    future: _fetchSchoolName(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text("Loading...");
      }
      if (snapshot.hasError) {
        return const Text("Error loading school name");
      }
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 30),
           Row(
            children: [
             
              const SizedBox(width: 10),
              Text(
  snapshot.data ?? "Loading School Name...",  // Show "Loading..." until data is fetched
  style: const TextStyle(
    letterSpacing: 1,
    color: Colors.black,
    fontSize: 18,
  ),
),

            ],
          ),
          const Spacer(),
        const  Text(
            " Sign out",
            style: TextStyle(color: Colors.red, fontSize: 18,fontWeight: FontWeight.w800),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () async {
              final valu = await CustomDialogs().showCustomConfirmDialog(
        context: context, text: "Are you sure about to Sign-Out ?");
    
    if (valu == true) {
      if(!context.mounted)return;
      customPopNavigation(context, '/adminLogin');
      await collectionVar.signOutAccount(); // Sign out the user
    
     
    }

            },
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
              size: 30,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
     );
  }
  @override
  void dispose() {
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Row(
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 38, 153, 42),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: SideNav(beamer: _beamerKey),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const Divider(),
                      Expanded(
                        child: routingNameUri(
                          beamerKey: _beamerKey,
                          
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
    );
  }
}
