# Kipi E-Learning Package

A reusable Flutter package for e-learning course management, enrollment, and content delivery. This package provides a complete e-learning module that can be integrated into any Flutter application.

## Features

- **Course Management**: Browse, search, and filter courses
- **Course Enrollment**: Enroll in courses using wallet credits
- **Course Content**: View course materials, videos, PDFs, and documents
- **Course Index**: Hierarchical course content structure with chapters and topics
- **Index Merging**: Teachers can merge course indexes from different sources
- **Reviews & Ratings**: View and write course reviews
- **Multi-language Support**: English and Gujarati translations included
- **Dependency Injection**: Clean architecture with provider interfaces
- **GetX Integration**: Built with GetX for state management and routing

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  kipi_elearning:
    git:
      url: https://github.com/EdzymeTech/kipi_elearning.git
      ref: main
```

## Usage

### 1. Initialize the Package

Before using the package, you must initialize it with required providers:

```dart
import 'package:kipi_elearning/kipi_elearning.dart';

void main() async {
  // Implement the required providers
  final courseRepository = MyCourseRepository();
  final userProvider = MyUserProvider();
  final indexProvider = MyIndexProvider();
  final entityProvider = MyEntityProvider();
  final subscriptionProvider = MySubscriptionProvider();
  final walletProvider = MyWalletProvider();
  final navigationProvider = MyNavigationProvider();

  // Initialize the package
  KipiElearning.initialize(
    courseRepository: courseRepository,
    userProvider: userProvider,
    indexProvider: indexProvider,
    entityProvider: entityProvider,
    subscriptionProvider: subscriptionProvider,
    walletProvider: walletProvider,
    navigationProvider: navigationProvider,
    theme: MyElearningTheme(),
    translator: myTranslator,
    onSuccessMessage: (message) => showSuccess(message),
    onErrorMessage: (message) => showError(message),
  );

  runApp(MyApp());
}
```

### 2. Implement Required Providers

You need to implement the following provider interfaces:

#### CourseRepository
```dart
class MyCourseRepository implements CourseRepository {
  @override
  Future<List<AllCoursesRecordList>> getAllCourses({
    required Map<String, dynamic> query,
  }) {
    // Implement your API call here
  }

  @override
  Future<List<UserHasCourseData>> getUserHasCourse({
    required Map<String, dynamic> query,
  }) {
    // Implement your API call here
  }

  // ... implement other methods
}
```

#### UserProvider
```dart
class MyUserProvider implements UserProvider {
  @override
  String get userId => AppSession().userId;

  @override
  String get userUuid => AppSession().userUuid;

  @override
  String get userType => AppSession().userType;

  // ... implement other properties
}
```

#### Other Providers
Similarly implement:
- `IndexProvider` - For course index/chapter operations
- `EntityProvider` - For entity hierarchy data
- `SubscriptionProvider` - For subscription information
- `WalletProvider` - For wallet integration
- `NavigationProvider` - For navigation functionality

### 3. Add Package Routes

Add the package routes to your GetX routing:

```dart
import 'package:kipi_elearning/kipi_elearning.dart';

void main() {
  GetPages pages = [
    // Your app routes
    ...ElearningPages.getPages(),
  ];

  runApp(GetApp(
    getPages: pages,
  ));
}
```

### 4. Navigate to Package Screens

```dart
// Navigate to explore courses
Get.toNamed(ElearningRoutes.exploreCourseScreen);

// Navigate to my courses
Get.toNamed(ElearningRoutes.myCoursesScreen);

