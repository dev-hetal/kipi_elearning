/// Course status enum
enum CourseStatus {
  draft('Draft'),
  published('Published'),
  archived('Archived');

  const CourseStatus(this.label);
  final String label;
}

/// Course type enum
enum CourseType {
  free('Free'),
  paid('Paid'),
  subscription('Subscription');

  const CourseType(this.label);
  final String label;
}

/// Course index type enum
enum CourseIndexType {
  chapter('Chapter'),
  topic('Topic'),
  subtopic('Subtopic');

  const CourseIndexType(this.label);
  final String label;
}

/// File format enum
enum FileFormat {
  video('VIDEO'),
  pdf('PDF'),
  image('IMAGE'),
  document('DOCUMENT'),
  audio('AUDIO'),
  url('URL');

  const FileFormat(this.api);
  final String api;
}

/// Homework/Classwork type enum
enum HomeWorkClassWorkType {
  homework('HOME_WORK'),
  classwork('CLASS_WORK');

  const HomeWorkClassWorkType(this.api);
  final String api;
}

/// Course enrollment status enum
enum EnrollmentStatus {
  notEnrolled('Not Enrolled'),
  enrolled('Enrolled'),
  expired('Expired'),
  pending('Pending');

  const EnrollmentStatus(this.label);
  final String label;
}

/// Course access type enum
enum CourseAccessType {
  public('Public'),
  private('Private'),
  restricted('Restricted');

  const CourseAccessType(this.label);
  final String label;
}

/// Course mode enum for UnifiedCourseController
enum CourseMode {
  explore('Explore'),
  myCourses('My Courses'),
  dashboard('Dashboard');

  const CourseMode(this.label);
  final String label;
}
