import 'package:flutter/material.dart';
import '../models/user_role.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'placeholder_screens.dart';

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

class DashboardScreen extends StatefulWidget {
  final UserModel user;
  const DashboardScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Course> _courses = [
    Course(id: '1', name: 'Intro to Programming', teacher: 'Dr. Vasquez', gradientIndex: 0, unread: 2, progress: 45, students: 24, pending: 3, avgGrade: 85),
    Course(id: '2', name: 'Calculus I', teacher: 'Prof. Davis', gradientIndex: 1, unread: 0, progress: 78, students: 30, pending: 0, avgGrade: 72),
    Course(id: '3', name: 'Physics 101', teacher: 'Dr. Vasquez', gradientIndex: 2, unread: 1, progress: 20, students: 18, pending: 5, avgGrade: 88),
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.user.role == UserRole.teacher) {
      return _TeacherDashboard(user: widget.user, courses: _courses);
    }
    return _StudentDashboard(user: widget.user, courses: _courses);
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// STUDENT DASHBOARD
// ══════════════════════════════════════════════════════════════════════════════
class _StudentDashboard extends StatelessWidget {
  final UserModel user;
  final List<Course> courses;

  const _StudentDashboard({required this.user, required this.courses});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        // ── Header ──────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: GradientHeader(
            gradient: AppGradients.primary,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('$greeting, ${user.name} 👋',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Ready to learn today?',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                    ])),
                    _NotifBell(count: courses.fold(0, (s, c) => s + c.unread)),
                  ]),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                    ),
                    child: Row(children: [
                      Expanded(child: _MiniStat(label: 'Courses', value: '${courses.length}')),
                      _Divider(),
                      Expanded(child: _MiniStat(label: 'Avg Progress',
                          value: courses.isEmpty ? '0%' : '${(courses.fold(0, (s, c) => s + c.progress) / courses.length).round()}%')),
                    ]),
                  ),
                ]),
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ── Quick Actions ──────────────────────────────────────────
              const SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: 12),
              const _StudentQuickActions(),
              const SizedBox(height: 24),

              // ── My Courses ─────────────────────────────────────────────
              const SectionHeader(title: 'My Courses'),
              const SizedBox(height: 12),
              ...courses.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _StudentCourseCard(course: c),
              )),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// TEACHER DASHBOARD
// ══════════════════════════════════════════════════════════════════════════════
class _TeacherDashboard extends StatelessWidget {
  final UserModel user;
  final List<Course> courses;

  const _TeacherDashboard({required this.user, required this.courses});

  @override
  Widget build(BuildContext context) {
    final totalStudents  = courses.fold(0, (s, c) => s + (c.students ?? 0));
    final totalPending   = courses.fold(0, (s, c) => s + (c.pending ?? 0));
    final avgGrade       = courses.isEmpty ? 0 : (courses.fold(0, (s, c) => s + (c.avgGrade ?? 0)) / courses.length).round();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        // ── Header ──────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: GradientHeader(
            gradient: AppGradients.primary,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Welcome, ${user.name} 👨‍🏫',
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Teaching Dashboard',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                    ])),
                    _NotifBell(count: totalPending),
                  ]),
                  const SizedBox(height: 18),
                  Row(children: [
                    Expanded(child: _TeacherStatBox(icon: Icons.people_rounded, label: 'Students', value: '$totalStudents')),
                    const SizedBox(width: 10),
                    Expanded(child: _TeacherStatBox(icon: Icons.pending_actions_rounded, label: 'To Grade', value: '$totalPending')),
                    const SizedBox(width: 10),
                    Expanded(child: _TeacherStatBox(icon: Icons.trending_up_rounded, label: 'Avg Grade', value: '$avgGrade%')),
                  ]),
                ]),
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: 12),
              const _TeacherQuickActions(),
              const SizedBox(height: 24),

              const SectionHeader(title: 'My Classes'),
              const SizedBox(height: 12),
              ...courses.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _TeacherCourseCard(course: c),
              )),
              const SizedBox(height: 24),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED SUBWIDGETS
// ══════════════════════════════════════════════════════════════════════════════

