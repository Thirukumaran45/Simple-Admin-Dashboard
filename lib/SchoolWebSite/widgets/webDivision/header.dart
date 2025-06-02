
import 'package:admin_pannel/SchoolWebSite/widgets/customWebcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;

class HeaderButtons extends StatelessWidget {
  final Function(int) onTap;
  const HeaderButtons({super.key, required this.onTap});
@override
Widget build(BuildContext context) {
  final List<String> titles = ['Home', 'Activity', 'Feedback', 'Services', 'Admin','Contact'];
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(5, 5),
            color: AppTextStyles().primaryGreenShadeColors,
            blurRadius: 4,
            spreadRadius: 1,
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
           Row(
            children: [
              SvgPicture.asset(
                'assets/webImages/schoolLogo.svg',
                height: 90,
                width: 90,
                placeholderBuilder: (context) => const CircularProgressIndicator(color: Colors.green,),
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nag Vidhyashram CBSE sr.sec school',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Affiliated to CBSE, Affiliated.No 1122937 \nAssociative Service Provider by School Campus.org',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        
    

          const Spacer(), // Push right-side content to the end

          // Right-side: logo + school name + affiliation
               Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(titles.length, (index) {
              return Row(
                children: [
                  const SizedBox(width: 20),
                  TextButton(
  onPressed: () => onTap(index),
  style: ButtonStyle(
    side: WidgetStateProperty.all(
      const BorderSide(color: Colors.green),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
    foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.hovered)) {
        return Colors.white;
      }
      return Colors.green;
    }),
    backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.hovered)) {
        return Colors.green;
      }
      return Colors.transparent;
    }),
    overlayColor: WidgetStateProperty.all(Colors.transparent),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
    textStyle: WidgetStateProperty.all(
      AppTextStyles.headers1.copyWith(
        fontWeight: FontWeight.normal,
        letterSpacing: 0.5,
      ),
    ),
  ),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(titles[index]),
  ),
),



                ],
              );
            }),
          ),
        ],
      ),
    ),
  );
}

}
