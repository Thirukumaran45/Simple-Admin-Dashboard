
import 'package:admin_pannel/SchoolWebSite/widgets/customWebcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SportsGamesSection extends StatelessWidget {
final List<Map<String, String>> sports = [
  {
    'image': 'assets/webImages/football.svg',
    'title': 'Football',
    'desc': 'At Nag Vidhyashram CBSE School, football sessions promote physical fitness, coordination, and team spirit. Students actively participate in inter-house and inter-school matches, learning valuable lessons in discipline, leadership, and strategic play while enjoying the thrill of competitive sports in a well-guided and encouraging atmosphere.'
  },
  {
    'image': 'assets/webImages/chess.svg',
    'title': 'Chess Game',
    'desc': 'Chess is a vital part of our co-curricular program, stimulating critical thinking, patience, and mental resilience. Through regular chess sessions and competitions, students at Nag Vidhyashram enhance their analytical skills and concentration, all under expert guidance to foster intellectual growth and strategic decision-making from an early age.'
  },
  {
    'image': 'assets/webImages/cricket.svg',
    'title': 'Cricket',
    'desc': 'Cricket at Nag Vidhyashram CBSE School teaches patience, teamwork, and precision. Students engage in regular coaching, practice matches, and tournaments that help refine their technique while building self-confidence and unity. The sport’s popularity ensures enthusiastic participation and a dynamic environment for learning both on and off the field.'
  },
  {
    'image': 'assets/webImages/batMitton.svg',
    'title': 'Tennis',
    'desc': 'Tennis sessions are structured to improve agility, coordination, and self-reliance. At Nag Vidhyashram, students enjoy individual attention and progressive training. The sport fosters quick reflexes and sharp focus, encouraging personal excellence while cultivating a healthy sense of competition and sportsmanship in a fun, supportive atmosphere.'
  },
  {
    'image': 'assets/webImages/carrom.svg',
    'title': 'Carrom Game',
    'desc': 'Carrom, a favorite indoor game at Nag Vidhyashram, is not just fun—it sharpens motor skills, strategic thinking, and focus. Students engage during activity periods and tournaments, fostering friendly competition in a relaxed setting. It provides balance to high-energy sports, supporting overall mental and emotional well-being.'
  },
  {
    'image': 'assets/webImages/volleyball.svg',
    'title': 'Volleyball',
    'desc': 'Volleyball encourages teamwork, communication, and agility among students. At Nag Vidhyashram, regular matches and guided training ensure active participation. The sport plays a vital role in character-building, keeping students engaged, energetic, and collaborative, while promoting leadership and a strong sense of school spirit across all age groups.'
  },
];

   SportsGamesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
           Text(
            'Sports and Games Activity',
            style: AppTextStyles.aboutUsStyle
          ),
          const SizedBox(height: 50),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: sports.map((sport) => SizedBox(
              width: MediaQuery.of(context).size.width / 3 - 60,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SvgPicture.asset(sport['image']!, height: 250, fit: BoxFit.cover,
                     placeholderBuilder: (context) => const CircularProgressIndicator(color: Colors.green,), 
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(sport['title']!, style:  AppTextStyles.headers),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(sport['desc']!, textAlign: TextAlign.justify,style: AppTextStyles.paragraph,),
                  ),
                ],
              ),
            )).toList(),
          )
        ],
      ),
    );
  }
}
