import 'package:admin_pannel/views/widgets/peoples/Students/Widgets/AddStudent.dart';
import 'package:admin_pannel/views/widgets/peoples/widgets/CustomeTabs.dart';
import 'package:admin_pannel/views/widgets/peoples/Students/Widgets/StudentDetailTab.dart';
import 'package:flutter/material.dart';

class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  late PageController _pageController;
  int _selectedIndex = 0; // Track the currently selected button

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onButtonTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom tab buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTabButton(
                selectedIndex: _selectedIndex,
                onTap: _onButtonTap,
                text: "Student Details",
                index: 0,
                icon: Icons.people,
              ),
              buildTabButton(
                selectedIndex: _selectedIndex,
                onTap: _onButtonTap,
                text: "Add New Student",
                index: 1,
                icon: Icons.add_circle_outline_sharp,
              ),
            ],
          ),
          Expanded(
            // PageView for switching between tabs
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index; // Sync selected button
                });
              },
              children: const [
                StudentDetailsTab(),
                AddStudentTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
