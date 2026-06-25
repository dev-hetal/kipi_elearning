import 'package:get/get.dart';

import '../routes/elearning_routes.dart';
import '../screens/unified_course_screen.dart';
import '../screens/explore_courses_screen.dart';
import '../screens/my_courses_screen.dart';
import '../screens/course_details_screen.dart';
import '../screens/course_checkout_screen.dart';
import '../screens/course_index_details_screen.dart';
import '../screens/merge_course_index_screen.dart';
import '../screens/rating_review_screen.dart';
import '../screens/write_review_screen.dart';
import '../controllers/unified_course_controller.dart';
import '../controllers/course_details_controller.dart';
import '../controllers/course_checkout_controller.dart';
import '../controllers/course_index_details_controller.dart';
import '../controllers/merge_course_index_controller.dart';
import '../controllers/rating_review_controller.dart';
import '../controllers/write_review_controller.dart';
import '../config/elearning_enums.dart';

class ElearningPages {
  ElearningPages._();

  static List<GetPage> getPages() {
    return [
      // Explore Courses Screen
      GetPage(
        name: ElearningRoutes.exploreCourseScreen,
        page: () => const ExploreCoursesScreen(),
        binding: UnifiedCourseBinding(mode: CourseMode.explore),
      ),

      // My Courses Screen
      GetPage(
        name: ElearningRoutes.myCoursesScreen,
        page: () => const MyCoursesScreen(),
        binding: UnifiedCourseBinding(mode: CourseMode.myCourses),
      ),

      // Unified Course Screen (generic/dashboard use)
      GetPage(
        name: ElearningRoutes.unifiedCourseScreen,
        page: () => const UnifiedCourseScreen(),
        binding: UnifiedCourseBinding(mode: CourseMode.dashboard),
      ),

      // Course Details Screen
      GetPage(
        name: ElearningRoutes.courseDetailsScreen,
        page: () => const CourseDetailsScreen(),
        binding: CourseDetailsBinding(),
      ),

      // Course Checkout Screen
      GetPage(
        name: ElearningRoutes.courseCheckoutScreen,
        page: () => const CourseCheckoutScreen(),
        binding: CourseCheckoutBinding(),
      ),

      // Course Index Details Screen
      GetPage(
        name: ElearningRoutes.courseIndexDetailsScreen,
        page: () => const CourseIndexDetailsScreen(),
        binding: CourseIndexDetailsBinding(),
      ),

      // Merge Course Index Screen
      GetPage(
        name: ElearningRoutes.mergeCourseIndexScreen,
        page: () => const MergeCourseIndexScreen(),
        binding: MergeCourseIndexBinding(),
      ),

      // Rating Review Screen
      GetPage(
        name: ElearningRoutes.ratingReviewScreen,
        page: () => const RatingReviewScreen(),
        binding: RatingReviewBinding(),
      ),

      // Write Review Screen
      GetPage(
        name: ElearningRoutes.writeReviewScreen,
        page: () => const WriteReviewScreen(),
        binding: WriteReviewBinding(),
      ),
    ];
  }
}
