import 'package:flutter/material.dart';
import '../models/lms_data.dart';
import '../theme/app_theme.dart';
import 'live_meeting_screen.dart';

class TeacherPortalScreen extends StatefulWidget {
  const TeacherPortalScreen({Key? key}) : super(key: key);

  @override
  State<TeacherPortalScreen> createState() => _TeacherPortalScreenState();
}

class _TeacherPortalScreenState extends State<TeacherPortalScreen> {
  @override
  Widget build(BuildContext context) {
    final students = LmsDataMock.sampleStudents;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('INSTRUCTOR VIEW', style: TextStyle(color: AppTheme.accentColor, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  SizedBox(height: 4),
                  Text('Dr. Elena Vasquez', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Dept. of Mathematics & Computer Science', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LiveMeetingScreen(isTeacher: true)),
                  );
                },
                icon: const Icon(Icons.videocam, size: 16),
                label: const Text('Start Live'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats
          Row(
            children: [
              Expanded(child: _buildTeacherStat('Enrolled', '119')),
              const SizedBox(width: 8),
              Expanded(child: _buildTeacherStat('Avg. Grade', '84.2%')),
              const SizedBox(width: 8),
              Expanded(child: _buildTeacherStat('At Risk', '2', isAlert: true)),
            ],
          ),
          const SizedBox(height: 20),

          // Students Roster
          const Text('Student Performance & Attendance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: students.length,
            itemBuilder: (context, i) {
              final s = students[i];
              final isAtRisk = s.status == 'at-risk';
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                    child: Text(s.name[0], style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(s.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text('${s.email} · Attendance: ${s.attendance}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAtRisk ? AppTheme.alertRed.withOpacity(0.15) : AppTheme.accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${s.grade} (${s.score}%)',
                      style: TextStyle(
                        color: isAtRisk ? AppTheme.alertRed : AppTheme.accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherStat(String label, String value, {bool isAlert = false}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(label.toUpperCase(), style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: isAlert ? AppTheme.alertRed : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
