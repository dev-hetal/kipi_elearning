/// Abstract interface for course index/chapter data
/// Host app must implement this to provide index operations
abstract class IndexProvider {
  /// Fetch index by subject ID
  Future<dynamic> getIndexBySubjectId({
    required Map<String, dynamic> query,
  });

  /// Create a new index topic or subtopic
  Future<void> createIndex({
    required Map<String, dynamic> body,
  });

  /// Update an existing index
  Future<void> updateIndex({
    required String id,
    required Map<String, dynamic> body,
  });

  /// Assign chapter/index to users
  Future<void> assignChapterToUsers({
    required Map<String, dynamic> body,
  });

  /// Get assigned chapters
  Future<dynamic> getAssignedChapters({
    required Map<String, dynamic> query,
  });

  /// Merge course index (for teachers)
  Future<bool> mergeCourseIndex({
    required Map<String, dynamic> body,
  });
}
