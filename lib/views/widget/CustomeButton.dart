import 'package:flutter/material.dart';

Widget customIconTextButton(Color color,
    {required void Function()? onPressed,
    required IconData icon,
    required String text}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color, // Green accent background color
      elevation: 10, // Elevation for active state
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
    ),
    onPressed: onPressed,
    child: Row(
      children: [
        Icon(
          icon,
          color: Colors.white, // Icon color
          size: 30, // Larger icon size
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20, // Bigger text size
              fontWeight: FontWeight.normal, // Bold text
              color: Colors.white, // Text color
            ),
          ),
        ),
      ],
    ),
  );
}
