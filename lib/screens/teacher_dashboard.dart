import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/dashboard_models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'placeholder_screens.dart';

class TeacherDashboard extends StatefulWidget {
  final UserModel user;
  const TeacherDashboard({Key? key, required this.user}) : super(key: key);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  final List<Course> _courses = mockTeacherCourses;
  final List<Announcement> _announcements = mockAnnouncements.where((a) => a.author.contains('Vasquez') || a.author.contains('Davis')).toList();
  bool _loading = false;

  Future<void> _refresh() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.user.name.split(' ').first;
    final totalStudents  = _courses.fold(0, (s, c) => s + (c.students ?? 0));
    final totalPending   = _courses.fold(0, (s, c) => s + (c.pending ?? 0));
    final avgGrade       = _courses.isEmpty ? 0 : (_courses.fold(0, (s, c) => s + (c.avgGrade ?? 0)) / _courses.length).round();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColors.violet,
        child: CustomScrollView(slivers: [
          // ── Header ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: GradientHeader(
              gradient: AppGradients.primary,
              child: SafeArea(bottom: false, child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Welcome, $name 👨‍🏫',
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Teaching Dashboard',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                    ])),
                    _NotifBell(count: totalPending),
                  ]),
                  const SizedBox(height: 18),
                  // ── Stats row ──
                  Row(children: [
                    Expanded(child: _TeacherStatBox(icon: Icons.people_rounded, label: 'Students', value: '$totalStudents')),
                    const SizedBox(width: 10),
                    Expanded(child: _TeacherStatBox(icon: Icons.pending_actions_rounded, label: 'To Grade', value: '$totalPending')),
                    const SizedBox(width: 10),
                    Expanded(child: _TeacherStatBox(icon: Icons.trending_up_rounded, label: 'Avg Grade', value: '$avgGrade%')),
                  ]),
                ]),
              )),
            ),
          ),

          SliverPadding(padding: const EdgeInsets.all(16), sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ── Quick Actions ──────────────────────────────────────────
              const SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: 12),
              _TeacherQuickActions(onPostCreated: _refresh),
              const SizedBox(height: 24),

              // ── My Classes ──────────────────────────────────────────────
              SectionHeader(title: 'My Classes',
                trailing: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : null),
              const SizedBox(height: 12),
              if (_loading)
                const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
              else if (_courses.isEmpty)
                const EmptyState(icon: Icons.menu_book_rounded, title: 'No classes yet', subtitle: 'Your courses will appear here')
              else
                ..._courses.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TeacherCourseCard(course: c),
                )),
              const SizedBox(height: 24),

              // ── Posts You've Made ───────────────────────────────────────
              const SectionHeader(title: 'Posts You\'ve Made'),
              const SizedBox(height: 12),
              if (_announcements.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text('No posts yet. Create one to get started! 📝',
                      style: TextStyle(color: AppColors.textSecondary))),
                )
              else
                ..._announcements.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _AnnouncementCard(announcement: a),
                )),
            ]),
          )),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED SUBWIDGETS FOR TEACHER DASHBOARD
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

class _TeacherQuickActions extends StatelessWidget {
  final Future<void> Function()? onPostCreated;
  const _TeacherQuickActions({this.onPostCreated});

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
        onTap: () {
          // Placeholder action
        },
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

class _AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  const _AnnouncementCard({required this.announcement});

  Color get _categoryColor {
    switch (announcement.category) {
      case 'assignment': return AppColors.emerald;
      case 'grade': return AppColors.orange;
      case 'resource': return AppColors.violet;
      default: return AppColors.blue;
    }
  }

  String get _categoryLabel {
    switch (announcement.category) {
      case 'assignment': return 'Assignment';
      case 'grade': return 'Grade';
      case 'resource': return 'Resource';
      default: return 'General';
    }
  }

  @override
  Widget build(BuildContext context) => GlassCard(
    padding: const EdgeInsets.all(14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (announcement.pinned) ...[
        Row(children: [
          Icon(Icons.push_pin_rounded, size: 14, color: AppColors.orange),
          const SizedBox(width: 4),
          const Text('Pinned', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.orange)),
        ]),
        const SizedBox(height: 6),
      ],
      Text(announcement.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
      const SizedBox(height: 4),
      Text(announcement.content,
        maxLines: 2, overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: Text('${announcement.author} • ${announcement.date}', style: TextStyle(fontSize: 10, color: Colors.grey.shade600))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: _categoryColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Text(_categoryLabel, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: _categoryColor)),
        ),
      ]),
    ]),
  );
}
