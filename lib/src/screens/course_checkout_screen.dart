import "dart:async";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:kipi_elearning/kipi_elearning.dart";

import "../controllers/course_checkout_controller.dart";

class CourseCheckoutScreen extends GetView<CourseCheckoutController> {
  const CourseCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(color: Colors.white, child: const Center(child: CircularProgressIndicator()));
      }
      return Scaffold(
        appBar: buildAppBar(context),
        bottomNavigationBar: buildPurchaseNow(context),
        body: buildView(context),
      );
    });
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
        "Check Out",
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

  Widget buildView(BuildContext context) {
    return Obx(() {
      final course = controller.rxCourse?.value;
      final price = course?.price ?? 0;

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(14)),
              child: _buildThumbnail(),
            ),
            const SizedBox(height: 16),
            Text(
              course?.title ?? "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              "0 Total Hours • 0 Lectures",
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                const Icon(Icons.monetization_on, size: 16),
                const SizedBox(width: 4),
                Text(
                  "$price",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 12),
                Opacity(
                  opacity: 0.5,
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.monetization_on, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        price.toString(),
                        style: const TextStyle(decoration: TextDecoration.lineThrough),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  "83% off",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
                ),
                const Spacer(),
                Text(
                  "Valid for Year",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Theme.of(context).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      "Summary",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    _summaryRow("Price", price.toString()),
                    const SizedBox(height: 12),
                    Visibility(
                      visible: price == 0,
                      child: Container(
                        width: double.infinity,
                        color: Colors.lightGreen.shade100,
                        child: const Text(
                          "Course Available For Free In Subscription Plan",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.green),
                          textAlign: TextAlign.center,
                        ).paddingSymmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    _summaryRow("Total Payable", "$price", isBold: true),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
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

  static Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        const Spacer(),
        Row(
          children: <Widget>[
            const Icon(Icons.monetization_on, size: 16),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildPurchaseNow(BuildContext context) {
    return Obx(() {
      return SafeArea(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            backgroundColor:
                controller.rxEnrolledCourse.value.id != null ? Colors.grey.shade400 : Theme.of(context).primaryColor,
          ),
          onPressed: controller.rxEnrolledCourse.value.id != null
              ? null
              : () async {
                  final bool isEnrolled = await controller.enrollCourse();
                  if (!isEnrolled) {
                    showInsufficientCreditsSheet(context);
                  } else {
                    KipiElearning.navigationProvider.pop();
                  }
                },
          child: Text(
            controller.rxEnrolledCourse.value.id != null
                ? "Purchased"
                : controller.rxCourse?.value.price != null && controller.rxCourse?.value.price != 0
                    ? "Purchase Now"
                    : "Enroll Now",
            style: TextStyle(
              color: controller.rxEnrolledCourse.value.id != null ? Colors.black38 : Colors.white,
            ),
          ),
        ).paddingAll(16),
      );
    });
  }

  void showInsufficientCreditsSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).padding.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Top drag handle
                Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                // Warning icon
                const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  "Insufficient Credits",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Running out of credit? Buy credit to proceed further.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 26),
                // Primary Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () async {
                    // Navigate to wallet screen
                    KipiElearning.navigationProvider.pop();
                  },
                  child: const Text(
                    "Buy Credit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 14),
                // Secondary Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Go Back",
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
