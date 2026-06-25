import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/course_index_details_controller.dart';

class CourseIndexDetailsScreen extends GetView<CourseIndexDetailsController> {
  const CourseIndexDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.rxTitle.value.isNotEmpty ? controller.rxTitle.value : 'Content Details')),
      ),
      body: Obx(() {
        return Column(
          children: [
            // Tab Bar
            TabBar(
              controller: controller.tabController.value,
              labelColor: Colors.blue,
              indicatorColor: Colors.blue,
              tabs: const [
                Tab(text: 'Shared Materials'),
                Tab(text: 'Homework'),
                Tab(text: 'Classwork'),
              ],
            ),
            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: controller.tabController.value,
                children: [
                  _buildFileListTab(controller.rxSharedMaterialFiles),
                  _buildFileListTab(controller.rxHomeworkFiles),
                  _buildFileListTab(controller.rxClassworkFiles),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFileListTab(RxList<dynamic> fileList) {
    return Obx(() {
      if (fileList.isEmpty) {
        return const Center(child: Text('No files available'));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: fileList.length,
        itemBuilder: (context, index) {
          final file = fileList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(controller.getFileName(file)),
              subtitle: Text(controller.getFileTypeLabel(file)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                //TODO: Handle file tap - would need file preview integration
              },
            ),
          );
        },
      );
    });
  }
}
