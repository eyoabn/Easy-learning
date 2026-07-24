import 'user_model.dart';
import 'user_role.dart';

class StudentItem {
  final String id;
  final String name;
  final String email;
  final String grade;
  final int score;
  final String attendance;
  final String status;

  StudentItem({
    required this.id,
    required this.name,
    required this.email,
    required this.grade,
    required this.score,
    required this.attendance,
    required this.status,
  });
}

class CourseItem {
  final String id;
  final String title;
  final String tag;
  final String instructor;
  final String instructorId;
  final int progress;
  final String nextLesson;
  final String nextDate;
  final String colorHex;

  CourseItem({
    required this.id,
    required this.title,
    required this.tag,
    required this.instructor,
    required this.instructorId,
    required this.progress,
    required this.nextLesson,
    required this.nextDate,
    required this.colorHex,
  });
}

class AssignmentItem {
  final String id;
  final String title;
  final String course;
  final String due;
  final bool urgent;
  final String type;

  AssignmentItem({
    required this.id,
    required this.title,
    required this.course,
    required this.due,
    required this.urgent,
    required this.type,
  });
}

class StudentEnrollmentRequest {
  final String id;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String courseId;
  final String courseTitle;
  EnrollmentStatus status;

  StudentEnrollmentRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.courseId,
    required this.courseTitle,
    this.status = EnrollmentStatus.pendingTeacher,
  });
}

class AuditLogItem {
  final String id;
  final String timestamp;
  final String actor;
  final String action;
  final String target;
  final String ip;

  AuditLogItem({
    required this.id,
    required this.timestamp,
    required this.actor,
    required this.action,
    required this.target,
    required this.ip,
  });
}

class LmsDataMock {
  static List<UserModel> pendingRegistrations = [
    UserModel(
      id: 'REG-101',
      name: 'Dr. Julian Thorne',
      email: 'j.thorne@mit.edu',
      role: UserRole.teacher,
      department: 'Computer Science',
      accountStatus: AccountStatus.pendingAdmin,
      registeredAt: 'Today 14:20',
    ),
    UserModel(
      id: 'REG-102',
      name: 'Dr. Amrita Roy',
      email: 'a.roy@oxford.edu',
      role: UserRole.teacher,
      department: 'Bio-Physics',
      accountStatus: AccountStatus.pendingAdmin,
      registeredAt: 'Today 12:15',
    ),
  ];

  static List<StudentEnrollmentRequest> studentEnrollments = [
    StudentEnrollmentRequest(
      id: 'ENR-401',
      studentId: 'STD-301',
      studentName: 'Kwame Asante',
      studentEmail: 'k.asante@student.edu',
      courseId: '1',
      courseTitle: 'MATH 401 — Advanced Mathematics',
      status: EnrollmentStatus.pendingTeacher,
    ),
    StudentEnrollmentRequest(
      id: 'ENR-402',
      studentId: 'STD-302',
      studentName: 'Sofia Reyes',
      studentEmail: 's.reyes@student.edu',
      courseId: '1',
      courseTitle: 'MATH 401 — Advanced Mathematics',
      status: EnrollmentStatus.pendingTeacher,
    ),
    StudentEnrollmentRequest(
      id: 'ENR-403',
      studentId: 'STD-201',
      studentName: 'Amara Diallo',
      studentEmail: 'a.diallo@student.edu',
      courseId: '1',
      courseTitle: 'MATH 401 — Advanced Mathematics',
      status: EnrollmentStatus.accepted,
    ),
  ];

  static List<StudentItem> sampleStudents = [
    StudentItem(
      id: '1',
      name: 'Amara Diallo',
      email: 'a.diallo@uni.edu',
      grade: 'A-',
      score: 91,
      attendance: '97%',
      status: 'active',
    ),
    StudentItem(
      id: '2',
      name: 'Luca Ferretti',
      email: 'l.ferretti@uni.edu',
      grade: 'B+',
      score: 87,
      attendance: '92%',
      status: 'active',
    ),
    StudentItem(
      id: '3',
      name: 'Kwame Asante',
      email: 'k.asante@uni.edu',
      grade: 'C+',
      score: 74,
      attendance: '78%',
      status: 'at-risk',
    ),
  ];

  static List<CourseItem> sampleCourses = [
    CourseItem(
      id: '1',
      title: 'Advanced Mathematics',
      tag: 'MATH 401',
      instructor: 'Dr. Elena Vasquez',
      instructorId: 'TCH-101',
      progress: 72,
      nextLesson: 'Differential Equations — Part 3',
      nextDate: 'Today, 2:00 PM',
      colorHex: '#6366F1',
    ),
    CourseItem(
      id: '2',
      title: 'Molecular Biology',
      tag: 'BIO 310',
      instructor: 'Prof. James Okonkwo',
      instructorId: 'TCH-102',
      progress: 55,
      nextLesson: 'CRISPR Gene Editing Techniques',
      nextDate: 'Tomorrow, 10:00 AM',
      colorHex: '#10B981',
    ),
    CourseItem(
      id: '3',
      title: 'Contemporary Literature',
      tag: 'LIT 220',
      instructor: 'Dr. Sarah Kimani',
      instructorId: 'TCH-103',
      progress: 88,
      nextLesson: 'Post-Colonial Narratives',
      nextDate: 'Wed, 9:00 AM',
      colorHex: '#8B5CF6',
    ),
  ];

  static List<AssignmentItem> sampleAssignments = [
    AssignmentItem(
      id: '1',
      title: 'Problem Set 7 — Integration',
      course: 'MATH 401',
      due: 'Tonight 11:59 PM',
      urgent: true,
      type: 'Assignment',
    ),
    AssignmentItem(
      id: '2',
      title: 'Lab Report: DNA Extraction',
      course: 'BIO 310',
      due: 'Jul 26',
      urgent: false,
      type: 'Lab Report',
    ),
  ];

  static List<AuditLogItem> sampleAuditLogs = [
    AuditLogItem(
      id: 'LOG-8841',
      timestamp: '2026-07-24 14:10',
      actor: 'Admin (System Admin)',
      action: 'USER_ROLE_UPDATE',
      target: 'Dr. Vasquez -> Lead Instructor',
      ip: '192.168.1.45',
    ),
    AuditLogItem(
      id: 'LOG-8840',
      timestamp: '2026-07-24 13:58',
      actor: 'System (LiveKit)',
      action: 'ROOM_EGRESS_RECORDED',
      target: 'MATH 401 Session #44',
      ip: '10.0.4.12',
    ),
  ];
}
