import 'package:get/get.dart';

import 'languages/elearning_en_in_language.dart';
import 'languages/elearning_gu_in_language.dart';

class ElearningTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_IN': enInLanguage,
        'gu_IN': guInLanguage,
      };
}
