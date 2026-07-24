enum UserRole {
  admin,
  teacher,
  student,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'System Admin';
      case UserRole.teacher:
        return 'Teacher';
      case UserRole.student:
        return 'Student';
    }
  }

  String get initials {
    switch (this) {
      case UserRole.admin:
        return 'AD';
      case UserRole.teacher:
        return 'EV';
      case UserRole.student:
        return 'AD';
    }
  }
}
