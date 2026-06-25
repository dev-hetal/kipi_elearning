import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/explore_courses_controller.dart';
import '../widgets/course_detail_card.dart';

class ExploreCoursesWidget extends StatelessWidget {
  const ExploreCoursesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExploreCoursesController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.errorMessage.value),
              ElevatedButton(
                onPressed: controller.fetchCourses,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.courses.isEmpty) {
        return const Center(child: Text('No courses available'));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.courses.length,
        itemBuilder: (context, index) {
          final course = controller.courses[index];
          return CourseDetailCard(
            course: course,
            onTap: () {
              Get.toNamed('/course-details-screen', arguments: {
                'course': course.toJson(),
              });
            },
          );
        },
      );
    });
  }
}
