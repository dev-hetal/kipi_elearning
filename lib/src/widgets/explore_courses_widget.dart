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
      if (controller.rxIsLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final courses = [...controller.rxProfileRelatedCourses, ...controller.rxOtherCourses];

      if (courses.isEmpty) {
        return const Center(child: Text('No courses available'));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
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