class _NotifBell extends StatelessWidget {
  final int count;
  const _NotifBell({required this.count});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
    child: Stack(clipBehavior: Clip.none, children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3))),
        child: const Icon(Icons.notifications_rounded, color: Colors.white, size: 24),
      ),
      if (count > 0)
        Positioned(top: -4, right: -4,
          child: Container(
            width: 20, height: 20,
            decoration: const BoxDecoration(gradient: AppGradients.orange, shape: BoxShape.circle),
            child: Center(child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          )),
    ]),
  );
}

class _MiniStat extends StatelessWidget {
  final String label, value;
  const _MiniStat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    const SizedBox(height: 2),
    Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11)),
  ]);
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.25));
}

class _TeacherStatBox extends StatelessWidget {
  final IconData icon;
  final String label, value;
  const _TeacherStatBox({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withValues(alpha: 0.25))),
    child: Column(children: [
      Icon(icon, color: Colors.white, size: 22),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 2),
      Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10)),
    ]),
  );
}

class _StudentQuickActions extends StatelessWidget {
  const _StudentQuickActions();
  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': Icons.search_rounded,    'label': 'Search',      'gi': 0},
      {'icon': Icons.assignment_rounded,'label': 'Assignments',  'gi': 1},
      {'icon': Icons.chat_bubble_rounded,'label': 'Chat',        'gi': 2},
      {'icon': Icons.grade_rounded,     'label': 'My Grades',   'gi': 3},
    ];
    return Row(children: actions.map((a) {
      final gi = a['gi'] as int;
      return Expanded(child: GestureDetector(
        onTap: () {},
        child: GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Column(children: [
            GradientIconBox(gradient: AppGradients.courseGradients[gi], icon: a['icon'] as IconData, size: 46, iconSize: 21),
            const SizedBox(height: 8),
            Text(a['label'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary), textAlign: TextAlign.center),
          ]),
        ),
      ));
    }).toList());
  }
}

class _TeacherQuickActions extends StatelessWidget {
  const _TeacherQuickActions();
  @override
  Widget build(BuildContext context) {
    final actions = [
      {'icon': Icons.post_add_rounded, 'label': 'Create Post', 'gi': 3},
      {'icon': Icons.calendar_month_rounded, 'label': 'Schedule', 'gi': 0},
      {'icon': Icons.assignment_turned_in_rounded, 'label': 'Grade Work', 'gi': 1},
      {'icon': Icons.analytics_rounded, 'label': 'Analytics', 'gi': 2},
    ];
    return Row(children: actions.map((a) {
      final gi = a['gi'] as int;
      return Expanded(child: GestureDetector(
        onTap: () {},
        child: GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          child: Column(children: [
            GradientIconBox(gradient: AppGradients.courseGradients[gi], icon: a['icon'] as IconData, size: 46, iconSize: 21),
            const SizedBox(height: 8),
            Text(a['label'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary), textAlign: TextAlign.center),
          ]),
        ),
      ));
    }).toList());
  }
}

class _StudentCourseCard extends StatelessWidget {
  final Course course;
  const _StudentCourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final grad = AppGradients.courseGradients[course.gradientIndex % 4];
    return GlassCard(
      onTap: () {},
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        GradientIconBox(gradient: grad, icon: Icons.menu_book_rounded, size: 56, iconSize: 26),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
          const SizedBox(height: 3),
          Text(course.teacher, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Progress', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            Text('${course.progress}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: grad.colors.first)),
          ]),
          const SizedBox(height: 4),
          GradientProgressBar(progress: course.progress / 100, gradient: grad),
        ])),
        if (course.unread > 0) ...[
          const SizedBox(width: 10),
          GradientBadge(text: '${course.unread}', gradient: AppGradients.orange),
        ],
      ]),
    );
  }
}

class _TeacherCourseCard extends StatelessWidget {
  final Course course;
  const _TeacherCourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final grad = AppGradients.courseGradients[course.gradientIndex % 4];
    return GlassCard(
      onTap: () {},
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        GradientIconBox(gradient: grad, icon: Icons.menu_book_rounded, size: 58, iconSize: 28),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(course.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.people_rounded, size: 13, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text('${course.students ?? 0} students', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(width: 12),
            const Icon(Icons.trending_up_rounded, size: 13, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text('Avg: ${course.avgGrade ?? 0}%', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ]),
          if ((course.pending ?? 0) > 0) ...[
            const SizedBox(height: 6),
            InfoChip(label: '${course.pending} pending grades', color: AppColors.orange),
          ],
        ])),
        const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
      ]),
    );
  }
}
