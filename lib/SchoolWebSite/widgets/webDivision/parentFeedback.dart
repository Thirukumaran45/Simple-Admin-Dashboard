import 'dart:async' show Timer;
import 'package:admin_pannel/SchoolWebSite/widgets/customWebcolor.dart';
import 'package:flutter/material.dart';

class ParentFeedbackSection extends StatefulWidget {
  const ParentFeedbackSection({super.key});

  @override
  State<ParentFeedbackSection> createState() => _ParentFeedbackSectionState();
}

class _ParentFeedbackSectionState extends State<ParentFeedbackSection> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  final List<Map<String, String>> reviews = [
    {
      'name': 'Mrs. Asha Kumar',
      'review':
          'The school has an excellent academic environment. My child has shown tremendous improvement in both academics and personality.'
    },
    {
      'name': 'Mrs. Latha Rajesh',
      'review':
          'Happy with the communication and updates. Regular PTMs and digital updates help me stay informed about my child\'s progress.'
    },
    {
      'name': 'Mr. Dinesh Kumar',
      'review':
          'Safe and friendly for students. The security measures are commendable, and my child feels comfortable and happy at school.'
    },
    {
      'name': 'Mrs. Jayalatha',
      'review':
          'My child loves the extracurricular activities. Dance, art, and sports have helped improve her confidence and creativity.'
    },
    {
      'name': 'Mr. Natarajan Pillai',
      'review':
          'Nag Vidhyashram provides holistic development. I am impressed with the emphasis on values, discipline, and critical thinking.'
    },
    {
      'name': 'Mrs. Bhavna',
      'review':
          'Interactive teaching methods and well-maintained classrooms make learning enjoyable. My child looks forward to school every day!'
    },
  ];

  @override
  void initState() {
    super.initState();

    // Delay a bit so ListView definitely has a_scrollPosition_ attached:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), _startAutoScroll);
    });
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      if (!mounted) return;

      // 1) If there's no active ScrollPosition yet, bail out immediately:
      if (_scrollController.positions.isEmpty) return;

      // 2) Now it's safe to grab the first (and only) position:
      final position = _scrollController.positions.first;
      final maxScroll = position.maxScrollExtent;
      final currentScroll = position.pixels;
      final newScroll = currentScroll + 1;

      if (newScroll >= maxScroll) {
        _scrollController.jumpTo(0);
      } else {
        _scrollController.jumpTo(newScroll);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Parent Feedback', style: AppTextStyles.aboutUsStyle),
          const SizedBox(height: 20),
          SizedBox(
            height: 280,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: 300,
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[100],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(4, 8),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"${review['review']}"',
                          style: AppTextStyles.paragraph,
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            const Spacer(),
                            Text(
                              '- ${review['name']}',
                              textAlign: TextAlign.right,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
