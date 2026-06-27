/// Abstract interface for wallet operations
/// Host app must implement this to provide wallet functionality
abstract class WalletProvider {
  /// Enroll user in a course using wallet credits
  Future<bool> enrollCourseWithWallet({
    required String courseId,
    required Map<String, dynamic> body,
  });

  /// Get user's wallet balance
  Future<num> getWalletBalance();

  /// Check if user has sufficient balance for a course
  bool hasSufficientBalance({
    required num coursePrice,
    required num currentBalance,
  });

  /// Navigate to wallet screen for buying credits
  void navigateToWallet();

  /// Create a wallet transaction
  Future<bool> createWalletTransaction({
    required Map<String, dynamic> body,
  });
}
