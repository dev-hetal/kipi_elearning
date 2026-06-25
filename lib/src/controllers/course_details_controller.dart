import "dart:async";

import "package:get/get.dart";
import "package:kipi_elearning/kipi_elearning.dart";

class CourseDetailsController extends GetxController {
  final RxList<dynamic> rxDataList = <dynamic>[].obs;
  final RxBool isLoading = true.obs;

  Rx<AllCoursesRecordList>? rxCourse = AllCoursesRecordList().obs;
  RxList<UserHasCourseData> rxUserHasCourseList = <UserHasCourseData>[].obs;
  Rx<UserHasCourseData> rxEnrolledCourse = UserHasCourseData().obs;

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final Map<String, dynamic> arguments = Get.arguments;
      if (arguments.containsKey("course")) {
        rxCourse?.value = AllCoursesRecordList.fromJson(arguments["course"]);
      }
    }

    getIndexDataBySubject();
    getUserHasCourse();
    super.onInit();
  }

  bool isCourseEnrolled(String courseId) {
    final enrolled = rxUserHasCourseList.firstWhereOrNull((e) => e.courseId == courseId);
    return enrolled?.courseId != null;
  }

  Future<bool> getIndexDataBySubject() async {
    isLoading.value = true;
    final completer = Completer<bool>();
    try {
      final indexData = await KipiElearning.indexProvider.getIndexBySubjectId(
        query: {"courseId": rxCourse?.value.id ?? ""},
      );
      rxDataList.assignAll(indexData is List ? indexData : [indexData]);
      isLoading.value = false;
      completer.complete(true);
    } catch (e) {
      isLoading.value = false;
      completer.completeError(e);
    }
    return completer.future;
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

class CourseDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseDetailsController());
  }
}
