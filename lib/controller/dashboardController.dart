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
    SectionModel(title: "statistics", icon: Icons.show_chart),
    SectionModel(title: "Products", icon: Icons.shopping_bag),
    SectionModel(title: "Orders", icon: Icons.list_alt),
    SectionModel(title: "Customer", icon: Icons.people),
    SectionModel(title: "Inventory", icon: Icons.inventory),
    SectionModel(title: "sales", icon: Icons.attach_money),
  ].obs;

  Future<List<Map<String, dynamic>>> fetchData() async {
    await Future.delayed(Duration(seconds: 1));
    return List.generate(
      5,
      (index) => {
        'Product Name': 'product $index',
        'Sales': '\$${(index + 1) * 1000}',
        'Stocks': '${(index + 1) * 20}units',
        'Catagory': 'Catagory $index',
        'Date Added': '2024/12/1${index + 1}',
        'Total Revenue': '\$${(index + 1) * 5000}',
        'Average Order Value': '\$${(index + 1) * 50}',
        'Customer Count': (index + 1) * 100,
      },
    );
  }

  void changeSection(int index) {
    currentSectionIndex.value = index;
  }

  void toggleSlider() {
    sidebarOpen.value = !sidebarOpen.value;
  }
}
