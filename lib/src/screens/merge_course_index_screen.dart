import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:kipi_elearning/kipi_elearning.dart";

import "../controllers/merge_course_index_controller.dart";

class MergeCourseIndexScreen extends GetView<MergeCourseIndexController> {
  const MergeCourseIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildView(),
      bottomNavigationBar: Obx(() {
        return !controller.isLoading.value
            ? SafeArea(child: buildMergeIndexButton().paddingAll(16))
            : const SizedBox.shrink();
      }),
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
        "Merge With My Index",
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [buildModuleList()],
          ),
        ),
      );
    });
  }

  Widget buildMergeIndexButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        backgroundColor: Theme.of(Get.context!).primaryColor,
      ),
      onPressed: () async {
        await controller.mergeIndex();
      },
      child: const Text(
        "Merge Index Now",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget buildModuleList() {
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
              child: CheckboxListTile(
                title: Text("Module ${i + 1}"),
                subtitle: const Text("Course content"),
                value: controller.isSelected(controller.rxDataList[i]),
                onChanged: (_) => controller.toggleSelection(controller.rxDataList[i]),
              ),
            ),
        ],
      );
    });
  }
}
