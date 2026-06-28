import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kipi_elearning/kipi_elearning.dart';

void main() {
  // Initialize mock providers for example
  _initializePackage();

  runApp(const MyApp());
}

void _initializePackage() {
  // Mock implementations for demonstration
  // In real app, you would implement these interfaces with your actual data sources

  KipiElearning.initialize(
    courseRepository: MockCourseRepository(),
    userProvider: MockUserProvider(),
    indexProvider: MockIndexProvider(),
    entityProvider: MockEntityProvider(),
    navigationProvider: MockNavigationProvider(),
    walletProvider: MockWalletProvider(),
    subscriptionProvider: MockSubscriptionProvider(),
    showLoader: () => print('Show loader'),
    hideLoader: () => print('Hide loader'),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kipi E-Learning Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomeScreen(),
        ),
        ...ElearningPages.getPages(),
      ],
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kipi E-Learning Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.toNamed(ElearningRoutes.exploreCourseScreen),
              child: const Text('Explore Courses'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Get.toNamed(ElearningRoutes.myCoursesScreen),
              child: const Text('My Courses'),
            ),
          ],
        ),
      ),
    );
  }
}

// Mock implementations for demonstration purposes
class MockCourseRepository implements CourseRepository {
  @override
  Future<List<AllCoursesRecordList>> getAllCourses({required Map<String, dynamic> query}) async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  @override
  Future<List<UserHasCourseData>> getUserHasCourse({required Map<String, dynamic> query}) async {
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  @override
  Future<AllCoursesRecordList?> getCourseById({required String courseId}) async {
    return null;
  }

  @override
  Future<bool> enrollCourse({required String courseId, required Map<String, dynamic> body}) async {
    return true;
  }

  @override
  Future<dynamic> getCourseIndex({required String courseId, required Map<String, dynamic> query}) async {
    return [];
  }
}

class MockUserProvider implements UserProvider {
  @override
  String get userId => 'mock_user_id';
  @override
  String get userUuid => 'mock_user_uuid';
  @override
  String get userType => 'student';
  @override
  String get appType => 'school';
  @override
  List<String> get interestedEntities => [];
  @override
  String? get userEmail => 'mock@example.com';
  @override
  String? get userMobile => '1234567890';
  @override
  bool get isAuthenticated => true;
}

class MockIndexProvider implements IndexProvider {
  @override
  Future<dynamic> getIndexBySubjectId({required Map<String, dynamic> query}) async {
    return [];
  }

  @override
  Future<void> createIndex({required Map<String, dynamic> body}) async {}

  @override
  Future<void> updateIndex({required String id, required Map<String, dynamic> body}) async {}

  @override
  Future<void> assignChapterToUsers({required Map<String, dynamic> body}) async {}

  @override
  Future<dynamic> getAssignedChapters({required Map<String, dynamic> query}) async {
    return [];
  }

  @override
  Future<bool> mergeCourseIndex({required Map<String, dynamic> body}) async {
    return true;
  }
}

class MockEntityProvider implements EntityProvider {
  @override
  Future<List<dynamic>> getAllEntities() async {
    return [];
  }

  @override
  Future<dynamic> getEntityFromSubjectId({required String subjectId, required String entityType}) async {
    return null;
  }

  @override
  Future<List<dynamic>> getParentsFromChild({required String childId}) async {
    return [];
  }

  @override
  Future<dynamic> getAcademicDataById({required String id}) async {
    return null;
  }

  @override
  List<dynamic> entitiyListToSplittedList({required List<dynamic> entities}) {
    return entities;
  }
}

class MockNavigationProvider implements NavigationProvider {
  @override
  Future<T?> pushNamed<T>(
      {required String route,
      Map<String, dynamic>? arguments,
      List<String>? moduleCodeList,
      List<String>? featureCodeList,
      List<String>? actionCodeList}) async {
    return Get.toNamed<T>(route, arguments: arguments);
  }

  @override
  Future<T?> newPushNamed<T>({required String route, Map<String, dynamic>? arguments}) async {
    return Get.offAllNamed<T>(route, arguments: arguments);
  }

  @override
  void pop<T>({T? result}) {
    Get.back(result: result);
  }

  @override
  void popUntil(String routeName) {
    Get.until((route) => Get.currentRoute == routeName);
  }

  @override
  String? getCurrentRoute() {
    return Get.currentRoute;
  }
}

class MockWalletProvider implements WalletProvider {
  @override
  Future<bool> enrollCourseWithWallet({
    required String courseId,
    required Map<String, dynamic> body,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<num> getWalletBalance() async {
    return 1000;
  }

  @override
  bool hasSufficientBalance({
    required num coursePrice,
    required num currentBalance,
  }) {
    return currentBalance >= coursePrice;
  }

  @override
  void navigateToWallet() {
    print('Navigate to wallet screen');
  }

  @override
  Future<bool> createWalletTransaction({
    required Map<String, dynamic> body,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}

class MockSubscriptionProvider implements SubscriptionProvider {
  @override
  Future<List<dynamic>> getInstPlan() async {
    return [];
  }

  @override
  bool hasActiveSubscription() {
    return true;
  }

  @override
  String? getSubscriptionExpiry() {
    return '2025-12-31';
  }

  @override
  bool isCourseIncludedInSubscription({
    required String courseId,
  }) {
    return false;
  }
}
