class Course {
  final String id;
  final String name;
  final String teacher;
  final int gradientIndex;
  final int unread;
  final int progress;
  final int? students;
  final int? pending;
  final int? avgGrade;

  Course({
    required this.id,
    required this.name,
    required this.teacher,
    required this.gradientIndex,
    required this.unread,
    required this.progress,
    this.students,
    this.pending,
    this.avgGrade,
  });
}

class Announcement {
  final String id;
  final String author;
  final String title;
  final String content;
  final String timestamp;
  final String category;
  final bool pinned;
  final String date;

  Announcement({
    required this.id,
    required this.author,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.category,
    required this.pinned,
    required this.date,
  });
}

class CourseRequest {
  final String id;
  final String title;
  final String description;
  final String teacherId;
  final String teacherName;
  final int studentCount;
  final DateTime createdAt;

  CourseRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.teacherId,
    required this.teacherName,
    required this.studentCount,
    required this.createdAt,
  });
}

// ── Mock Data ─────────────────────────────────────────────────────────────────

final List<Course> mockStudentCourses = [
  Course(id: 'c1', name: 'Intro to Computer Science', teacher: 'Dr. Vasquez', gradientIndex: 0, unread: 2, progress: 45),
  Course(id: 'c2', name: 'Calculus I', teacher: 'Prof. Davis', gradientIndex: 1, unread: 0, progress: 78),
  Course(id: 'c3', name: 'Physics 101', teacher: 'Dr. Vasquez', gradientIndex: 2, unread: 1, progress: 20),
];

final List<Course> mockTeacherCourses = [
  Course(id: 'c1', name: 'Intro to Computer Science', teacher: 'Dr. Vasquez', gradientIndex: 0, unread: 0, progress: 0, students: 120, pending: 15, avgGrade: 85),
  Course(id: 'c3', name: 'Physics 101', teacher: 'Dr. Vasquez', gradientIndex: 2, unread: 0, progress: 0, students: 45, pending: 0, avgGrade: 78),
];

final List<CourseRequest> mockCourseRequests = [
  CourseRequest(
    id: 'req1',
    title: 'Advanced Machine Learning',
    description: 'A comprehensive dive into neural networks and deep learning.',
    teacherId: 't1',
    teacherName: 'Dr. Vasquez',
    studentCount: 30,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  ),
];

final List<Announcement> mockAnnouncements = [
  Announcement(
    id: 'a1',
    author: 'System Admin',
    title: 'Platform Maintenance Scheduled',
    content: 'LearnSpace will be down for scheduled maintenance this Sunday from 2 AM to 4 AM EST. Please ensure all assignments are submitted prior.',
    timestamp: '2026-07-24T08:00:00Z',
    category: 'general',
    pinned: true,
    date: 'Today',
  ),
  Announcement(
    id: 'a2',
    author: 'Dr. Vasquez',
    title: 'Midterm Grades Posted',
    content: 'The grades for your CS101 midterm have been finalized and are available in the portal. The class average was exceptionally high this term.',
    timestamp: '2026-07-23T14:30:00Z',
    category: 'grade',
    pinned: false,
    date: 'Yesterday',
  ),
  Announcement(
    id: 'a3',
    author: 'Prof. Davis',
    title: 'New Integration Assignment',
    content: 'A new assignment covering advanced integration techniques is now available under the Calculus module. It is due next Friday.',
    timestamp: '2026-07-22T09:15:00Z',
    category: 'assignment',
    pinned: false,
    date: 'Jul 22',
  ),
];
