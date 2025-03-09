import 'package:admin_pannel/FireBaseServices/CollectionVariable.dart';
import 'package:admin_pannel/constant.dart';
import 'package:admin_pannel/views/pages/HomePage/RoutingPage.dart';
import 'package:admin_pannel/views/pages/HomePage/widgets/SideNav.dart';
import 'package:admin_pannel/views/widget/CustomDialogBox.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _beamerKey = GlobalKey<BeamerState>();
  late FirebaseCollectionVariable collectionVar;
 

  @override
  void initState() {
    super.initState();
    collectionVar = Get.find();
   
    
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 30),
          Row(
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage("assets/images/splash.png"),
              ),
              const SizedBox(width: 10),
              Text(
                schoolName,
                style: TextStyle(
                  color: Colors.grey[950],
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            " Welcome Back, Teacher",
            style: TextStyle(color: Colors.grey[950], fontSize: 18),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () async {
              final valu = await showCustomConfirmDialog(
        context: context, text: "Are you sure about to Sign-Out ?");
    
    if (valu == true) {
       Beamer.of(context).beamToReplacementNamed(
        '/adminLogin',
       );
      await collectionVar.signOutAccount(); // Sign out the user
      
     
    }

            },
            icon: const Icon(
              Icons.logout,
              color: Colors.green,
              size: 30,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
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
