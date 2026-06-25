/// Abstract interface for entity data
/// Host app must implement this to provide entity hierarchy
abstract class EntityProvider {
  /// Get all entities (institute, school, standard, subject, etc.)
  Future<List<dynamic>> getAllEntities();

  /// Get entity data from subject ID
  Future<dynamic> getEntityFromSubjectId({
    required String subjectId,
    required String entityType,
  });

  /// Get parent entities from child ID (for hierarchy)
  Future<List<dynamic>> getParentsFromChild({
    required String childId,
  });

  /// Get academic data by ID
  Future<dynamic> getAcademicDataById({
    required String id,
  });

  /// Split entity list for UI display
  List<dynamic> entitiyListToSplittedList({
    required List<dynamic> entities,
  });
}
