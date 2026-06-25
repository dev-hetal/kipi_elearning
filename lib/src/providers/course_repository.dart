import '../models/get_all_courses_model.dart';
import '../models/user_has_course_model.dart';

/// Abstract interface for course repository
/// Host app must implement this to provide course data
abstract class CourseRepository {
  /// Fetch all courses with pagination and filters
  Future<List<AllCoursesRecordList>> getAllCourses({
    required Map<String, dynamic> query,
  });

  /// Fetch user enrolled courses
  Future<List<UserHasCourseData>> getUserHasCourse({
    required Map<String, dynamic> query,
  });

  /// Fetch course details by ID
  Future<AllCoursesRecordList?> getCourseById({
    required String courseId,
  });

  /// Enroll user in a course
  Future<bool> enrollCourse({
    required String courseId,
    required Map<String, dynamic> body,
  });

  /// Get course index/chapter data
  Future<dynamic> getCourseIndex({
    required String courseId,
    required Map<String, dynamic> query,
  });
}
