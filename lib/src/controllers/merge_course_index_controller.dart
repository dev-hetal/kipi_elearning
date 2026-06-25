import 'package:get/get.dart';

import '../config/elearning_config.dart';
import '../models/get_all_courses_model.dart';

class MergeCourseIndexController extends GetxController {
  // Reactive state
  final Rx<AllCoursesRecordList?> rxCourse = Rx<AllCoursesRecordList?>(null);
  final RxList<dynamic> rxDataList = <dynamic>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Selection state
  final RxSet<String> selectedIndices = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
    fetchCourseIndex();
  }

  void _initializeFromArguments() {
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final args = Get.arguments;
      if (args.containsKey('course')) {
        rxCourse.value = AllCoursesRecordList.fromJson(args['course']);
      }
    }
  }

  Future<void> fetchCourseIndex() async {
    if (rxCourse.value?.id == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final indexData = await KipiElearning.courseRepository.getCourseIndex(
        courseId: rxCourse.value!.id!,
        query: {},
      );

      if (indexData != null) {
        rxDataList.assignAll(indexData is List ? indexData : [indexData]);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  bool isSelected(dynamic module) {
    final id = module['id']?.toString();
    return id != null && selectedIndices.contains(id);
  }

  void toggleSelection(dynamic module) {
    final id = module['id']?.toString();
    if (id != null) {
      if (selectedIndices.contains(id)) {
        selectedIndices.remove(id);
      } else {
        selectedIndices.add(id);
      }
    }
  }

  Future<void> mergeIndex() async {
    if (rxCourse.value?.id == null || selectedIndices.isEmpty) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final body = {
        'courseId': rxCourse.value!.id,
        'selectedIndices': selectedIndices.toList(),
        'userId': KipiElearning.userProvider.userId,
      };

      final success = await KipiElearning.indexProvider.mergeCourseIndex(
        body: body,
      );

      if (success) {
        // Navigate back with success
        KipiElearning.navigationProvider.pop();
      } else {
        errorMessage.value = 'Merge failed';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}

class MergeCourseIndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MergeCourseIndexController());
  }
}
