import 'package:flutter/material.dart';
import '../../models/lms_data.dart';
import '../../models/user_model.dart';
import '../../theme/app_theme.dart';
import 'live_meeting_screen.dart';

class TeacherPortalScreen extends StatefulWidget {
  const TeacherPortalScreen({Key? key}) : super(key: key);

  @override
  State<TeacherPortalScreen> createState() => _TeacherPortalScreenState();
}

class _TeacherPortalScreenState extends State<TeacherPortalScreen> {
  int _activeTab = 0;

  void _acceptStudent(StudentEnrollmentRequest req) {
    setState(() {
      req.status = EnrollmentStatus.accepted;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accepted ${req.studentName} into ${req.courseTitle}'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  void _rejectStudent(StudentEnrollmentRequest req) {
    setState(() {
      req.status = EnrollmentStatus.rejected;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rejected enrollment request for ${req.studentName}'),
        backgroundColor: AppTheme.alertRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingStudents = LmsDataMock.studentEnrollments
        .where((req) => req.status == EnrollmentStatus.pendingTeacher)
        .toList();
    final activeStudents = LmsDataMock.sampleStudents;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner (Expanded to prevent overflow)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('INSTRUCTOR CONTROL CENTER', style: TextStyle(color: AppTheme.accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                    SizedBox(height: 4),
                    Text('Dr. Elena Vasquez', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                    Text('Dept. of Math & Computer Science', style: TextStyle(color: AppTheme.textMuted, fontSize: 12), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LiveMeetingScreen(isTeacher: true)),
                  );
                },
                icon: const Icon(Icons.videocam, size: 14),
                label: const Text('Start Live', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Scrollable Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTabChip(0, 'Enrolled Roster (${activeStudents.length})'),
                const SizedBox(width: 8),
                _buildTabChip(1, 'Course Applications (${pendingStudents.length})'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (_activeTab == 0) _buildRosterSection(activeStudents),
          if (_activeTab == 1) _buildEnrollmentRequestsSection(pendingStudents),
        ],
      ),
    );
  }

  Widget _buildTabChip(int index, String label) {
    final isSelected = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.darkSurfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.darkBorderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textMuted,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRosterSection(List<StudentItem> students) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Active Class Roster & Grades', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: students.length,
          itemBuilder: (context, i) {
            final s = students[i];
            final isAtRisk = s.status == 'at-risk';
            return Card(
              color: AppTheme.darkCardColor,
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                      child: Text(s.name[0], style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white), overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text('${s.email} · Attendance: ${s.attendance}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 11), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAtRisk ? AppTheme.alertRed.withValues(alpha: 0.15) : AppTheme.accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${s.grade} (${s.score}%)',
                        style: TextStyle(
                          color: isAtRisk ? AppTheme.alertRed : AppTheme.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEnrollmentRequestsSection(List<StudentEnrollmentRequest> pendingRequests) {
    return Card(
      color: AppTheme.darkCardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Student Course Applications',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${pendingRequests.length} Action Needed',
                    style: const TextStyle(color: AppTheme.warningColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'As Teacher, accept student applications so they can access your lessons & LiveKit classes.',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 16),

            if (pendingRequests.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Text(
                    'No pending student course enrollment requests.',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pendingRequests.length,
                separatorBuilder: (_, __) => const Divider(color: AppTheme.darkBorderColor),
                itemBuilder: (context, i) {
                  final req = pendingRequests[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                              child: Text(req.studentName[0], style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(req.studentName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white), overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 2),
                                  Text('${req.studentEmail} · ${req.courseTitle}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 11), overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _acceptStudent(req),
                              icon: const Icon(Icons.check, size: 14),
                              label: const Text('Accept', style: TextStyle(fontSize: 11)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentColor,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(60, 32),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () => _rejectStudent(req),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.alertRed,
                                side: const BorderSide(color: AppTheme.alertRed),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                minimumSize: const Size(60, 32),
                              ),
                              child: const Text('Decline', style: TextStyle(fontSize: 11)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
