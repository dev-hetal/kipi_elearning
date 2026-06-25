/// Abstract interface for wallet integration
/// Host app must implement this to provide payment functionality
abstract class WalletProvider {
  /// Enroll user in course using wallet credits
  Future<bool> enrollCourseWithWallet({
    required String courseId,
    required num amount,
    Map<String, dynamic>? additionalData,
  });

  /// Get user's wallet balance
  Future<num> getWalletBalance();

  /// Check if user has sufficient balance
  Future<bool> hasSufficientBalance({
    required num amount,
  });

  /// Navigate to wallet screen for adding credits
  Future<void> navigateToWallet();

  /// Create wallet transaction for course enrollment
  Future<bool> createWalletTransaction({
    required Map<String, dynamic> body,
  });
}
