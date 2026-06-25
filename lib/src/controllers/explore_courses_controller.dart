import 'package:get/get.dart';

import '../config/elearning_config.dart';
import '../config/elearning_enums.dart';
import '../models/get_all_courses_model.dart';

class ExploreCoursesController extends GetxController {
  ExploreCoursesController() : mode = CourseMode.explore;

  final CourseMode mode;

  // Reactive state
  final RxList<AllCoursesRecordList> courses = <AllCoursesRecordList>[].obs;
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
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final query = {
        'userId': KipiElearning.userProvider.userId,
        'userType': KipiElearning.userProvider.userType,
        'appType': KipiElearning.userProvider.appType,
        'page': currentPage.value,
        'limit': 20,
      };

      if (searchQuery.value.isNotEmpty) {
        query['search'] = searchQuery.value;
      }

      final fetchedCourses = await KipiElearning.courseRepository.getAllCourses(
        query: query,
      );

      courses.assignAll(fetchedCourses);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
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

class ExploreCoursesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExploreCoursesController());
  }
}
