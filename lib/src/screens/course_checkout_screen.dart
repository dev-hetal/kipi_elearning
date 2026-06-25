import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/course_checkout_controller.dart';

class CourseCheckoutScreen extends GetView<CourseCheckoutController> {
  const CourseCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Checkout'),
      ),
      body: Obx(() {
        final course = controller.rxCourse.value;
        if (course == null) {
          return const Center(child: Text('Course not found'));
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course info
              Text(
                course.title ?? 'No Title',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                course.subTitle ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Price
              Text(
                'Price: ${course.price ?? 0}',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Wallet balance
              Obx(() {
                return Text(
                  'Wallet Balance: ${controller.walletBalance.value}',
                  style: const TextStyle(fontSize: 18),
                );
              }),
              const SizedBox(height: 16),

              // Error message
              Obx(() {
                if (controller.errorMessage.value.isNotEmpty) {
                  return Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                  );
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(height: 16),

              const Spacer(),

              // Enroll button
              Obx(() {
                if (controller.isProcessing.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        // controller.hasSufficientBalance.value ?
                        controller.enrollInCourse,

                    // : controller.navigateToWallet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.hasSufficientBalance.value ? Colors.green : Colors.orange,
                    ),
                    child: Text(
                      controller.hasSufficientBalance.value ? 'Enroll Now' : 'Add Credits',
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
