import 'package:admin_pannel/SchoolWebSite/widgets/customWebcolor.dart';
import 'package:flutter/material.dart';

class ERPFeaturesSection extends StatelessWidget {
  ERPFeaturesSection({super.key});

  final Map<String, List<Map<String, dynamic>>> featuresMap = {
    'Student': [
      {'name': 'Attendance', 'icon': Icons.check},
      {'name': 'Fees Payment', 'icon': Icons.payment},
      {'name': 'Exam Results', 'icon': Icons.school},
      {'name': 'ChatBot', 'icon': Icons.chat_bubble},
      {'name': 'Leave Taking', 'icon': Icons.time_to_leave},
      {'name': 'Assignment Upload', 'icon': Icons.upload_file},
      {'name': 'Track Bus', 'icon': Icons.directions_bus},
      {'name': 'Class Chat', 'icon': Icons.group},
      {'name': 'School Chats', 'icon': Icons.forum},
      {'name': 'Timetable', 'icon': Icons.schedule},
      {'name': 'Gallery', 'icon': Icons.photo_library},
    ],
    'Teacher': [
      {'name': 'Attendance', 'icon': Icons.how_to_reg},
      {'name': 'Student Info', 'icon': Icons.person},
      {'name': 'Upload Assign', 'icon': Icons.upload},
      {'name': 'Reminders', 'icon': Icons.notifications},
      {'name': 'Fee Defaulter', 'icon': Icons.warning},
      {'name': 'Class Chat', 'icon': Icons.chat},
      {'name': 'School Chats', 'icon': Icons.forum},
      {'name': 'Track Bus', 'icon': Icons.directions_bus},
      {'name': 'Gallery', 'icon': Icons.photo_library},
    ],
    'Staff': [
      {'name': 'Profile Mgmt', 'icon': Icons.manage_accounts},
      {'name': 'Announcements', 'icon': Icons.announcement},
      {'name': 'Track Bus', 'icon': Icons.directions_bus},
      {'name': 'Support', 'icon': Icons.support_agent},
      {'name': 'School Chats', 'icon': Icons.forum},
      {'name': 'Gallery', 'icon': Icons.photo_library},
      {'name': 'Bus Driver', 'icon': Icons.drive_eta}
    ],
    'Higher Official': [
      {'name': 'Analytics', 'icon': Icons.analytics},
      {'name': 'Student Info', 'icon': Icons.person},
      {'name': 'Reports', 'icon': Icons.bar_chart},
      {'name': 'Teacher Info', 'icon': Icons.supervisor_account},
      {'name': 'Gallery', 'icon': Icons.photo_library},
      {'name': 'Reminders', 'icon': Icons.notifications},
      {'name': 'Fee Defaulter', 'icon': Icons.warning},
      {'name': 'Class Chat', 'icon': Icons.chat},
      {'name': 'Track Bus', 'icon': Icons.directions_bus},
      {'name': 'School Chats', 'icon': Icons.forum},
    ],
  };

  final Map<String, Color> roleBgColor = {
    'Student': Colors.blue.shade50,
    'Teacher': Colors.red.shade50,
    'Staff': Colors.orange.shade50,
    'Higher Official': Colors.green.shade50,
  };

  final Map<String, Color> roleAccent = {
    'Student': Colors.blue,
    'Teacher': Colors.red,
    'Staff': Colors.orange,
    'Higher Official': Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // ← Make Column shrink‐wrap its children instead of expanding infinitely
        mainAxisSize: MainAxisSize.min,
        children: [
           Text(
            'ERP System Management Features',
            style: AppTextStyles.aboutUsStyle
          ),
          const SizedBox(height: 30),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: featuresMap.entries.map((entry) {
              final role = entry.key;
              final features = entry.value;
              final bgColor = roleBgColor[role] ?? Colors.grey.shade100;
              final accent = roleAccent[role] ?? Colors.black;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shadowColor: accent,
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: bgColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Role title
                        Text(
                          role,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: accent,
                          ),
                        ),
                        const SizedBox(height: 19),
                                
                        // Wrap of feature‐tiles
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: features.map((feature) {
                            return _FeatureTile(
                              name: feature['name'],
                              icon: feature['icon'],
                              color: accent,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          // ─────────── REPLACEMENT END ───────────
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;

  const _FeatureTile({
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,

      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(40),
        borderRadius: BorderRadius.circular(19),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
