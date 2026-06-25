import 'package:get/get.dart';

class WriteReviewController extends GetxController {
  // Reactive state
  final RxInt rating = 0.obs;
  final RxString reviewText = ''.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;

  void setRating(int value) {
    rating.value = value;
  }

  void setReviewText(String value) {
    reviewText.value = value;
  }

  Future<void> submitReview() async {
    if (rating.value == 0) {
      errorMessage.value = 'Please select a rating';
      return;
    }

    if (reviewText.value.isEmpty) {
      errorMessage.value = 'Please write a review';
      return;
    }

    try {
      isSubmitting.value = true;
      errorMessage.value = '';

      // In real implementation, submit to API
      await Future.delayed(const Duration(seconds: 1));

      // Navigate back
      KipiElearning.navigationProvider.pop();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isSubmitting.value = false;
    }
  }
}

class WriteReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WriteReviewController());
  }
}
