import 'package:get/get.dart';
import 'package:kipi_elearning/kipi_elearning.dart';

import '../controllers/course_checkout_controller.dart';
import '../controllers/course_details_controller.dart';
import '../controllers/course_index_details_controller.dart';
import '../controllers/merge_course_index_controller.dart';
import '../controllers/rating_review_controller.dart';
import '../controllers/write_review_controller.dart';
import '../screens/course_checkout_screen.dart';
import '../screens/course_details_screen.dart';
import '../screens/course_index_details_screen.dart';
import '../screens/merge_course_index_screen.dart';
import '../screens/rating_review_screen.dart';
import '../screens/write_review_screen.dart';

class ElearningPages {
  ElearningPages._();

  static List<GetPage> getPages() {
    return [
      // Explore Courses Screen
      GetPage(
        name: ElearningRoutes.exploreCourseScreen,
        page: () => UnifiedCourseScreen(
          controller: UnifiedCourseController(mode: CourseListMode.explore),
          mode: CourseListMode.explore,
        ),
        binding: ExploreCoursesBinding(),
      ),

      // My Courses Screen
      GetPage(
        name: ElearningRoutes.myCoursesScreen,
        page: () => UnifiedCourseScreen(
          controller: UnifiedCourseController(mode: CourseListMode.myCourses),
          mode: CourseListMode.myCourses,
        ),
        binding: MyCoursesBinding(),
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
