
import 'package:admin_pannel/SchoolWebSite/widgets/customWebcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

class EducationLevelsSection extends StatelessWidget {
  final List<Map<String, String>> levels = [
    {
      'image': 'assets/webImages/primarySchool.svg',
      'title': 'Primary School ( Grade I - V)',
      'description': 'Our Primary section nurtures the foundation of learning with a strong emphasis on literacy, numeracy, and values-based education. With approximately 450 students, this stage is focused on building curiosity, creativity, and core academic skills in a joyful learning environment.'
    },
    {
      'image': 'assets/webImages/middleSchool.svg',
      'title': 'Middle School ( Grade VI - VIII)',
      'description': 'The Middle School caters to around 300 students, where we broaden academic exposure with subjects like Science, Mathematics, Social Studies, and Languages. The focus shifts to analytical thinking, collaborative projects, and character development.'
    },
    {
      'image': 'assets/webImages/seniorSchool.svg',
      'title': 'Secondary School ( Grade IX - XII)',
      'description': 'Our Secondary section has about 250 students, and is dedicated to preparing learners for board exams, career paths, and life beyond school. With experienced faculty and modern resources, we ensure academic excellence and emotional resilience.'
    },
  ];

   EducationLevelsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:  40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Our Education Levels',
            style:AppTextStyles.aboutUsStyle),
          const SizedBox(height: 50),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue[200],
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                offset: Offset(0, 5),
                blurRadius: 10,
                color: Colors.blueGrey
              )]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: levels.map((level) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SvgPicture.asset(
                          level['image']!,
                          height: 150,
                     placeholderBuilder: (context) => const CircularProgressIndicator(color: Colors.green,), 
                          width: MediaQuery.sizeOf(context).width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 40),
                       Container(
                        padding: const EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)
                        ),
                        height: MediaQuery.sizeOf(context).height*0.5,
                    
                        child: Column(
                          children: [
                         Text(
                        level['title']!,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 20),
                        child: Text(
                          level['description']!,
                          textAlign: TextAlign.justify,
                          style: AppTextStyles.paragraph,
                        ),
                      ),
                          ],
                        ),
                      )
                      ,const SizedBox(height: 30),
                    
                    ],
                  ),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}