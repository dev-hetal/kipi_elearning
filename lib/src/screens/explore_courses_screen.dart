import "package:flutter/material.dart";
import "package:get/get.dart";

import "../controllers/unified_course_controller.dart";
import "../screens/unified_course_screen.dart";

class ExploreCoursesScreen extends GetView<ExploreCoursesController> {
  const ExploreCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UnifiedCourseScreen(
      controller: controller,
      mode: CourseListMode.explore,
    );
  }
}
