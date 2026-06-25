import 'package:get/get.dart';

import '../config/elearning_config.dart';
import '../models/get_all_courses_model.dart';

class CourseCheckoutController extends GetxController {
  // Reactive state
  final Rx<AllCoursesRecordList?> rxCourse = Rx<AllCoursesRecordList?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isProcessing = false.obs;

  // Wallet balance
  final Rx<num> walletBalance = 0.obs;
  final RxBool hasSufficientBalance = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
    fetchWalletBalance();
  }

  void _initializeFromArguments() {
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments;
      if (args.containsKey('course')) {
        rxCourse.value = AllCoursesRecordList.fromJson(args['course']);
      }
    }
  }

  Future<void> fetchWalletBalance() async {
    try {
      // Mock wallet balance - in real implementation, use wallet provider
      walletBalance.value = 1000;

      if (rxCourse.value?.price != null) {
        hasSufficientBalance.value = 1000 >= rxCourse.value!.price!;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> enrollInCourse() async {
    if (rxCourse.value?.id == null) return;

    try {
      isProcessing.value = true;
      errorMessage.value = '';

      final body = {
        'userId': KipiElearning.userProvider.userId,
        'courseId': rxCourse.value!.id,
        'instituteId': rxCourse.value!.instituteId,
        'price': rxCourse.value!.price,
      };

      // Use course repository for enrollment
      final success = await KipiElearning.courseRepository.enrollCourse(
        courseId: rxCourse.value!.id!,
        body: body,
      );

      if (success) {
        // Navigate back or show success
        KipiElearning.navigationProvider.pop();
      } else {
        errorMessage.value = 'Enrollment failed';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isProcessing.value = false;
    }
  }
}

class CourseCheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseCheckoutController());
  }
}
