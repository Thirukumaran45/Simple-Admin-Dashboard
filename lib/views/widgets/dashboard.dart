import 'package:admin_pannel/controller/dashboardController.dart';
import 'package:admin_pannel/views/widgets/CustomerSection.dart';
import 'package:admin_pannel/views/widgets/InventorySection.dart';
import 'package:admin_pannel/views/widgets/OrderSection.dart';
import 'package:admin_pannel/views/widgets/ProductSection.dart';
import 'package:admin_pannel/views/widgets/SalesSection.dart';
import 'package:admin_pannel/views/widgets/StatisticSection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  final DashboardController controler = Get.find();
  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 204, 201, 194),
      body: Row(
        children: [
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: controler.sidebarOpen.value ? 200 : 60,
              color: Colors.red,
              child: _buildSideBar(),
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildHeader(),
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
          color: Colors.red,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize
                .min, // Ensure the Row is only as wide as its children
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  child: Row(
                    children: [
                      Icon(icon,
                          size: 20,
                          color: isSelected ? Colors.red : Colors.white),
                      if (controler.sidebarOpen.value)
                        const SizedBox(width: 15),
                      if (controler.sidebarOpen.value)
                        Text(
                          title,
                          style: TextStyle(
                              color: isSelected ? Colors.red : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal),
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
        Obx(
          () {
            if (controler.sidebarOpen.value) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Main Menu",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        Obx(() => Column(
              children: List.generate(
                  controler.section.length,
                  (index) => _buildSideBarItem(controler.section[index].icon,
                      controler.section[index].title, index)),
            ))
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => controler.toggleSlider(),
            child: Icon(Icons.menu),
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            " Welcome Back, Thiru",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Spacer(),
          Icon(
            Icons.logout,
            color: Colors.red,
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
            return Statisticsection();
          case 1:
            return Productsection();
          case 2:
            return OrderSection();
          case 3:
            return CustomerSection();
          case 4:
            return Inventorysection();
          case 5:
            return Salessection();
          default:
            return Center(
              child: Text("Data Not Found !"),
            );
        }
      },
    );
  }
}
