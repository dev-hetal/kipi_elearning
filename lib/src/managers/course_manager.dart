import 'package:get/get.dart';

import '../config/elearning_config.dart';
import '../models/get_all_courses_model.dart';
import '../models/user_has_course_model.dart';

class CourseManager {
  CourseManager._();

  static final CourseManager _instance = CourseManager._internal();
  factory CourseManager() => _instance;
  CourseManager._internal();

  /// Reactive list of all courses
  final RxList<AllCoursesRecordList> allCourses = <AllCoursesRecordList>[].obs;

  /// Reactive list of user enrolled courses
  final RxList<UserHasCourseData> enrolledCourses = <UserHasCourseData>[].obs;

  /// Reactive map of enrolled courses by course ID for quick lookup
  final RxMap<String, UserHasCourseData> enrolledCourseMap = <String, UserHasCourseData>{}.obs;

  /// Loading state
  final RxBool isLoading = false.obs;

  /// Error message
  final RxString errorMessage = ''.obs;

  /// Fetch all courses
  Future<void> fetchAllCourses({
    required Map<String, dynamic> query,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final courses = await KipiElearning.courseRepository.getAllCourses(
        query: query,
      );

      allCourses.assignAll(courses);
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch user enrolled courses
  Future<void> fetchEnrolledCourses({
    required Map<String, dynamic> query,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final courses = await KipiElearning.courseRepository.getUserHasCourse(
        query: query,
      );

      enrolledCourses.assignAll(courses);

      // Build lookup map
      final Map<String, UserHasCourseData> map = {};
      for (final course in courses) {
        if (course.courseId != null) {
          map[course.courseId!] = course;
        }
      }
      enrolledCourseMap.assignAll(map);
    } catch (e) {
      errorMessage.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Check if user is enrolled in a course
  bool isUserEnrolled(String courseId) {
    return enrolledCourseMap.containsKey(courseId);
  }

  /// Get enrollment data for a course
  UserHasCourseData? getEnrollmentData(String courseId) {
    return enrolledCourseMap[courseId];
  }

  /// Enroll user in a course
  Future<bool> enrollInCourse({
    required String courseId,
    required Map<String, dynamic> body,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final success = await KipiElearning.courseRepository.enrollCourse(
        courseId: courseId,
        body: body,
      );

      if (success) {
        // Refresh enrolled courses
        await fetchEnrolledCourses(
          query: {
            'userId': KipiElearning.userProvider.userId,
          },
        );
      }

      return success;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Clear all cached data
  void clearCache() {
    allCourses.clear();
    enrolledCourses.clear();
    enrolledCourseMap.clear();
    errorMessage.value = '';
  }
}
