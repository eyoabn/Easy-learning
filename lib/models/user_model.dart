import 'user_role.dart';

enum AccountStatus {
  pendingAdmin,
  approved,
  rejected,
}

enum EnrollmentStatus {
  none,
  pendingTeacher,
  accepted,
  rejected,
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String department;
  AccountStatus accountStatus;
  final String registeredAt;
  final List<String> enrolledCourseIds;
  final Map<String, EnrollmentStatus> courseEnrollmentStatus; // courseId -> EnrollmentStatus

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    this.accountStatus = AccountStatus.pendingAdmin,
    required this.registeredAt,
    List<String>? enrolledCourseIds,
    Map<String, EnrollmentStatus>? courseEnrollmentStatus,
  })  : enrolledCourseIds = enrolledCourseIds ?? [],
        courseEnrollmentStatus = courseEnrollmentStatus ?? {};
}
