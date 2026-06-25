import "package:get/get.dart";

import "unified_course_controller.dart";

class MyCoursesController extends UnifiedCourseController {
  MyCoursesController() : super(mode: CourseListMode.myCourses);
}

class MyCoursesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(MyCoursesController.new);
  }
}
