class CourseItem {
  final String id;
  final String title;
  final String tag;
  final String instructor;
  final int progress;
  final String nextLesson;
  final String nextDate;
  final String colorHex;

  CourseItem({
    required this.id,
    required this.title,
    required this.tag,
    required this.instructor,
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
  static List<CourseItem> sampleCourses = [
    CourseItem(
      id: '1',
      title: 'Advanced Mathematics',
      tag: 'MATH 401',
      instructor: 'Dr. Elena Vasquez',
      progress: 72,
      nextLesson: 'Differential Equations — Part 3',
      nextDate: 'Today, 2:00 PM',
      colorHex: '#4C7EFF',
    ),
    CourseItem(
      id: '2',
      title: 'Molecular Biology',
      tag: 'BIO 310',
      instructor: 'Prof. James Okonkwo',
      progress: 55,
      nextLesson: 'CRISPR Gene Editing Techniques',
      nextDate: 'Tomorrow, 10:00 AM',
      colorHex: '#00D9A3',
    ),
    CourseItem(
      id: '3',
      title: 'Contemporary Literature',
      tag: 'LIT 220',
      instructor: 'Dr. Sarah Kimani',
      progress: 88,
      nextLesson: 'Post-Colonial Narratives',
      nextDate: 'Wed, 9:00 AM',
      colorHex: '#A78BFA',
    ),
    CourseItem(
      id: '4',
      title: 'Data Structures & Algorithms',
      tag: 'CS 301',
      instructor: 'Dr. Min-Jun Lee',
      progress: 41,
      nextLesson: 'Graph Traversal Algorithms',
      nextDate: 'Thu, 3:00 PM',
      colorHex: '#FB923C',
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
    AssignmentItem(
      id: '3',
      title: 'Essay: Post-Colonial Analysis',
      course: 'LIT 220',
      due: 'Jul 28',
      urgent: false,
      type: 'Essay',
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
    StudentItem(
      id: '4',
      name: 'Mei-Ling Chen',
      email: 'm.chen@uni.edu',
      grade: 'A+',
      score: 99,
      attendance: '100%',
      status: 'active',
    ),
  ];

  static List<AuditLogItem> sampleAuditLogs = [
    AuditLogItem(
      id: 'LOG-8841',
      timestamp: '2026-07-24 14:10',
      actor: 'Admin (Amara D.)',
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
    AuditLogItem(
      id: 'LOG-8839',
      timestamp: '2026-07-24 12:40',
      actor: 'Admin (Amara D.)',
      action: 'S3_QUOTA_RESIZED',
      target: 'Engineering Bucket -> 5TB',
      ip: '192.168.1.45',
    ),
  ];
}
