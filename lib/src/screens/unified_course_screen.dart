import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/explore_courses_controller.dart';
import '../controllers/my_courses_controller.dart';
import '../config/elearning_config.dart';
import '../config/elearning_enums.dart';
import '../utils/elearning_language.dart';

class UnifiedCourseScreen extends StatelessWidget {
  const UnifiedCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine which controller to use based on route
    final controller = Get.currentRoute == '/explore-course-screen'
        ? Get.find<ExploreCoursesController>()
        : Get.find<MyCoursesController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(controller is ExploreCoursesController
            ? 'Explore Courses'
            : 'My Courses'),
      ),
      body: Obx(() {
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
                  onPressed: () {
                    if (controller is ExploreCoursesController) {
                      controller.fetchCourses();
                    } else {
                      controller.fetchEnrolledCourses();
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.courses.isEmpty) {
          return const Center(child: Text('No courses found'));
        }

        return ListView.builder(
          itemCount: controller.courses.length,
          itemBuilder: (context, index) {
            final course = controller.courses[index];
            return ListTile(
              title: Text(course.title ?? 'No Title'),
              subtitle: Text(course.subTitle ?? ''),
              trailing: Text('${course.price ?? 0}'),
              onTap: () {
                KipiElearning.navigationProvider.pushNamed(
                  route: '/course-details-screen',
                  arguments: {'course': course.toJson()},
                );
              },
            );
          },
        );
      }),
    );
  }
}
