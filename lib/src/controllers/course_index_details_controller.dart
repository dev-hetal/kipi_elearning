import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/elearning_enums.dart';

class CourseIndexDetailsController extends GetxController with GetTickerProviderStateMixin {
  final Rx<TabController?> tabController = (null as TabController?).obs;

  /// The index data passed from the course details screen
  final Rx<dynamic> rxIndexData = Rx<dynamic>(null);

  /// Title and prefix for breadcrumb display
  final RxString rxTitle = ''.obs;
  final RxString rxPrefix = ''.obs;

  /// Files separated by type
  final RxList<dynamic> rxVideoFiles = <dynamic>[].obs;
  final RxList<dynamic> rxHomeworkFiles = <dynamic>[].obs;
  final RxList<dynamic> rxClassworkFiles = <dynamic>[].obs;

  /// All shared material files (type == VIDEO or others that are not CLASS_WORK/HOME_WORK)
  final RxList<dynamic> rxSharedMaterialFiles = <dynamic>[].obs;

  @override
  void onInit() {
    tabController(TabController(length: 3, vsync: this));

    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      final Map<String, dynamic> arguments = Get.arguments;

      if (arguments.containsKey('data')) {
        final Map<String, dynamic> jsonData = json.decode(arguments['data']);
        rxIndexData.value = jsonData;
      }

      if (arguments.containsKey('title')) {
        rxTitle.value = arguments['title'];
      }

      if (arguments.containsKey('prefix')) {
        rxPrefix.value = arguments['prefix'];
      }
    }

    _categorizeFiles();
    super.onInit();
  }

  void _categorizeFiles() {
    final dynamic indexData = rxIndexData.value;
    final List<dynamic> allFiles = indexData['files'] as List<dynamic>? ?? [];

    final List<dynamic> videos = <dynamic>[];
    final List<dynamic> homework = <dynamic>[];
    final List<dynamic> classwork = <dynamic>[];
    final List<dynamic> sharedMaterials = <dynamic>[];

    for (final dynamic file in allFiles) {
      final String fileType = file['type']?.toString() ?? '';

      if (fileType == FileFormat.video.api) {
        videos.add(file);
        sharedMaterials.add(file);
      } else if (fileType == HomeWorkClassWorkType.homework.api) {
        homework.add(file);
      } else if (fileType == HomeWorkClassWorkType.classwork.api) {
        classwork.add(file);
      } else {
        sharedMaterials.add(file);
      }
    }

    rxVideoFiles.assignAll(videos);
    rxHomeworkFiles.assignAll(homework);
    rxClassworkFiles.assignAll(classwork);
    rxSharedMaterialFiles.assignAll(sharedMaterials);
  }

  /// Get the video/file URL from the file object
  String getFileUrl(dynamic file) {
    final fileStorageDetails = file['fileStorageDetails'];
    if (fileStorageDetails != null) {
      return fileStorageDetails['filePath']?.toString() ?? '';
    }
    return file['fileLink']?.toString() ?? '';
  }

  /// Get a display name for the file
  String getFileName(dynamic file) {
    return file['title']?.toString() ?? file['fileStorageDetails']?['originalFileName']?.toString() ?? '';
  }

  /// Get file type label for display
  String getFileTypeLabel(dynamic file) {
    final String type = file['type']?.toString() ?? '';
    if (type == FileFormat.video.api) {
      return 'Video';
    } else if (type == HomeWorkClassWorkType.homework.api) {
      return 'Homework';
    } else if (type == HomeWorkClassWorkType.classwork.api) {
      return 'Classwork';
    } else {
      return type;
    }
  }
}

class CourseIndexDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseIndexDetailsController());
  }
}
