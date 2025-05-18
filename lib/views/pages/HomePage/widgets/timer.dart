import 'package:admin_pannel/controller/classControllers/schoolDetailsController/pushNotificationController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AutomatedButtonWithTimer extends StatelessWidget {
  final VoidCallback onPressed;

  AutomatedButtonWithTimer({super.key, required this.onPressed});

  final PushNotificationControlelr controller = Get.find<PushNotificationControlelr>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Color buttonColor = controller.isCooldown.value ? Colors.red : const Color.fromARGB(255, 238, 83, 238);

      return Padding(
        padding: const EdgeInsets.only(left: 36, bottom: 50),
        child: InkWell(
          onTap: controller.isCooldown.value
              ? null
              : () {
                  onPressed();
                  controller.startCooldown();
                },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: buttonColor.withAlpha((0.8 * 255).toInt()),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                controller.isCooldown.value
                    ? const Icon(Icons.timer, color: Colors.white)
                    : const Icon(Icons.notifications_active, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  controller.isCooldown.value
                      ? '${controller.remainingTime.value.inMinutes.remainder(60).toString().padLeft(2, '0')}:${controller.remainingTime.value.inSeconds.remainder(60).toString().padLeft(2, '0')}'
                      : 'Notify All',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 3, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
