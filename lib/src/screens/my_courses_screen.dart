import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:kipi_elearning/kipi_elearning.dart";

class MyCoursesScreen extends GetView<MyCoursesController> {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UnifiedCourseScreen(
      controller: controller,
      mode: CourseListMode.myCourses,
    );
  }
}
