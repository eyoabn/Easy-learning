import 'package:flutter/material.dart';
import '../../models/lms_data.dart';
import '../../models/user_model.dart';
import '../../theme/app_theme.dart';
import 'live_meeting_screen.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  void _requestEnrollment(CourseItem course) {
    setState(() {
      LmsDataMock.studentEnrollments.add(
        StudentEnrollmentRequest(
          id: 'ENR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          studentId: 'STD-201',
          studentName: 'Amara Diallo',
          studentEmail: 'a.diallo@student.edu',
          courseId: course.id,
          courseTitle: '${course.tag} — ${course.title}',
          status: EnrollmentStatus.pendingTeacher,
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Course enrollment application sent to ${course.instructor} for ${course.tag}.'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courses = LmsDataMock.sampleCourses;
    final assignments = LmsDataMock.sampleAssignments;
    final myRequests = LmsDataMock.studentEnrollments
        .where((req) => req.studentEmail == 'a.diallo@student.edu')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner
          const Text(
            'STUDENT ACADEMIC PORTAL',
            style: TextStyle(
              color: AppTheme.accentColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Good afternoon, Amara',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Department of Computer Science · 1 Urgent Assignment Due',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // GPA & Course Overview Row
          Row(
            children: [
              Expanded(child: _buildMetricCard('GPA', '3.72', 'Current Semester')),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard('Attendance', '96%', 'All Courses')),
            ],
          ),
          const SizedBox(height: 24),

          // Course Catalog & Enrollment Status
          const Text('My Courses & Applications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: courses.length,
            itemBuilder: (context, i) {
              final c = courses[i];
              final isLiveToday = c.nextDate.contains('Today');
              final request = myRequests.firstWhere(
                (req) => req.courseId == c.id,
                orElse: () => StudentEnrollmentRequest(
                  id: '',
                  studentId: '',
                  studentName: '',
                  studentEmail: '',
                  courseId: '',
                  courseTitle: '',
                  status: EnrollmentStatus.none,
                ),
              );

              final isAccepted = request.status == EnrollmentStatus.accepted || c.id == '1';
              final isPending = request.status == EnrollmentStatus.pendingTeacher;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(c.tag, style: const TextStyle(color: AppTheme.primaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          if (isAccepted && isLiveToday)
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LiveMeetingScreen(isTeacher: false)),
                                );
                              },
                              icon: const Icon(Icons.live_tv, size: 14),
                              label: const Text('Join Live', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentColor,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(60, 30),
                              ),
                            )
                          else if (isPending)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.warningColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('Pending Teacher Acceptance', style: TextStyle(color: AppTheme.warningColor, fontSize: 11, fontWeight: FontWeight.bold)),
                            )
                          else if (!isAccepted)
                            OutlinedButton(
                              onPressed: () => _requestEnrollment(c),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryColor,
                                side: const BorderSide(color: AppTheme.primaryColor),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                minimumSize: const Size(60, 30),
                              ),
                              child: const Text('Apply for Course', style: TextStyle(fontSize: 11)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(c.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Instructor: ${c.instructor}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                      const SizedBox(height: 12),

                      if (isAccepted) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Progress', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                            Text('${c.progress}%', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: c.progress / 100,
                            backgroundColor: AppTheme.darkSurfaceColor,
                            color: AppTheme.primaryColor,
                            minHeight: 6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Next Lesson: ${c.nextLesson}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Assignments
          const Text('Assignments & Homework', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: assignments.length,
            itemBuilder: (context, i) {
              final a = assignments[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    a.urgent ? Icons.assignment_late : Icons.assignment,
                    color: a.urgent ? AppTheme.alertRed : AppTheme.primaryColor,
                  ),
                  title: Text(a.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('${a.course} · ${a.due}', style: TextStyle(color: a.urgent ? AppTheme.alertRed : AppTheme.textMuted, fontSize: 11)),
                  trailing: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening submission portal for ${a.title}')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: const Size(60, 30),
                    ),
                    child: const Text('Submit', style: TextStyle(fontSize: 11)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, String sub) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: const TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
