import "dart:async";

import "package:get/get.dart";
import "package:kipi_elearning/kipi_elearning.dart";

class CourseCheckoutController extends GetxController {
  // Reactive state
  final Rx<AllCoursesRecordList?> rxCourse = Rx<AllCoursesRecordList?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isProcessing = false.obs;
  RxList<UserHasCourseData> rxUserHasCourseList = <UserHasCourseData>[].obs;
  Rx<UserHasCourseData> rxEnrolledCourse = UserHasCourseData().obs;

  // Wallet balance
  final Rx<num> walletBalance = 0.obs;
  final RxBool hasSufficientBalance = false.obs;

  // Subscription status
  final RxBool isCourseFreeInSubscription = false.obs;

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final Map<String, dynamic> arguments = Get.arguments;
      if (arguments.containsKey("course") && arguments["course"] != null) {
        rxCourse.value = AllCoursesRecordList.fromJson(arguments["course"]);
      }
    }

    _initializeData();
    super.onInit();
  }

  Future<void> _initializeData() async {
    await getUserHasCourse();
    await checkWalletBalance();
    await checkSubscriptionStatus();
  }

  Future<void> checkWalletBalance() async {
    if (KipiElearning.walletProvider == null) return;

    try {
      walletBalance.value = await KipiElearning.walletProvider!.getWalletBalance();
      final coursePrice = rxCourse.value?.price ?? 0;
      hasSufficientBalance.value = KipiElearning.walletProvider!.hasSufficientBalance(
        coursePrice: coursePrice,
        currentBalance: walletBalance.value,
      );
    } catch (e) {
      hasSufficientBalance.value = false;
    }
  }

  Future<void> checkSubscriptionStatus() async {
    if (KipiElearning.subscriptionProvider == null || rxCourse.value?.id == null) return;

    try {
      isCourseFreeInSubscription.value = KipiElearning.subscriptionProvider!.isCourseIncludedInSubscription(
        courseId: rxCourse.value?.id ?? "",
      );
    } catch (e) {
      isCourseFreeInSubscription.value = false;
    }
  }

  Future<bool> enrollCourse() async {
    if (rxCourse.value?.id == null) return false;

    try {
      // Build enrollment body based on user type
      final body = _buildEnrollmentBody();

      bool success = false;

      // Use wallet provider if available, otherwise use course repository
      if (KipiElearning.walletProvider != null) {
        success = await KipiElearning.walletProvider!.enrollCourseWithWallet(
          courseId: rxCourse.value?.id ?? "",
          body: body,
        );
      } else {
        success = await KipiElearning.courseRepository.enrollCourse(
          courseId: rxCourse.value?.id ?? "",
          body: body,
        );
      }

      if (success) {
        await getUserHasCourse();
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  Map<String, dynamic> _buildEnrollmentBody() {
    final userType = KipiElearning.userProvider.userType;
    final appType = KipiElearning.userProvider.appType;

    final body = <String, dynamic>{
      'userId': KipiElearning.userProvider.userId,
      'userUuid': KipiElearning.userProvider.userUuid,
      'courseId': rxCourse.value?.id,
      'instituteId': rxCourse.value?.instituteId,
      'price': rxCourse.value?.price,
      'userType': userType,
      'appType': appType,
    };

    // Add role-specific data
    body['users'] = [
      {
        'userId': KipiElearning.userProvider.userId,
        'uuid': KipiElearning.userProvider.userUuid,
        'type': 'SELF',
      }
    ];
    body['type'] = 'BUY';
    body['itemType'] = 'COURSE';
    body['item'] = {
      'id': rxCourse.value?.id,
      'uuid': rxCourse.value?.id,
      'coin': rxCourse.value?.price ?? 0,
    };

    return body;
  }

  Future<bool> getUserHasCourse() async {
    isLoading.value = true;
    final Completer<bool> completer = Completer<bool>();

    try {
      final enrollments = await KipiElearning.courseRepository.getUserHasCourse(
        query: {"userId": KipiElearning.userProvider.userId},
      );
      rxUserHasCourseList.assignAll(enrollments);
      rxEnrolledCourse.value = rxUserHasCourseList.firstWhereOrNull(
            (e) => e.courseId == rxCourse.value?.id,
          ) ??
          UserHasCourseData();
      isLoading.value = false;
      completer.complete(true);
    } catch (e) {
      isLoading.value = false;
      completer.completeError(e);
    }

    return completer.future;
  }
}

class CourseCheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseCheckoutController());
  }
}