// Navigate to course details
Get.toNamed(
  ElearningRoutes.courseDetailsScreen,
  arguments: {'course': course.toJson()},
);
```

## Package Structure

```
kipi_elearning/
├── lib/
│   ├── kipi_elearning.dart          # Main entry point
│   └── src/
│       ├── config/                 # Configuration files
│       │   ├── elearning_config.dart
│       │   ├── elearning_theme.dart
│       │   ├── elearning_assets.dart
│       │   └── elearning_enums.dart
│       ├── controllers/            # GetX controllers
│       ├── managers/               # Singleton managers
│       ├── models/                 # Data models
│       ├── providers/              # Provider interfaces
│       ├── routes/                 # Route definitions
│       ├── screens/                # UI screens
│       ├── widgets/                # Reusable widgets
│       └── utils/                  # Utilities
│           └── translations/        # Localization
├── assets/                         # Package assets
└── example/                        # Example app
```

## Provider Interfaces

### CourseRepository
Handles all course-related API calls:
- `getAllCourses()` - Fetch all courses with pagination
- `getUserHasCourse()` - Fetch user enrolled courses
- `getCourseById()` - Fetch course details
- `enrollCourse()` - Enroll user in a course
- `getCourseIndex()` - Fetch course index/chapter data

### UserProvider
Provides user information:
- `userId` - Current user ID
- `userUuid` - Current user UUID
- `userType` - User type (student, teacher, parent, etc.)
- `appType` - App type (school, institute, etc.)
- `interestedEntities` - User's interested entities
- `isAuthenticated` - Authentication status

### IndexProvider
Handles course index/chapter operations:
- `getIndexBySubjectId()` - Fetch index by subject
- `createIndex()` - Create new index
- `updateIndex()` - Update existing index
- `assignChapterToUsers()` - Assign chapters to users
- `mergeCourseIndex()` - Merge course indexes

### EntityProvider
Provides entity hierarchy data:
- `getAllEntities()` - Fetch all entities
- `getEntityFromSubjectId()` - Get entity from subject ID
- `getParentsFromChild()` - Get parent entities
- `getAcademicDataById()` - Get academic data

### SubscriptionProvider
Handles subscription information:
- `getInstPlan()` - Get institute subscription plans
- `hasActiveSubscription()` - Check active subscription
- `getSubscriptionExpiry()` - Get expiry date
- `isCourseIncludedInSubscription()` - Check course inclusion

### WalletProvider
Handles wallet integration:
- `enrollCourseWithWallet()` - Enroll using wallet credits
- `getWalletBalance()` - Get wallet balance
- `hasSufficientBalance()` - Check balance sufficiency
- `navigateToWallet()` - Navigate to wallet screen
- `createWalletTransaction()` - Create wallet transaction

### NavigationProvider
Handles navigation:
- `pushNamed()` - Push named route
- `newPushNamed()` - Push route and clear history
- `pop()` - Pop current route
- `popUntil()` - Pop until specific route
- `getCurrentRoute()` - Get current route name

## Screens

- **UnifiedCourseScreen** - Unified course listing (explore/my courses)
- **CourseDetailsScreen** - Course details with enrollment
- **CourseCheckoutScreen** - Course checkout with wallet payment
- **CourseIndexDetailsScreen** - Course content viewer with tabs
- **MergeCourseIndexScreen** - Teacher index merging interface
- **RatingReviewScreen** - Course reviews list
- **WriteReviewScreen** - Write course review

## Widgets

- **CourseDetailCard** - Reusable course card widget
- **CourseIndexTreeView** - Recursive tree view for course index
- **CourseDetailShimmer** - Shimmer loading effect
- **ExploreCoursesWidget** - Dashboard course widget
- **CartButtonWidget** - Cart button with badge

## Localization

The package includes translations for:
- English (en_IN)
- Gujarati (gu_IN)

To add custom translations, provide a translator callback during initialization:

```dart
KipiElearning.initialize(
  // ... other parameters
  translator: (key) {
    // Your custom translation logic
    return myTranslations[key] ?? key;
  },
);
```

## Theme Customization

Customize the package theme by providing an `ElearningTheme` instance:

```dart
KipiElearning.initialize(
  // ... other parameters
  theme: ElearningTheme(
    primaryColor: Colors.blue,
    secondaryColor: Colors.orange,
    backgroundColor: Colors.white,
    // ... other theme properties
  ),
);
```

## Example App

See the `example/` directory for a complete example implementation.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This package is licensed under the MIT License.

## Support

For issues and questions, please open an issue on GitHub.
