import '../providers/course_repository.dart';
import '../providers/entity_provider.dart';
import '../providers/index_provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/user_provider.dart';
import 'elearning_theme.dart';

class KipiElearning {
  KipiElearning._();

  // Required Providers
  static late final CourseRepository courseRepository;
  static late final UserProvider userProvider;
  static late final IndexProvider indexProvider;
  static late final EntityProvider entityProvider;
  static late final NavigationProvider navigationProvider;

  // Optional Configuration
  static late final ElearningTheme theme;
  static String Function(String)? translator;
  static void Function(String)? onSuccessMessage;
  static void Function(String)? onErrorMessage;

  /// Initialize the Kipi E-Learning package
  static void initialize({
    required CourseRepository courseRepository,
    required UserProvider userProvider,
    required IndexProvider indexProvider,
    required EntityProvider entityProvider,
    required NavigationProvider navigationProvider,
    ElearningTheme? theme,
    String Function(String)? translator,
    void Function(String)? onSuccessMessage,
    void Function(String)? onErrorMessage,
  }) {
    KipiElearning.courseRepository = courseRepository;
    KipiElearning.userProvider = userProvider;
    KipiElearning.indexProvider = indexProvider;
    KipiElearning.entityProvider = entityProvider;
    KipiElearning.navigationProvider = navigationProvider;
    KipiElearning.theme = theme ?? ElearningTheme();
    KipiElearning.translator = translator;
    KipiElearning.onSuccessMessage = onSuccessMessage;
    KipiElearning.onErrorMessage = onErrorMessage;
  }

  /// Check if the package is initialized
  static bool get isInitialized => true;
}
