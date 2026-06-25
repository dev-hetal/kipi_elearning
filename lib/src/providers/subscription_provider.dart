/// Abstract interface for subscription data
/// Host app must implement this to provide subscription information
abstract class SubscriptionProvider {
  /// Get institute subscription plans
  Future<List<dynamic>> getInstPlan({
    required Map<String, dynamic> query,
  });

  /// Check if user has active subscription
  bool hasActiveSubscription();

  /// Get subscription expiry date
  DateTime? getSubscriptionExpiry();

  /// Check if course is included in subscription
  bool isCourseIncludedInSubscription({
    required String courseId,
  });
}
