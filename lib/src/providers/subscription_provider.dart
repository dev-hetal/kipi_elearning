/// Abstract interface for subscription operations
/// Host app must implement this to provide subscription functionality
abstract class SubscriptionProvider {
  /// Get institute subscription plans
  Future<List<dynamic>> getInstPlan();

  /// Check if institute has active subscription
  bool hasActiveSubscription();

  /// Get subscription expiry date
  String? getSubscriptionExpiry();

  /// Check if a course is included in the subscription plan
  bool isCourseIncludedInSubscription({
    required String courseId,
  });
}
