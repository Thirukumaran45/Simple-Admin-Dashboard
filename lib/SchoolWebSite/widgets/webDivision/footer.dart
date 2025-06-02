import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 40.0, left: 40.0,right: 40.0),
          color: Colors.pink[100],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // School Address
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('School Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 40),
                    Text('45, poonamallee highways, \nnear GRT jwellers, chennai , \ntamil nadu 600056, India'),
                    
                  ],
                ),
              ),

              // Social Media
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Follow Us in', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 40),
                    Row(
                      
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            _launchUrl('https://www.facebook.com/');
                          },
                          child: const Icon(Icons.facebook, color: Colors.blue,size: 30),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            _launchUrl('https://www.instagram.com/');
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration:const BoxDecoration(
                              color: Colors.pink,
                              shape: BoxShape.circle
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white,size: 16)),
                        ),
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: () {
                            _launchUrl('https://maps.google.com/');
                          },
                          child: const Icon(Icons.location_on, color: Colors.green,size: 30,),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              // Contact Info
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Contact With Us', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 40),
                    Text('Email: contact@ourschool.com'),
                    Text('Phone: +91-9876543210'),
                    Text('Phone: +91-9876543210'),
                    Text('Phone: +91-9876543210'),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Copyright
        Container(
          padding: const EdgeInsets.only(bottom: 40.0,),
          color: Colors.pink[100],
          child: const Center(
            child: Text(
              '© 2025 School Campus. All rights reserved.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,),
            ),
          ),
        ),
      ],
    );
  }
}
