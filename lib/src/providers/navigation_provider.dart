/// Abstract interface for navigation
/// Host app must implement this to provide navigation functionality
abstract class NavigationProvider {
  /// Push a named route with arguments
  Future<T?> pushNamed<T>({
    required String route,
    Map<String, dynamic>? arguments,
    List<String>? moduleCodeList,
    List<String>? featureCodeList,
    List<String>? actionCodeList,
  });

  /// Push a named route and remove all previous routes
  Future<T?> newPushNamed<T>({
    required String route,
    Map<String, dynamic>? arguments,
  });

  /// Pop current route with optional result
  void pop<T>({T? result});

  /// Pop until a specific route
  void popUntil(String routeName);

  /// Get current route name
  String? getCurrentRoute();
}
