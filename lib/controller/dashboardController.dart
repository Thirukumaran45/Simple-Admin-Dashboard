import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionModel {
  final String title;
  final IconData icon;

  SectionModel({required this.title, required this.icon});
}

class DashboardController extends GetxController {
  final RxInt currentSectionIndex = 0.obs;

  final RxBool sidebarOpen = false.obs;

  final RxList<SectionModel> section = <SectionModel>[
    SectionModel(title: "Overview", icon: Icons.home),
    SectionModel(title: "Attendance", icon: Icons.show_chart),
    SectionModel(title: "Students", icon: Icons.person),
    SectionModel(title: "Teachers", icon: Icons.school),
    SectionModel(title: "Working Staff", icon: Icons.people_alt_rounded),
    SectionModel(title: "Higher Officials", icon: Icons.business_center),
    SectionModel(title: "School Updates", icon: Icons.update),
    SectionModel(title: "Reset Year", icon: Icons.refresh),
    SectionModel(title: "Exam Updates", icon: Icons.edit),
    SectionModel(title: "Fees Updates", icon: Icons.currency_rupee),
    SectionModel(title: "Bus", icon: Icons.directions_bus),
  ].obs;

  void changeSection(int index) {
    currentSectionIndex.value = index;
  }

  void toggleSlider() {
    sidebarOpen.value = !sidebarOpen.value;
    update();
  }
}
