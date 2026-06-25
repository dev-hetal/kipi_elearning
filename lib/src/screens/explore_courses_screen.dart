import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/explore_courses_controller.dart';
import '../config/elearning_config.dart';

class ExploreCoursesScreen extends GetView<ExploreCoursesController> {
  const ExploreCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Courses'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
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
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchCourses,
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
              leading: course.courseThumbNail?.presignedUrl != null
                  ? Image.network(
                      course.courseThumbNail!.presignedUrl!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.book, size: 40),
                    )
                  : const Icon(Icons.book, size: 40),
              title: Text(course.title ?? 'No Title'),
              subtitle: Text(course.subTitle ?? ''),
              trailing: Text(
                course.price != null ? '${course.price}' : 'Free',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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
