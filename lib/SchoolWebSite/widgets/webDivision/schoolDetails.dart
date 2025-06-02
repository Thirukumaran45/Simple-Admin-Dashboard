import 'dart:async';
import 'package:admin_pannel/SchoolWebSite/widgets/customWebcolor.dart';
import 'package:flutter/material.dart';

class SchoolDetailsSection extends StatefulWidget {
  const SchoolDetailsSection({super.key});

  @override
  State<SchoolDetailsSection> createState() => _SchoolDetailsSectionState();
}

class _SchoolDetailsSectionState extends State<SchoolDetailsSection> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  late Timer _timer;

  // Replace these with your actual asset paths (up to 10 images).
  final List<String> svgList = [
    'assets/webImages/students/1220.webp',
    'assets/webImages/students/4131.webp',
    'assets/webImages/students/1.webp',
    'assets/webImages/students/2.webp',
    'assets/webImages/students/3.webp',
  ];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    // 1) Precache all images after the first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final assetPath in svgList) {
        precacheImage(AssetImage(assetPath), context);
      }
    });

    // 2) Start the auto‐scroll timer
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % svgList.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: "About Us" text
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text('About Us .,', style: AppTextStyles.aboutUsStyle),
                const SizedBox(height: 16),
                Text(
                  textAlign: TextAlign.justify,
                  '''\nNag Vidhyashraam CBSE School, located in the heart of Tamil Nadu, is a premier educational institution dedicated to fostering academic excellence and holistic development. Affiliated with the Central Board of Secondary Education (CBSE), the school offers a dynamic and student-centric curriculum designed to empower young minds with knowledge, values, and life skills. Our school provides a nurturing and inclusive environment where students are encouraged to explore their potential across academics, sports, arts, and co-curricular activities. With a strong emphasis on discipline, innovation, and character building, Nag Vidhyashraam ensures every child grows into a confident and responsible individual.''',
                  style: AppTextStyles.paragraph,
                ),
              ],
            ),
          ),

          const SizedBox(width: 40),

          // Right side: Auto‐scrolling image carousel
          Expanded(
            flex: 1,
            child: SizedBox(
              height: 500, // adjust height as needed
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: svgList.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          // Optional scale effect
                          double value = 1.0;
                          if (_pageController.position.haveDimensions) {
                            value = (_pageController.page! - index).abs();
                            value = (1 - (value * 0.3)).clamp(0.7, 1.0);
                          }
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(4, 8),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                svgList[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // (No change to dots or other elements)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
