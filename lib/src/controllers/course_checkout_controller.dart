import "dart:async";

import "package:get/get.dart";
import "package:kipi_elearning/kipi_elearning.dart";

import "../models/get_all_courses_model.dart";
import "../models/user_has_course_model.dart";

class CourseCheckoutController extends GetxController {
  Rx<AllCoursesRecordList>? rxCourse = AllCoursesRecordList().obs;
  RxList<UserHasCourseData> rxUserHasCourseList = <UserHasCourseData>[].obs;
  Rx<UserHasCourseData> rxEnrolledCourse = UserHasCourseData().obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final Map<String, dynamic> arguments = Get.arguments;
      if (arguments.containsKey("course") && arguments["course"] != null) {
        rxCourse?.value = AllCoursesRecordList.fromJson(arguments["course"]);
      }
    }

    getUserHasCourse();
    super.onInit();
  }

  Future<bool> enrollCourse() async {
    if (rxCourse?.value.id == null) return false;
    
    try {
      final body = {
        'userId': KipiElearning.userProvider.userId,
        'courseId': rxCourse?.value.id,
        'instituteId': rxCourse?.value.instituteId,
        'price': rxCourse?.value.price,
      };

      final success = await KipiElearning.courseRepository.enrollCourse(
        courseId: rxCourse?.value.id ?? "",
        body: body,
      );
      
      if (success) {
        await getUserHasCourse();
      }
      
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getUserHasCourse() async {
    isLoading.value = true;
    final Completer<bool> completer = Completer<bool>();

    try {
      final enrollments = await KipiElearning.courseRepository.getUserHasCourse(
        query: {"userId": KipiElearning.userProvider.userId},
      );
      rxUserHasCourseList.assignAll(enrollments);
      rxEnrolledCourse.value = rxUserHasCourseList.firstWhereOrNull(
            (e) => e.courseId == rxCourse?.value.id,
          ) ??
          UserHasCourseData();
      isLoading.value = false;
      completer.complete(true);
    } catch (e) {
      isLoading.value = false;
      completer.completeError(e);
    }

    return completer.future;
  }
}

class CourseCheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseCheckoutController());
  }
}
