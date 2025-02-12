import 'dart:developer' show log;
import 'package:admin_pannel/controller/dashboardController.dart';
import 'package:admin_pannel/views/widget/CustomeColors.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideNav extends StatefulWidget {
  final GlobalKey<BeamerState> beamer;
  const SideNav({super.key, required this.beamer});

  @override
  State<SideNav> createState() => _sideNavState();
}

class _sideNavState extends State<SideNav> {
  int selected = -1;
late DashboardController dashboardController =Get.find();

 List<String> navItems =[];
   List<String> navs=[];
   List<IconData> navIcons =[];
  
@override
  void initState() {
    super.initState();
    navIcons = List.from( dashboardController.navIcons);
    navs = List.from(dashboardController.navs);
    navItems=List.from(dashboardController.navItems);
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
    }else if(path.contains('/school-details-updation'))
    {
      selected=8;
    }else if(path.contains('/live-bus-operation'))
    {
      selected=9;
    }else if(path.contains('/schoolYear-data-updation'))
    {
      selected=10;
    }
    return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage("assets/images/profile.png"),
                ),
                Positioned(
                  right: 5,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        // Define the action when the edit icon is pressed
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(navItems.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                key: ValueKey(navItems[index]),
                decoration: BoxDecoration(
                  color: selected == index ? Colors.white :primaryGreenColors, 
                   borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                      ),
                ),
                width: 225.0,
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
                            padding: const EdgeInsets.only(left: 18),
                            child: Icon(
                              size: 18,
                              navIcons[index],
                              color: selected == index ? Colors.black : Colors.white,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            navItems[index],
                            style: TextStyle(
                              fontSize: 14,
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
        ],
      ),
    ),);
  }
}