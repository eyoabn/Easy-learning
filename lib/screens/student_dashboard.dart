import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/dashboard_models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'placeholder_screens.dart';

class StudentDashboard extends StatefulWidget {
  final UserModel user;
  const StudentDashboard({Key? key, required this.user}) : super(key: key);

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final List<Course> _courses = mockStudentCourses;
  final List<Announcement> _announcements = mockAnnouncements;
  bool _loading = false;

  Future<void> _refresh() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';

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
                      Text('$greeting, ${widget.user.name.split(' ').first} 👋',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Ready to learn today?',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                    ])),
                    _NotifBell(count: _courses.fold(0, (s, c) => s + c.unread)),
                  ]),
                  const SizedBox(height: 18),
                  // ── Progress summary ──
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.25))),
                    child: Row(children: [
                      Expanded(child: _MiniStat(label: 'Courses', value: '${_courses.length}')),
                      _Divider(),
                      Expanded(child: _MiniStat(label: 'Avg Progress',
                          value: _courses.isEmpty ? '0%'
                              : '${(_courses.fold(0, (s, c) => s + c.progress) / _courses.length).round()}%')),
                      _Divider(),
                      Expanded(child: _MiniStat(label: 'Announcements',
                          value: '${_announcements.length}')),
                    ]),
                  ),
                ]),
              )),
            ),
          ),

          SliverPadding(padding: const EdgeInsets.all(16), sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ── Quick Actions ──────────────────────────────────────────
              const SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: 12),
              const _StudentQuickActions(),
              const SizedBox(height: 24),

              // ── Recent Announcements ───────────────────────────────
              SectionHeader(
                title: 'Recent Announcements',
                trailing: TextButton(
                  onPressed: () {},
                  child: const Text('See all', style: TextStyle(color: AppColors.violet, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              if (_announcements.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text('No announcements yet 📢',
                      style: TextStyle(color: AppColors.textSecondary))),
                )
              else
                ..._announcements.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _AnnouncementCard(announcement: a),
                )),
              const SizedBox(height: 24),

              // ── My Courses ─────────────────────────────────────────────
              SectionHeader(title: 'My Courses',
                trailing: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : null),
              const SizedBox(height: 12),
              if (_loading)
                const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
              else if (_courses.isEmpty)
                const EmptyState(icon: Icons.menu_book_rounded, title: 'No courses yet', subtitle: 'Courses you enrol in will appear here')
              else
                ..._courses.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _StudentCourseCard(course: c),
                )),
              const SizedBox(height: 24),
            ]),
          )),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED SUBWIDGETS FOR STUDENT DASHBOARD
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
