import "dart:async";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:infinite_scroll_pagination/infinite_scroll_pagination.dart";
import "package:kipi_elearning/kipi_elearning.dart";

enum CourseListMode {
  explore,
  myCourses,
  dashboardWidget,
}

class UnifiedCourseController extends GetxController {
  final CourseListMode mode;

  UnifiedCourseController({required this.mode});

  RxList<dynamic> rxEntityList = <dynamic>[].obs;

  // Lists for Explore Mode
  RxMap<String, Map<String, List<AllCoursesRecordList>>> rxProfileRelatedCoursesByEntity =
      <String, Map<String, List<AllCoursesRecordList>>>{}.obs;
  RxMap<String, Map<String, List<AllCoursesRecordList>>> rxOtherCoursesByEntity =
      <String, Map<String, List<AllCoursesRecordList>>>{}.obs;
  RxList<AllCoursesRecordList> rxProfileRelatedCourses = <AllCoursesRecordList>[].obs;
  RxList<AllCoursesRecordList> rxOtherCourses = <AllCoursesRecordList>[].obs;

  // Lists for My Courses Mode
  RxMap<String, Map<String, List<AllCoursesRecordList>>> rxMyCoursesByEntity =
      <String, Map<String, List<AllCoursesRecordList>>>{}.obs;
  RxList<AllCoursesRecordList> rxMyCourseList = <AllCoursesRecordList>[].obs;

  // Lists for Dashboard Widget Mode
  RxMap<String, Map<String, List<AllCoursesRecordList>>> rxWidgetCoursesByEntity =
      <String, Map<String, List<AllCoursesRecordList>>>{}.obs;
  RxList<AllCoursesRecordList> rxWidgetCourses = <AllCoursesRecordList>[].obs;

  // Shared Lists
  RxList<UserHasCourseData> rxUserHasCourseList = <UserHasCourseData>[].obs;
  Rx<UserHasCourseData> rxEnrolledCourse = UserHasCourseData().obs;
  final RxList<dynamic> rxInstPlanList = <dynamic>[].obs;
  final RxList<dynamic> rxTypeList = <dynamic>[].obs;
  final RxList<dynamic> rxInstituteEntitiesList = <dynamic>[].obs;

  dynamic userInstituteMeta;

  late PagingController<int, AllCoursesRecordList> pagingController;
  final RxBool rxIsSearching = false.obs;
  final RxBool rxIsLoading = true.obs;
  final TextEditingController searchController = TextEditingController();
  final RxString rxSearch = "".obs;

  @override
  void onInit() {
    if (mode == CourseListMode.explore) {
      if (KipiElearning.userProvider.userType == "instituteMasterAdmin" ||
          KipiElearning.userProvider.userType == "instituteAdmin") {
        getInstituteMetaEntitiesData();
      }
    }

    _loadEntities().then((_) async {
      if (mode != CourseListMode.dashboardWidget) {
        _initPaging();
        pagingController.refresh();
      }
      if (mode == CourseListMode.explore) {
        await getInstPlanList();
      }
      await getUserHasCourse();
      await getAllCourses(1);

      super.onInit();
    });
  }

  void _initPaging() {
    pagingController = PagingController<int, AllCoursesRecordList>(
      getNextPageKey: (PagingState<int, AllCoursesRecordList> state) {
        return (state.pages != null && (state.pages?.last.isEmpty ?? true)) ? null : (state.keys?.last ?? 0) + 1;
      },
      fetchPage: (int pageKey) => getAllCourses(pageKey),
    );
  }

  Future<void> fetchData() async {
    rxIsLoading.value = true;
    try {
      await _loadEntities();
      await getUserHasCourse();
      await getAllCourses(1);
    } finally {
      rxIsLoading.value = false;
    }
  }

