import 'dart:developer' show log;
import '../../../../controller/classControllers/pageControllers/DashboardController.dart';
import '../../../../controller/classControllers/schoolDetailsController/schooldetailsController.dart';
import '../../../widget/CustomeColors.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:get/get.dart' show Get, Inst;

class SideNav extends StatefulWidget {
  final GlobalKey<BeamerState> beamer;
  const SideNav({super.key, required this.beamer});

  @override
  State<SideNav> createState() => _sideNavState();
}

// ignore: camel_case_types
class _sideNavState extends State<SideNav> {
  int selected = 0;
  late DashboardController dashboardController;

 List<String> navItems =[];
   List<String> navs=[];
   List<IconData> navIcons =[];
  String? assetImage;
  String defaultSchoolPhoto ="assets/images/splash.svg";
 late SchooldetailsController controller;

@override
  void initState() {
    super.initState();
    controller=Get.find<SchooldetailsController>();
    dashboardController =Get.find<DashboardController>();
    navIcons = List.from( dashboardController.navIcons);
    navs = List.from(dashboardController.navs);
    navItems=List.from(dashboardController.navItems);
    initializeFunction();
  } 

  Future<void> initializeFunction() async {
   String? photoUrl = await controller.getSchoolPhotoUrl();

   if (!mounted) return; // ✅ Check before updating UI
   setState(() {
     assetImage = photoUrl ;
       
   });
}
@override
  void dispose() {
    super.dispose();
  }
@override
  Widget build(BuildContext context) {
    final path = (context.currentBeamLocation.state as BeamState).uri.path;
    log(path);
    if(path.contains('/home')){
      selected = 0;
    }
    else if(path.contains('/attendance'))
    {
      selected=1;
    } else if(path.contains('/fees-updation'))
    {
      selected=2;
    } else if(path.contains('/exam-Details-updation'))
    {
      selected=3;
    } else if(path.contains('/manage-student'))
    {
      selected=4;
    }else if(path.contains('/manage-teacher'))
    {
      selected=5;
    }else if(path.contains('/manage-higher-official'))
    {
      selected=6;
    }else if(path.contains('/manage-working-staff'))
    {
      selected=7;
    }
    else if(path.contains('/school-timeTable'))
    {
      selected=8;
    }
    else if(path.contains('/school-details-updation'))
    {
      selected=9;
    }
    else if(path.contains('/bonafied'))
    {
      selected=10;
    }
    else if(path.contains('/live-bus-operation'))
    {
      selected=11;
    }else if(path.contains('/schoolYear-data-updation'))
    {
      selected=12;
    }

    return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [

Padding(
  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
  child: Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.green.withAlpha(80), // subtle white glow
          spreadRadius: 5,
          blurRadius: 5,
        ),
      ],
    ),
    child: ClipOval(
      child: SizedBox(
        height: 130,
        width: 130,
        child: assetImage == null
            ? SvgPicture.asset(
                defaultSchoolPhoto,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              )
            : Image.network(
                assetImage!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
      ),
    ),
  ),
),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(navItems.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                key: ValueKey(navItems[index]),
                decoration: BoxDecoration(
                  color: selected == index ? Colors.white :primaryGreenColors, 
                   borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                ),
                width: 248.0,
                child: Material(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  // clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.beamer.currentState?.routerDelegate
                            .beamToNamed(navs[index]);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(11),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 22),
                            child: Icon(
                              size: 19,
                              navIcons[index],
                              color: selected == index ? Colors.black : Colors.white,
                            ),
                          ),
                          const SizedBox(width: 25),
                          Text(
                            navItems[index],
                            style: TextStyle(
                              fontSize: 15,
                              color: selected == index ? Colors.black : Colors.white,
                              fontWeight:selected == index ? FontWeight.bold :FontWeight.normal
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 30,)
        ],
        
      ),
    ),);
  }
}