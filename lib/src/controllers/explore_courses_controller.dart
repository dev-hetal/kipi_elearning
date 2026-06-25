import "package:get/get.dart";

import "unified_course_controller.dart";

class ExploreCoursesController extends UnifiedCourseController {
  ExploreCoursesController() : super(mode: CourseListMode.explore);
}

class ExploreCoursesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ExploreCoursesController.new);
  }
}
