import 'dart:convert';

import 'package:get/get.dart';

import '../config/elearning_config.dart';
import '../models/get_all_courses_model.dart';
import '../models/user_has_course_model.dart';
import '../managers/course_manager.dart';

class CourseCheckoutController extends GetxController {
  final CourseManager _courseManager = CourseManager();

  // Reactive state
  final Rx<AllCoursesRecordList?> rxCourse = Rx<AllCoursesRecordList?>(null);
  final Rx<UserHasCourseData?> rxEnrollment = Rx<UserHasCourseData?>(null);
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
      final balance = await KipiElearning.walletProvider.getWalletBalance();
      walletBalance.value = balance;

      if (rxCourse.value?.price != null) {
        hasSufficientBalance.value = balance >= rxCourse.value!.price!;
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

      final success = await KipiElearning.walletProvider.enrollCourseWithWallet(
        courseId: rxCourse.value!.id!,
        amount: rxCourse.value!.price ?? 0,
        additionalData: body,
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

  Future<void> navigateToWallet() async {
    await KipiElearning.walletProvider.navigateToWallet();
  }
}

class CourseCheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseCheckoutController());
  }
}