  Future<void> _loadEntities() async {
    final Completer<void> completer = Completer<void>();
    try {
      final entities = await KipiElearning.entityProvider.getAllEntities();
      rxEntityList.assignAll(entities);
      completer.complete();
    } catch (e) {
      if (mode != CourseListMode.dashboardWidget) {
        // Show error if needed
      }
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<bool> getUserHasCourse() async {
    final Completer<bool> completer = Completer<bool>();

    final query = {
      "userId": KipiElearning.userProvider.userId,
    };

    try {
      final enrollments = await KipiElearning.courseRepository.getUserHasCourse(
        query: query,
      );
      rxUserHasCourseList.assignAll(enrollments);
      completer.complete(true);
    } catch (e) {
      if (mode != CourseListMode.dashboardWidget) {
        // Show error if needed
      }
      completer.completeError(e);
    }

    return completer.future;
  }

  Future<bool> getInstPlanList() async {
    final Completer<bool> completer = Completer<bool>();
    // Implement plan list fetching if needed
    completer.complete(true);
    return completer.future;
  }

  Future<bool> getInstituteMetaEntitiesData() async {
    final Completer<bool> completer = Completer<bool>();
    // Implement institute meta data fetching if needed
    completer.complete(true);
    return completer.future;
  }

  bool isCourseEnrolled(String courseId) {
    return rxUserHasCourseList.any((element) => element.courseId == courseId);
  }

  UserHasCourseData? getEnrolledCourseData(String courseId) {
    return rxUserHasCourseList.firstWhereOrNull(
      (element) => element.courseId == courseId,
    );
  }

  Future<List<AllCoursesRecordList>> getAllCourses(int pageKey) async {
    rxIsLoading.value = true;
    try {
      if (mode == CourseListMode.explore) {
        return await _fetchExploreCourses(pageKey);
      } else if (mode == CourseListMode.myCourses) {
        return await _fetchMyCourses(pageKey);
      } else if (mode == CourseListMode.dashboardWidget) {
        return await _fetchDashboardCourses();
      }
    } catch (e) {
      if (mode != CourseListMode.dashboardWidget) {
        // Show error if needed
      }
    } finally {
      rxIsLoading.value = false;
    }
    return [];
  }

  Future<List<AllCoursesRecordList>> _fetchExploreCourses(int pageKey) async {
    final String role = KipiElearning.userProvider.userType ?? "";
    final query = {
      "userType": role,
      "page": pageKey,
    };
    if (rxSearch.value.isNotEmpty) {
      query["search"] = rxSearch.value;
    }

    final tempList = await KipiElearning.courseRepository.getAllCourses(query: query);

    List<String> userEntities = [];
    if (role == "teacher") {
      userEntities = KipiElearning.userProvider.interestedEntities;
    } else if (role == "instituteMasterAdmin" || role == "instituteAdmin") {
      userEntities = userInstituteMeta?.entities ?? <String>[];
    }

    final profileRelated = tempList.where((course) {
      final List<String> courseEntities = (course.entities ?? []).map((e) => e.toString()).toList();
      return courseEntities.any((e) => userEntities.contains(e)) ||
          (course.subjectId != null && userEntities.contains(course.subjectId));
    }).toList();

    final other = tempList.where((course) {
      final List<String> courseEntities = (course.entities ?? []).map((e) => e.toString()).toList();
      return !(courseEntities.any((e) => userEntities.contains(e)) ||
          (course.subjectId != null && userEntities.contains(course.subjectId)));
    }).toList();

    if (pageKey == 1) {
      rxProfileRelatedCourses.assignAll(profileRelated);
      rxOtherCourses.assignAll(other);
    } else {
      rxProfileRelatedCourses.addAll(profileRelated);
      rxOtherCourses.addAll(other);
    }

    rxProfileRelatedCoursesByEntity.assignAll(_groupCoursesByEntity(rxProfileRelatedCourses));
    rxOtherCoursesByEntity.assignAll(_groupCoursesByEntity(rxOtherCourses));

    return tempList;
  }

  Future<List<AllCoursesRecordList>> _fetchMyCourses(int pageKey) async {
    final Completer<List<AllCoursesRecordList>> completer = Completer<List<AllCoursesRecordList>>();
    final query = <String, dynamic>{
      "userType": KipiElearning.userProvider.userType,
      "courseStatus": "publish",
      "page": pageKey,
    };
    if (rxSearch.value.isNotEmpty) {
      query["search"] = rxSearch.value;
    }

    try {
      final tempList = await KipiElearning.courseRepository.getAllCourses(query: query);
      final enrolledCourses = tempList.where((course) => isCourseEnrolled(course.id ?? "")).toList();

      if (pageKey == 1) {
        rxMyCourseList.assignAll(enrolledCourses);
      } else {
        rxMyCourseList.addAll(enrolledCourses);
      }

      rxMyCoursesByEntity.assignAll(_groupCoursesByEntity(rxMyCourseList));
      pagingController.refresh();
      completer.complete(enrolledCourses);
    } catch (e) {
      completer.completeError(e);
    }
    return completer.future;
  }

  Future<List<AllCoursesRecordList>> _fetchDashboardCourses() async {
    final Completer<List<AllCoursesRecordList>> completer = Completer<List<AllCoursesRecordList>>();
    final query = <String, dynamic>{
      "userType": "teacher",
      "courseStatus": "publish",
      "page": 1,
    };

    try {
      var tempList = await KipiElearning.courseRepository.getAllCourses(query: query);
      final interestedEntities = KipiElearning.userProvider.interestedEntities;

      if (interestedEntities.isNotEmpty) {
        tempList = tempList.where((course) {
          final List<String> courseEntities = (course.entities ?? []).map((e) => e.toString()).toList();
          return courseEntities.any((e) => interestedEntities.contains(e)) ||
              (course.subjectId != null && interestedEntities.contains(course.subjectId));
        }).toList();
      }

      rxWidgetCourses.assignAll(tempList);
      rxWidgetCoursesByEntity.assignAll(_groupCoursesByEntity(rxWidgetCourses));
      completer.complete(tempList);
    } catch (e) {
      completer.completeError(e);
    }

    return completer.future;
  }

  Map<String, Map<String, List<AllCoursesRecordList>>> _groupCoursesByEntity(List<AllCoursesRecordList> courses) {
    final Map<String, Map<String, List<AllCoursesRecordList>>> grouped = {};

    for (final course in courses) {
      final entities = course.entities ?? [];
      if (entities.isEmpty) {
        final entityKey = "Other";
        if (!grouped.containsKey(entityKey)) {
          grouped[entityKey] = {};
        }
        final pathKey = course.subjectId ?? "General";
        if (!grouped[entityKey]!.containsKey(pathKey)) {
          grouped[entityKey]![pathKey] = [];
        }
        grouped[entityKey]![pathKey]!.add(course);
      } else {
        for (final entity in entities) {
          final entityKey = entity.toString();
          if (!grouped.containsKey(entityKey)) {
            grouped[entityKey] = {};
          }
          final pathKey = course.subjectId ?? "General";
          if (!grouped[entityKey]!.containsKey(pathKey)) {
            grouped[entityKey]![pathKey] = [];
          }
          grouped[entityKey]![pathKey]!.add(course);
        }
      }
    }

    return grouped;
  }
}
