/// Abstract interface for user data
/// Host app must implement this to provide user information
abstract class UserProvider {
  /// Get current user ID
  String get userId;

  /// Get current user UUID
  String get userUuid;

  /// Get current user type (student, teacher, parent, etc.)
  String get userType;

  /// Get current app type (school, institute, etc.)
  String get appType;

  /// Get user's interested entities (for course filtering)
  List<String> get interestedEntities;

  /// Get user's email
  String? get userEmail;

  /// Get user's mobile number
  String? get userMobile;

  /// Check if user is authenticated
  bool get isAuthenticated;
}
