import 'package:admin_pannel/views/widget/CustomeColors.dart' show primaryGreenColors;
import 'package:flutter/material.dart';

class ExceptionDialod {

  Future<void> showCustomDialog(
    BuildContext context,
    String message, {
    String title = "Error",
  }) {
  return showDialog(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          // Title row
          Row(children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ]),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreenColors),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          )
        ]),
      ),
    ),
  );
}

}
