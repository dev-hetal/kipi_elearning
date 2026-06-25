import '../models/get_all_courses_model.dart';
import '../config/elearning_config.dart';

class CourseSectionHelper {
  /// Group courses by standard
  static Map<String, List<AllCoursesRecordList>> groupCoursesByStandard(
    List<AllCoursesRecordList> courses,
    List<dynamic> entities,
  ) {
    // Filter only standard entities (entityType title contains 'standard')
    final standardEntities = entities.where((e) {
      final entityType = e['entityType'];
      if (entityType != null && entityType['title'] != null) {
        return entityType['title']
            .toString()
            .toLowerCase()
            .contains('standard');
      }
      return false;
    }).toList();

    final Map<String, List<AllCoursesRecordList>> grouped = {};

    // Initialize map entries for each standard title
    for (final entity in standardEntities) {
      final title = entity['title']?.toString() ?? 'Unknown';
      grouped[title] = [];
    }

    // Assign courses to corresponding standard based on matching entity IDs
    for (final course in courses) {
      final courseEntityIds =
          (course.entities ?? []).map((e) => e.toString()).toSet();
      for (final entity in standardEntities) {
        final entityId = entity['id']?.toString();
        if (entityId != null && courseEntityIds.contains(entityId)) {
          final title = entity['title']?.toString() ?? 'Unknown';
          grouped[title]?.add(course);
          break;
        }
      }
    }

    // If no courses were grouped, put all under a generic key
    if (grouped.values.every((list) => list.isEmpty)) {
      grouped['All Courses'] = courses;
    }

    return grouped;
  }

  /// Groups courses first by top-level entity (e.g., School, Play House) and then
  /// by the standard/subject within that entity.
  static Map<String, Map<String, List<AllCoursesRecordList>>>
      groupCoursesByEntity(
    List<AllCoursesRecordList> courses,
    List<dynamic> entities,
  ) {
    // Identify standard and top-level entities.
    final standardEntities = entities.where((e) {
      final entityType = e['entityType'];
      if (entityType != null && entityType['title'] != null) {
        return entityType['title']
            .toString()
            .toLowerCase()
            .contains('standard');
      }
      return false;
    }).toList();

    final topEntities = entities.where((e) {
      final entityType = e['entityType'];
      if (entityType != null && entityType['title'] != null) {
        return !entityType['title']
            .toString()
            .toLowerCase()
            .contains('standard');
      }
      return false;
    }).toList();

    // Helper maps for quick lookup.
    final Map<String, dynamic> topById = {};
    for (var te in topEntities) {
      final id = te['id']?.toString();
      if (id != null) {
        topById[id] = te;
      }
    }

    // Result container.
    final Map<String, Map<String, List<AllCoursesRecordList>>> result = {};

    // Initialize outer map entries.
    for (final top in topEntities) {
      final topTitle = top['title']?.toString() ?? 'Unknown';
      result[topTitle] = {};
    }

    // Initialize inner maps for standards under their respective top entity.
    for (final standard in standardEntities) {
      // The parent entity is identified via entityId linking to a top entity.
      final parentId = standard['entityId']?.toString();
      final parentEntity = parentId != null ? topById[parentId] : null;
      final parentTitle = parentEntity?['title']?.toString() ?? 'Other';
      final standardTitle = standard['title']?.toString() ?? 'Unknown';
      result.putIfAbsent(parentTitle, () => {});
      result[parentTitle]![standardTitle] = [];
    }

    // Assign courses to the appropriate bucket.
    for (final course in courses) {
      final courseEntityIds =
          (course.entities ?? []).map((e) => e.toString()).toSet();
      // Find the first matching standard entity.
      dynamic matchedStandard;
      for (final se in standardEntities) {
        final id = se['id']?.toString();
        if (id != null && courseEntityIds.contains(id)) {
          matchedStandard = se;
          break;
        }
      }
      if (matchedStandard == null) {
        continue;
      }
      final parentId = matchedStandard['entityId']?.toString();
      final parentEntity = parentId != null ? topById[parentId] : null;
      final parentTitle = parentEntity?['title']?.toString() ?? 'Other';
      final standardTitle = matchedStandard['title']?.toString() ?? 'Unknown';
      result[parentTitle] ??= {};
      result[parentTitle]![standardTitle] ??= [];
      result[parentTitle]![standardTitle]!.add(course);
    }

    // Remove empty entries to keep UI clean.
    result
        .removeWhere((_, inner) => inner.values.every((list) => list.isEmpty));
    return result;
  }

  /// Group courses by subject hierarchy using EntityProvider
  static Future<Map<String, Map<String, List<AllCoursesRecordList>>>>
      groupCoursesBySubjectHierarchy(
    List<AllCoursesRecordList> courses,
    List<dynamic> entities,
  ) async {
    final Map<String, Map<String, List<AllCoursesRecordList>>> result = {};

    for (final course in courses) {
      final subjectId = course.subjectId;
      if (subjectId == null) {
        continue;
      }

      // Get subject entity and its ancestor chain using EntityProvider
      try {
        final subjectEntity =
            await KipiElearning.entityProvider.getEntityFromSubjectId(
          subjectId: subjectId,
          entityType: 'SUBJECT',
        );

        // If subject entity not found, skip
        if (subjectEntity == null || subjectEntity['id'] == null) {
          continue;
        }

        // Retrieve all parent entities (ancestors) for the subject
        final ancestors =
            await KipiElearning.entityProvider.getParentsFromChild(
          childId: subjectId,
        );

        // Collect path segments (titles) and identify the standard title
        final List<String> pathSegments = [];
        String? standardTitle;

        final subjectTitle = subjectEntity['title']?.toString();
        if (subjectTitle != null && subjectTitle.isNotEmpty) {
          pathSegments.add(subjectTitle);
        }

        for (final reg in ancestors) {
          final title = reg['title']?.toString();
          if (title != null && title.isNotEmpty) {
            pathSegments.add(title);
          }
          final entityType = reg['entityType'];
          if (standardTitle == null &&
              entityType != null &&
              entityType['title'] != null &&
              entityType['title']
                  .toString()
                  .toLowerCase()
                  .contains('standard')) {
            standardTitle = title;
          }
          // Stop when we reach the top institute entity
          if (entityType != null && entityType['title'] == 'INSTITUTE_TYPE') {
            break;
          }
        }

        if (pathSegments.isEmpty) {
          continue;
        }
        final String fullPath = pathSegments.reversed.join(' / ');
        final String outerKey = standardTitle ?? pathSegments.first;

        result.putIfAbsent(outerKey, () => {});
        result[outerKey]![fullPath] ??= [];
        result[outerKey]![fullPath]!.add(course);
      } catch (e) {
        // Skip course if hierarchy lookup fails
        continue;
      }
    }

    // Remove empty groups to keep UI clean
    result
        .removeWhere((_, inner) => inner.values.every((list) => list.isEmpty));
    return result;
  }
}
