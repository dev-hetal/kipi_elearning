import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/merge_course_index_controller.dart';
import '../config/elearning_config.dart';

class MergeCourseIndexScreen extends GetView<MergeCourseIndexController> {
  const MergeCourseIndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Merge Course Index'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.rxDataList.isEmpty) {
          return const Center(child: Text('No index data available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.rxDataList.length,
          itemBuilder: (context, index) {
            final item = controller.rxDataList[index];
            final isSelected = controller.isSelected(item);

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: CheckboxListTile(
                title: Text(item['title']?.toString() ?? 'No Title'),
                value: isSelected,
                onChanged: (_) => controller.toggleSelection(item),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        return !controller.isLoading.value
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: controller.selectedIndices.isEmpty
                      ? null
                      : controller.mergeIndex,
                  child: const Text('Merge Index Now'),
                ),
              )
            : const SizedBox.shrink();
      }),
    );
  }
}
