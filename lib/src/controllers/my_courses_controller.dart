import 'package:get/get.dart';

import '../config/elearning_config.dart';
import '../config/elearning_enums.dart';
import '../models/get_all_courses_model.dart';
import '../models/user_has_course_model.dart';

class MyCoursesController extends GetxController {
  MyCoursesController() : mode = CourseMode.myCourses;

  final CourseMode mode;

  // Reactive state
  final RxList<AllCoursesRecordList> courses = <AllCoursesRecordList>[].obs;
  final RxList<UserHasCourseData> enrolledCourses = <UserHasCourseData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxBool hasNextPage = false.obs;
  final RxBool hasPreviousPage = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEnrolledCourses();
  }

  Future<void> fetchEnrolledCourses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final query = {
        'userId': KipiElearning.userProvider.userId,
        'page': currentPage.value,
        'limit': 20,
      };

      if (searchQuery.value.isNotEmpty) {
        query['search'] = searchQuery.value;
      }

      final fetchedEnrollments =
          await KipiElearning.courseRepository.getUserHasCourse(
        query: query,
      );

      enrolledCourses.assignAll(fetchedEnrollments);

      // Fetch course details for enrolled courses
      final courseIds = fetchedEnrollments
          .map((e) => e.courseId)
          .where((id) => id != null)
          .toList();

      if (courseIds.isNotEmpty) {
        final fetchedCourses =
            await KipiElearning.courseRepository.getAllCourses(
          query: {
            'courseIds': courseIds.join(','),
          },
        );
        courses.assignAll(fetchedCourses);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
    fetchEnrolledCourses();
  }

  void loadNextPage() {
    if (hasNextPage.value && !isLoading.value) {
      currentPage.value++;
      fetchEnrolledCourses();
    }
  }

  void loadPreviousPage() {
    if (hasPreviousPage.value && !isLoading.value) {
      currentPage.value--;
      fetchEnrolledCourses();
    }
  }
}

class MyCoursesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyCoursesController());
  }
}
