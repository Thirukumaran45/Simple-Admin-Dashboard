import 'package:admin_pannel/controller/dashboardController.dart';
import 'package:admin_pannel/views/widgets/Attendance/AttendanceMainScreen.dart';
import 'package:admin_pannel/views/widgets/peoples/staff/staff.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Bus/BusUpdateMainScreen.dart';
import '../ExamUpdate/ExamUpdateScreen.dart';
import '../Fees/FeesUpdateScreen.dart';
import '../peoples/HigherOfficial/HigherOfficialMainScreen.dart';
import 'HomePage.dart';
import '../ResetYear/ResetSchoolYearScreen.dart';
import '../School/SchoolUpdateMainScreen.dart';
import '../peoples/Students/StudentMainScreen.dart';
import '../peoples/Teachers/TeacherMainScreen.dart';

class Dashboard extends StatelessWidget {
  final DashboardController controler = Get.find();
  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 201, 194),
      body: Row(
        children: [
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: controler.sidebarOpen.value ? 250 : 60,
              color: Colors.green,
              child: _buildSideBar(),
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildHeader(),
                const Divider(),
                Expanded(child: _buildContent()),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildSideBarItem(IconData icon, String title, int index) {
    return Obx(() {
      final isSelected = controler.currentSectionIndex.value == index;
      return GestureDetector(
        onTap: () =>
            controler.changeSection(index), // Correctly call the function
        child: Container(
          color: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.green,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Row(
                    children: [
                      Icon(icon,
                          size: 20,
                          color: isSelected ? Colors.green : Colors.white),
                      if (controler.sidebarOpen.value)
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              title,
                              style: TextStyle(
                                  color:
                                      isSelected ? Colors.green : Colors.white,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSideBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Column(
            children: [
              if (!controler.sidebarOpen.value)
                const SizedBox(
                  height:
                      58, // Add space above the icons when the sidebar is closed
                ),
              if (controler.sidebarOpen.value)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            AssetImage("assets/images/profile.png"),
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
                children: List.generate(
                  controler.section.length,
                  (index) => _buildSideBarItem(
                    controler.section[index].icon,
                    controler.section[index].title,
                    index,
                  ),
                ),
              ),
            ],
          );
        })
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => controler.toggleSlider(),
            child: const Icon(Icons.menu),
          ),
          const SizedBox(
            width: 30,
          ),
          const Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/images/splash.png"),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                " Nag Vidhyashram CBSE School , Poonamalle , Chennai - 600056 ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Text(
            " Welcome Back, Teacher",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.logout,
            color: Colors.green,
            size: 30,
          )
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Obx(
      () {
        switch (controler.currentSectionIndex.value) {
          case 0:
            return const Homepage();
          case 1:
            return const AttendanceMainScreen();
          case 2:
            return const StudentMainScreen();
          case 3:
            return const TeacherMainScreen();
          case 4:
            return const StaffMainScreen();
           case 5:
            return const HigherOfficialMainScreen(); 
          case 6:
            return const SchoolUpdateMainScreen();
          case 7:
            return const ResetSchoolYearScreen();
          case 8:
            return const ExamUpdateScreen();
          case 9:
            return const FeesUpdateScreen();
          case 10:
            return const BusUpdateMainScreen();
          default:
            return const Center(
              child: Text("Data Not Found !"),
            );
        }
      },
    );
  }
}
