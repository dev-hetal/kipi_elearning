import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/course_details_controller.dart';
import '../config/elearning_config.dart';

class CourseDetailsScreen extends GetView<CourseDetailsController> {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.rxCourse.value?.title ?? 'Course Details')),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final course = controller.rxCourse.value;
        if (course == null) {
          return const Center(child: Text('Course not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course thumbnail
              if (course.courseThumbNail?.presignedUrl != null)
                Image.network(
                  course.courseThumbNail!.presignedUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 16),

              // Course title
              Text(
                course.title ?? 'No Title',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Course subtitle
              Text(
                course.subTitle ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Price
              if (course.price != null)
                Text(
                  'Price: ${course.price}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 16),

              // Enrollment status
              Obx(() {
                if (controller.isEnrolled.value) {
                  return const Text(
                    'Enrolled',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  );
                } else {
                  return ElevatedButton(
                    onPressed: controller.navigateToCheckout,
                    child: const Text('Enroll Now'),
                  );
                }
              }),
              const SizedBox(height: 16),

              // Merge index button (for teachers)
              if (KipiElearning.userProvider.userType == 'teacher')
                ElevatedButton(
                  onPressed: controller.navigateToMergeIndex,
                  child: const Text('Merge Index'),
                ),
            ],
          ),
        );
      }),
    );
  }
}
