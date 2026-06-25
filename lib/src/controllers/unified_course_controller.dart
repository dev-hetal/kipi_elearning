import 'package:get/get.dart';

import '../config/elearning_config.dart';
import '../config/elearning_enums.dart';
import '../models/get_all_courses_model.dart';
import '../models/user_has_course_model.dart';

class UnifiedCourseController extends GetxController {
  UnifiedCourseController({required this.mode});

  final CourseMode mode;

  final RxList<AllCoursesRecordList> courses = <AllCoursesRecordList>[].obs;
  final RxList<UserHasCourseData> enrolledCourses = <UserHasCourseData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasNextPage = false.obs;
  final RxBool hasPreviousPage = false.obs;

  bool get isExploreMode => mode == CourseMode.explore;

  String get title => mode.label;

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (isExploreMode) {
        await _fetchAllCourses();
      } else {
        await _fetchEnrolledCourses();
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchAllCourses() async {
    final query = <String, dynamic>{
      'userId': KipiElearning.userProvider.userId,
      'userType': KipiElearning.userProvider.userType,
      'appType': KipiElearning.userProvider.appType,
      'page': currentPage.value,
      'limit': 20,
    };

    if (searchQuery.value.isNotEmpty) {
      query['search'] = searchQuery.value;
    }

    final fetched = await KipiElearning.courseRepository.getAllCourses(
      query: query,
    );
    courses.assignAll(fetched);
  }

  Future<void> _fetchEnrolledCourses() async {
    final query = <String, dynamic>{
      'userId': KipiElearning.userProvider.userId,
      'page': currentPage.value,
      'limit': 20,
    };

    if (searchQuery.value.isNotEmpty) {
      query['search'] = searchQuery.value;
    }

    final fetchedEnrollments =
        await KipiElearning.courseRepository.getUserHasCourse(query: query);
    enrolledCourses.assignAll(fetchedEnrollments);

    final courseIds = fetchedEnrollments
        .map((e) => e.courseId)
        .where((id) => id != null)
        .toList();

    if (courseIds.isNotEmpty) {
      final fetchedCourses = await KipiElearning.courseRepository.getAllCourses(
        query: {'courseIds': courseIds.join(',')},
      );
      courses.assignAll(fetchedCourses);
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    currentPage.value = 1;
    fetchCourses();
  }

  void loadNextPage() {
    if (hasNextPage.value && !isLoading.value) {
      currentPage.value++;
      fetchCourses();
    }
  }

  void loadPreviousPage() {
    if (hasPreviousPage.value && !isLoading.value) {
      currentPage.value--;
      fetchCourses();
    }
  }
}

class UnifiedCourseBinding extends Bindings {
  UnifiedCourseBinding({required this.mode});

  final CourseMode mode;

  @override
  void dependencies() {
    Get.lazyPut(() => UnifiedCourseController(mode: mode));
  }
}
