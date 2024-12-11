import 'package:admin_pannel/controller/dashboardController.dart';
import 'package:admin_pannel/views/widgets/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  Get.put(DashboardController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: " Admin Dashboard",
      theme: ThemeData(useMaterial3: true),
      home: Dashboard(),
    );
  }
}
