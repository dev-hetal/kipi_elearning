import 'package:get/get.dart';

class ReviewModel {
  final String review;
  final String name;
  final String role;
  final int rating;

  ReviewModel({
    required this.review,
    required this.name,
    required this.role,
    required this.rating,
  });
}

class RatingReviewController extends GetxController {
  // Reactive state
  final RxList<ReviewModel> reviewList = <ReviewModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Mock data for now - in real implementation, fetch from API
      reviewList.assignAll([
        ReviewModel(
          review: 'Excellent course content! Very helpful for learning.',
          name: 'John Doe',
          role: 'Student',
          rating: 5,
        ),
        ReviewModel(
          review: 'Good structure but could use more examples.',
          name: 'Jane Smith',
          role: 'Teacher',
          rating: 4,
        ),
      ]);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> navigateToWriteReview() async {
    await KipiElearning.navigationProvider.pushNamed(
      route: '/write-review-screen',
      arguments: {},
    );
  }
}

class RatingReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RatingReviewController());
  }
}
