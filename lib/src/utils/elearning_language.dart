import 'package:get/get.dart';

import '../config/elearning_config.dart';

class ElearningLanguage {
  ElearningLanguage._();

  /// Translate a key using the fallback chain:
  /// 1. Custom translator (if provided)
  /// 2. GetX translations (host app overrides)
  /// 3. Package translations
  /// 4. GetX .tr fallback
  /// 5. Package default (English)
  static String translate(String key) {
    // 1. Custom translator
    if (KipiElearning.translator != null) {
      final customTranslation = KipiElearning.translator!(key);
      if (customTranslation.isNotEmpty) {
        return customTranslation;
      }
    }

    // 2. GetX translations (host app)
    try {
      final getxTranslation = key.tr;
      if (getxTranslation != key) {
        return getxTranslation;
      }
    } catch (_) {
      // Ignore GetX translation errors
    }

    // 3. Package translations (would need to implement package-specific translations)
    // For now, fall through to GetX .tr

    // 4. GetX .tr fallback
    try {
      return key.tr;
    } catch (_) {
      // 5. Package default (return key as fallback)
      return key;
    }
  }

  /// Show success message using configured callback
  static void showSuccess(String message) {
    if (KipiElearning.onSuccessMessage != null) {
      KipiElearning.onSuccessMessage!(message);
    } else {
      Get.snackbar(
        'Success',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Show error message using configured callback
  static void showError(String message) {
    if (KipiElearning.onErrorMessage != null) {
      KipiElearning.onErrorMessage!(message);
    } else {
      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }
}
