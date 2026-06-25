import 'package:get/get.dart';

import '../config/elearning_config.dart';
import '../models/get_all_courses_model.dart';

class CourseDetailsController extends GetxController {

  // Reactive state
  final Rx<AllCoursesRecordList?> rxCourse = Rx<AllCoursesRecordList?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isEnrolled = false.obs;

  // Course index data
  final RxList<dynamic> courseIndex = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
    fetchCourseDetails();
    checkEnrollment();
  }

  void _initializeFromArguments() {
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments;
      if (args.containsKey('course')) {
        rxCourse.value = AllCoursesRecordList.fromJson(args['course']);
      }
    }
  }

  Future<void> fetchCourseDetails() async {
    if (rxCourse.value?.id == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final course = await KipiElearning.courseRepository.getCourseById(
        courseId: rxCourse.value!.id!,
      );

      if (course != null) {
        rxCourse.value = course;
      }

      // Fetch course index
      final indexData = await KipiElearning.courseRepository.getCourseIndex(
        courseId: rxCourse.value!.id!,
        query: {},
      );

      if (indexData != null) {
        courseIndex.assignAll(indexData is List ? indexData : [indexData]);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkEnrollment() async {
    if (rxCourse.value?.id == null) return;

    try {
      final query = {
        'userId': KipiElearning.userProvider.userId,
        'courseId': rxCourse.value!.id,
      };

      final enrollments = await KipiElearning.courseRepository.getUserHasCourse(
        query: query,
      );

      if (enrollments.isNotEmpty) {
        rxEnrollment.value = enrollments.first;
        isEnrolled.value = true;
      } else {
        isEnrolled.value = false;
      }
    } catch (e) {
      isEnrolled.value = false;
    }
  }

  Future<void> navigateToCheckout() async {
    await KipiElearning.navigationProvider.pushNamed(
      route: '/course-checkout-screen',
      arguments: {
        'course': rxCourse.value?.toJson(),
      },
    );
  }

  Future<void> navigateToMergeIndex() async {
    await KipiElearning.navigationProvider.pushNamed(
      route: '/merge-course-index-screen',
      arguments: {
        'course': rxCourse.value?.toJson(),
      },
    );
  }
}

class CourseDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseDetailsController());
  }
}
