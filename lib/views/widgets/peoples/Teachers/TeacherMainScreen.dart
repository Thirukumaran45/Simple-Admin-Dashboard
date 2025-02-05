import 'package:admin_pannel/views/widgets/peoples/widgets/CustomeTabs.dart';
import 'package:admin_pannel/views/widgets/peoples/Teachers/Widgets/AddTeacherss.dart';
import 'package:admin_pannel/views/widgets/peoples/Teachers/Widgets/TeacherDetailTab.dart';
import 'package:flutter/material.dart';

class TeacherMainScreen extends StatefulWidget {
  const TeacherMainScreen({super.key});

  @override
  State<TeacherMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<TeacherMainScreen> {
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
                  text: "Teacher Details",
                  index: 0,
                  icon: Icons.people,
                  selectedIndex: _selectedIndex,
                  onTap: _onButtonTap),
              buildTabButton(
                  text: "Add New Teacher",
                  index: 1,
                  icon: Icons.add_circle_outline_sharp,
                  selectedIndex: _selectedIndex,
                  onTap: _onButtonTap),
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
                TeacherDetailsTab(),
                AddTeacherTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
