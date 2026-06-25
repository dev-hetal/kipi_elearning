import "dart:async";

import "package:get/get.dart";
import "package:kipi_elearning/kipi_elearning.dart";

class MergeCourseIndexController extends GetxController {
  final RxList<dynamic> rxDataList = <dynamic>[].obs;
  final RxBool isLoading = true.obs;
  final RxSet<String> rxSelectedIds = <String>{}.obs;

  Rx<AllCoursesRecordList>? rxCourse = AllCoursesRecordList().obs;
  RxList<UserHasCourseData> rxUserHasCourseList = <UserHasCourseData>[].obs;
  Rx<UserHasCourseData> rxEnrolledCourse = UserHasCourseData().obs;

  RxList<dynamic> teacherIndexDataList = <dynamic>[].obs;

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final Map<String, dynamic> arguments = Get.arguments;
      if (arguments.containsKey("course")) {
        rxCourse?.value = AllCoursesRecordList.fromJson(arguments["course"]);
      }
    }

    getCourseIndexData();
    getUserHasCourse();
    getTeacherIndexData();
    super.onInit();
  }

  Future<bool> getCourseIndexData() async {
    isLoading.value = true;
    final Completer<bool> completer = Completer<bool>();

    try {
      final indexData = await KipiElearning.indexProvider.getIndexBySubjectId(
        query: {"courseId": rxCourse?.value.id ?? ""},
      );
      rxDataList.assignAll(indexData is List ? indexData : [indexData]);

      // Auto-select all chapters, topics, and subtopics
      selectAllIndexes();

      isLoading.value = false;
      completer.complete(true);
    } catch (e) {
      isLoading.value = false;
      completer.completeError(e);
    }

    return completer.future;
  }

  Future<bool> getTeacherIndexData() async {
    isLoading.value = true;
    final Completer<bool> completer = Completer<bool>();

    try {
      final indexData = await KipiElearning.indexProvider.getIndexBySubjectId(
        query: {
          "courseId": rxCourse?.value.subjectId ?? "",
          "userId": KipiElearning.userProvider.userId,
          "type": "private",
        },
      );
      teacherIndexDataList.assignAll(indexData is List ? indexData : [indexData]);
      isLoading.value = false;
      completer.complete(true);
    } catch (e) {
      isLoading.value = false;
      completer.completeError(e);
    }

    return completer.future;
  }

  Future<bool> getUserHasCourse() async {
    final Completer<bool> completer = Completer<bool>();

    try {
      final enrollments = await KipiElearning.courseRepository.getUserHasCourse(
        query: {"userId": KipiElearning.userProvider.userId},
      );
      rxUserHasCourseList.assignAll(enrollments);
      rxEnrolledCourse.value = rxUserHasCourseList.firstWhereOrNull(
            (e) => e.courseId == rxCourse?.value.id,
          ) ??
          UserHasCourseData();
      completer.complete(true);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }

  bool isSelected(dynamic node) {
    final id = node['id']?.toString();
    return id != null && rxSelectedIds.contains(id);
  }

  void toggleSelection(dynamic node) {
    final id = node['id']?.toString();
    if (id != null) {
      if (rxSelectedIds.contains(id)) {
        rxSelectedIds.remove(id);
      } else {
        rxSelectedIds.add(id);
      }
    }
    rxSelectedIds.refresh();
  }

  void selectAllIndexes() {
    rxSelectedIds.clear();
    for (final data in rxDataList) {
      _collectIdsRecursively(data);
    }
  }

  void _collectIdsRecursively(dynamic node) {
    final id = node['id']?.toString();
    if (id != null) {
      rxSelectedIds.add(id);
    }
    final children = node['list'];
    if (children != null && children is List) {
      for (final child in children) {
        _collectIdsRecursively(child);
      }
    }
  }

  List<String> get selectedIds => rxSelectedIds.toList();

  Future<void> mergeIndex() async {
    isLoading.value = true;

    try {
      final body = {
        "title": rxCourse?.value.title ?? "",
        "subject": rxCourse?.value.subjectId ?? "",
        "type": "private",
        "userId": KipiElearning.userProvider.userId,
        "chapterIndex": selectedIds,
      };

      final success = await KipiElearning.indexProvider.mergeCourseIndex(
        body: body,
      );

      if (success) {
        isLoading.value = false;
        KipiElearning.navigationProvider.pop();
      } else {
        isLoading.value = false;
      }
    } catch (e) {
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
