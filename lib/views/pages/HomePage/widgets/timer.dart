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
      Color buttonColor = controller.isCooldown.value ? Colors.white :  Colors.red;
      Color timerColor = controller.isCooldown.value ? Colors.red :  Colors.white;
      
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: InkWell(
            onTap: controller.isCooldown.value
                ? null
                : () {
                    onPressed();
                    controller.startCooldown(context);
                  },
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: buttonColor,
                boxShadow: [
                  BoxShadow(
                    color: buttonColor.withAlpha((0.8 * 255).toInt()),
                    offset: const Offset(6, 10),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    controller.isCooldown.value
                        ? const Icon(Icons.timer, color: Colors.red,size: 50,)
                        : const Icon(Icons.notifications_active, color: Colors.white),
                    const SizedBox(width: 13),
                    Text(
                      controller.isCooldown.value
                          ? '${controller.remainingTime.value.inMinutes.remainder(60).toString().padLeft(2, '0')}:${controller.remainingTime.value.inSeconds.remainder(60).toString().padLeft(2, '0')}'
                          : 'ALERT',
                      style: controller.isCooldown.value?  TextStyle(color: timerColor, fontWeight: FontWeight.bold, letterSpacing: 3, fontSize: 46):
                      TextStyle(color: timerColor, fontWeight: FontWeight.bold, letterSpacing: 3, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
