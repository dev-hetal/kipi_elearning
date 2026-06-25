import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";
import "package:get/get.dart";
import "package:kipi_elearning/kipi_elearning.dart";

import "../widgets/course_detail_card.dart";

class UnifiedCourseScreen extends StatelessWidget {
  final UnifiedCourseController controller;
  final CourseListMode mode;

  const UnifiedCourseScreen({
    super.key,
    required this.controller,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: buildAppBar(context),
        body: buildView(context),
      );
    });
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    final titleString = mode == CourseListMode.myCourses ? "My Courses" : "Explore Courses";

    return AppBar(
      leading: IconButton(
        onPressed: () {
          if (controller.rxIsSearching.value) {
            controller.rxIsSearching.value = false;
            controller.searchController.clear();
            controller.rxSearch.value = "";
          } else {
            KipiElearning.navigationProvider.pop();
          }
        },
        icon: const Icon(Icons.arrow_back),
      ),
      centerTitle: false,
      titleSpacing: 0,
      title: controller.rxIsSearching.value
          ? TextFormField(
              controller: controller.searchController,
              decoration: const InputDecoration(
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                hintText: "Search courses...",
                border: InputBorder.none,
              ),
              onChanged: (String query) async {
                controller.rxSearch.value = query;
                if (query.length >= 3 || query.isEmpty) {
                  await controller.getAllCourses(1);
                }
              },
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  titleString,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      actions: <Widget>[
        if (controller.rxIsSearching.value)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              controller.rxIsSearching.value = false;
              controller.searchController.clear();
              controller.rxSearch.value = "";
              await controller.getAllCourses(1);
            },
          )
        else
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              controller.rxIsSearching.value = true;
            },
          ),
        const SizedBox(width: 10),
      ],
      bottom: const PreferredSize(
        preferredSize: Size(double.infinity, 0),
        child: Divider(height: 0),
      ),
    );
  }

  Widget buildView(BuildContext context) {
    if (controller.rxIsLoading.value) {
      return Center(child: SpinKitCircle(color: Theme.of(context).primaryColor));
    }
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          controller.pagingController.refresh();
          await controller.getAllCourses(1);
        },
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  Obx(() {
                    if (controller.rxIsLoading.value) {
                      return Center(child: SpinKitCircle(color: Theme.of(context).primaryColor));
                    }

                    if (mode == CourseListMode.explore) {
                      if (controller.rxProfileRelatedCoursesByEntity.isNotEmpty ||
                          controller.rxOtherCoursesByEntity.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.rxProfileRelatedCoursesByEntity.isNotEmpty) ...[
                              const Text(
                                "Profile Related Courses",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 16),
                              ...controller.rxProfileRelatedCoursesByEntity.entries.map((entityEntry) {
                                final entityKey = entityEntry.key;
                                final entityValue = entityEntry.value;
                                return _buildEntityGroup(context, entityKey, entityValue);
                              }),
                            ],
                            if (controller.rxOtherCoursesByEntity.isNotEmpty) ...[
                              const Text(
                                "Other Courses",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 16),
                              ...controller.rxOtherCoursesByEntity.entries.map((entityEntry) {
                                final entityKey = entityEntry.key;
                                final entityValue = entityEntry.value;
                                return _buildEntityGroup(context, entityKey, entityValue);
                              }),
                            ],
                          ],
                        );
                      }
                    } else if (mode == CourseListMode.myCourses) {
                      if (controller.rxMyCoursesByEntity.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...controller.rxMyCoursesByEntity.entries.map((entityEntry) {
                              final entityKey = entityEntry.key;
                              final entityValue = entityEntry.value;
                              return _buildEntityGroup(context, entityKey, entityValue);
                            }),
                          ],
                        );
                      }
                    }

                    return const Center(
                      child: Text("No courses found"),
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEntityGroup(
      BuildContext context, String entityKey, Map<String, List<AllCoursesRecordList>> entityValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          entityKey,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...entityValue.entries.map((pathEntry) {
          final path = pathEntry.key;
          final courses = pathEntry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                path,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              ...courses.map((course) => _courseCard(context, course)),
              const SizedBox(height: 24),
            ],
          );
        }),
      ],
    );
  }

  Widget _courseCard(BuildContext context, AllCoursesRecordList item) {
    String? expiryDateString;
    if (mode == CourseListMode.myCourses) {
      final enrolledData = controller.getEnrolledCourseData(item.id ?? "");
      if (enrolledData?.expiryDate != null) {
        expiryDateString = enrolledData!.expiryDate.toString();
      }
    }

    return CourseDetailCard(
      course: item,
      cardType: CourseCardType.listing,
      isEnrolled: controller.isCourseEnrolled(item.id ?? ""),
      expiryDate: expiryDateString,
      onTap: () {
        unawaited(
          KipiElearning.navigationProvider.pushNamed(
            route: '/course-details-screen',
            arguments: <String, dynamic>{"course": item.toJson()},
          ),
        );
      },
    );
  }
}
