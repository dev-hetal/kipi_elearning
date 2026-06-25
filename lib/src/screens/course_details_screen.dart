import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_rating_bar/flutter_rating_bar.dart";
import "package:get/get.dart";
import "package:kipi_elearning/kipi_elearning.dart";

import "../controllers/course_details_controller.dart";

class CourseDetailsScreen extends GetView<CourseDetailsController> {
  const CourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildView(),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          KipiElearning.navigationProvider.pop();
        },
        icon: const Icon(Icons.arrow_back),
      ),
      centerTitle: false,
      titleSpacing: 0,
      title: const Text(
        "Course Details",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      bottom: const PreferredSize(
        preferredSize: Size(double.infinity, 0),
        child: Divider(height: 0),
      ),
    );
  }

  Widget buildView() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 16),
              // Banner
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                child: _buildThumbnail(),
              ).paddingSymmetric(horizontal: 14),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Title
                    Text(
                      controller.rxCourse?.value.title ?? "",
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    // Description
                    Text(
                      controller.rxCourse?.value.subTitle ?? "",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.rxCourse?.value.courseStatus ?? "",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
                    ),
                    const SizedBox(height: 14),
                    // Price Row
                    Row(
                      children: <Widget>[
                        Visibility(
                          visible: controller.rxCourse?.value.price != null && controller.rxCourse?.value.price != 0,
                          child: const Icon(Icons.monetization_on, size: 16).paddingOnly(right: 4),
                        ),
                        Visibility(
                          visible: controller.rxCourse?.value.price != null && controller.rxCourse?.value.price != 0,
                          child: Text(
                            controller.rxCourse?.value.price?.toString() ?? "",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                        ),
                        const Spacer(),
                        Visibility(
                          visible: controller.isCourseEnrolled(controller.rxCourse?.value.id ?? ""),
                          child: _buildEnrolledStatus(),
                        ),
                        Visibility(
                          visible: (controller.rxCourse?.value.price == 0),
                          child: const Text(
                            "Free",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: controller.rxEnrolledCourse.value.expiryDate != null &&
                          controller.isCourseEnrolled(controller.rxCourse?.value.id ?? ""),
                      child: Text(
                        "Expires on ${controller.rxEnrolledCourse.value.expiryDate}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(Get.context!).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (controller.rxEnrolledCourse.value.courseId != null &&
                        KipiElearning.userProvider.interestedEntities.contains(controller.rxCourse?.value.subjectId))
                      _buildMergeIndexButton().paddingOnly(bottom: 16)
                    else if (controller.rxEnrolledCourse.value.courseId == null)
                      Column(
                        children: [
                          _buildEnrollCourse(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    // Rating + Instructor Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: <Widget>[
                          // Rating
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _buildRatingStars(4.5),
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: () {
                                    unawaited(
                                      KipiElearning.navigationProvider.pushNamed(
                                        route: '/rating-review-screen',
                                        arguments: <String, dynamic>{},
                                      ),
                                    );
                                  },
                                  child: const Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("15K reviews"),
                                      SizedBox(width: 4),
                                      Icon(Icons.arrow_forward, size: 12, color: Colors.grey),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text("Enrollment"),
                                const Text("83,681"),
                              ],
                            ),
                          ),
                          // Instructor
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text("Created By"),
                                Text(controller.rxCourse?.value.createdBy ?? ""),
                                const SizedBox(height: 10),
                                const Text("Instructor"),
                                Text(controller.rxCourse?.value.instructor ?? ""),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        "This Course Includes",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Course Includes Chips
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        _includeItem(Icons.access_time, "62.5 Hours on-demand video"),
                        _includeItem(Icons.video_library, "104 Videos"),
                        _includeItem(Icons.subject, "41 Articles"),
                        _includeItem(Icons.download, "5 Downloadable Resources"),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Center(
                      child: Text(
                        "Course Content",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildModuleList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildThumbnail() {
    final imageUrl = controller.rxCourse?.value.courseThumbNail?.presignedUrl ?? "";
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        height: 140,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 140,
            color: Colors.grey.shade200,
            child: const Icon(Icons.image, size: 50, color: Colors.grey),
          );
        },
      );
    }
    return Container(
      height: 140,
      color: Colors.grey.shade200,
      child: const Icon(Icons.image, size: 50, color: Colors.grey),
    );
  }

  Widget _buildEnrolledStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        "ENROLLED",
        style: TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }

  Widget _buildEnrollCourse() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: Theme.of(Get.context!).primaryColor,
      ),
      onPressed: () async {
        unawaited(
          KipiElearning.navigationProvider.pushNamed(
            route: '/course-checkout-screen',
            arguments: <String, dynamic>{
              "course": controller.rxCourse?.value.toJson(),
            },
          ).then(
            (value) {
              controller.getUserHasCourse();
            },
          ),
        );
      },
      child: const Text(
        "Enroll Now",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildMergeIndexButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: Theme.of(Get.context!).primaryColor,
      ),
      onPressed: () async {
        await KipiElearning.navigationProvider.pushNamed(
          route: '/merge-course-index-screen',
          arguments: <String, dynamic>{"course": controller.rxCourse?.value.toJson()},
        );
      },
      child: const Text(
        "Merge With My Index",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return RatingBar(
      initialRating: rating,
      minRating: 0.5,
      allowHalfRating: true,
      itemPadding: const EdgeInsets.only(right: 6.0),
      itemSize: 20.0,
      ratingWidget: RatingWidget(
        full: const Icon(Icons.star, color: Colors.amber),
        half: const Icon(Icons.star_half, color: Colors.amber),
        empty: const Icon(Icons.star_border, color: Colors.amber),
      ),
      onRatingUpdate: (double ratingValue) {},
      ignoreGestures: true,
    );
  }

  Widget _includeItem(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 20, color: Theme.of(Get.context!).primaryColor),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildModuleList() {
    return Obx(() {
      if (controller.rxDataList.isEmpty) {
        return const SizedBox();
      }
      // Simplified module list - in real implementation would use tree view
      return Column(
        children: [
          for (var i = 0; i < controller.rxDataList.length; i++)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text("Module ${i + 1}"),
                subtitle: Text("Course content"),
              ),
            ),
        ],
      );
    });
  }
}
