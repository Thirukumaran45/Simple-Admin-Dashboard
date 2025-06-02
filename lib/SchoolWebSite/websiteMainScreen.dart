
import 'package:admin_pannel/SchoolWebSite/widgets/webDivision/educationLevels.dart';
import 'package:admin_pannel/SchoolWebSite/widgets/webDivision/erpFeature.dart';
import 'package:admin_pannel/SchoolWebSite/widgets/webDivision/examScore.dart';
import 'package:admin_pannel/SchoolWebSite/widgets/webDivision/footer.dart';
import 'package:admin_pannel/SchoolWebSite/widgets/webDivision/header.dart';
import 'package:admin_pannel/SchoolWebSite/widgets/webDivision/parentFeedback.dart';
import 'package:admin_pannel/SchoolWebSite/widgets/webDivision/schoolDetails.dart';
import 'package:admin_pannel/SchoolWebSite/widgets/webDivision/sportsGame.dart';
import 'package:admin_pannel/contant/CustomNavigation.dart' show customNvigation;
import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _schoolKey = GlobalKey();
  final GlobalKey _examScoreKey = GlobalKey();
  final GlobalKey _feedbackKey = GlobalKey();
  final GlobalKey _erpKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderButtons(
            onTap: (index) {
              switch (index) {
                case 0:
                  _scrollToSection(_schoolKey);
                  break;
                case 1:
                  _scrollToSection(_examScoreKey);
                  break;
                case 2:
                  _scrollToSection(_feedbackKey);
                  break;
                case 3:
                  _scrollToSection(_erpKey);
                  break;
                case 4:
                 customNvigation(context, "/adminLogin");                  
                  break;
                case 5:
                  _scrollToSection(_contactKey);
                  break;
              }
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(key: _schoolKey, child: const SchoolDetailsSection()),
                  const SizedBox(height: 20),
                  EducationLevelsSection(),
                  const SizedBox(height: 70),
                  Container(key: _examScoreKey, child: const ExamScoreSection()),
                  const SizedBox(height: 70),
                  SportsGamesSection(),
                  const SizedBox(height: 40),
                   Container(key: _erpKey, child: ERPFeaturesSection()),
                  const SizedBox(height: 40),
                  Container(key: _feedbackKey, child: const ParentFeedbackSection()),
                  const SizedBox(height: 40),
                  Container(key: _contactKey, child: const FooterSection()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



