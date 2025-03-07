import 'package:admin_pannel/views/pages/LoginPage/LoginScreen.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Beamer.of(context).beamToNamed('/auth'); // Navigate to auth check
          },
          child: const Text('Go to Admin Panel'),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget _currentPage = const InitialPage();
  String _selectedMenu = 'Home';

  void _navigateTo(String title) {
    setState(() {
      _selectedMenu = title;
      _currentPage = title == 'Help' ? const LoginPage() : const InitialPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Menu(onItemSelected: _navigateTo, selectedMenu: _selectedMenu),
          ),
          Expanded(child: _currentPage),
        ],
      ),
    );
  }
}

class Menu extends StatelessWidget {
  final Function(String) onItemSelected;
  final String selectedMenu;

  const Menu({super.key, required this.onItemSelected, required this.selectedMenu});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _menuItem(title: 'Home', onTap: () => onItemSelected('Home')),
              _menuItem(title: 'About us', onTap: () => onItemSelected('About us')),
              _menuItem(title: 'Contact us', onTap: () => onItemSelected('Contact us')),
              _menuItem(title: 'Help', onTap: () => onItemSelected('Help')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuItem({required String title, required VoidCallback onTap}) {
    bool isActive = title == selectedMenu;
    return Padding(
      padding: const EdgeInsets.only(right: 75),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.green : Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? Colors.green : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
