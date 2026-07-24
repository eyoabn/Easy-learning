import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/dashboard_models.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

// ── Local admin-only data models ─────────────────────────────────────────────

class AdminUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool approved;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.approved,
  });

  String get initials => name
      .split(' ')
      .where((w) => w.isNotEmpty)
      .take(2)
      .map((w) => w[0].toUpperCase())
      .join();
}

class AdminCourse {
  final String id;
  final String name;
  String? teacherId;
  String? teacherName;
  final List<String> studentIds;
  final String? description;
  final int? maxStudents;

  AdminCourse({
    required this.id,
    required this.name,
    this.teacherId,
    this.teacherName,
    List<String>? studentIds,
    this.description,
    this.maxStudents,
  }) : studentIds = studentIds ?? [];
}

class AdminPost {
  final String id;
  final String title;
  final String content;
  final String authorName;
  final String type;
  final DateTime createdAt;
  final String courseName;

  AdminPost({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.type,
    required this.createdAt,
    required this.courseName,
  });
}

// ── Mock data ─────────────────────────────────────────────────────────────────

final _mockTeachers = [
  AdminUser(id: 't1', name: 'Dr. Sarah Johnson',  email: 'sarah.j@school.edu',   role: 'teacher', approved: true),
  AdminUser(id: 't2', name: 'Prof. Michael Chen', email: 'michael.c@school.edu', role: 'teacher', approved: false),
  AdminUser(id: 't3', name: 'Dr. Emily Parker',   email: 'emily.p@school.edu',   role: 'teacher', approved: true),
];

final _mockStudents = [
  AdminUser(id: 's1', name: 'Alice Johnson',  email: 'alice.j@school.edu',  role: 'student', approved: true),
  AdminUser(id: 's2', name: 'Bob Smith',      email: 'bob.s@school.edu',    role: 'student', approved: false),
  AdminUser(id: 's3', name: 'Carol White',    email: 'carol.w@school.edu',  role: 'student', approved: true),
  AdminUser(id: 's4', name: 'David Brown',    email: 'david.b@school.edu',  role: 'student', approved: true),
];

final _mockAdminCourses = [
  AdminCourse(id: 'c1', name: 'Mathematics 101',  teacherId: 't1', teacherName: 'Dr. Sarah Johnson',  studentIds: ['s1', 's2', 's3'], description: 'Core mathematics curriculum', maxStudents: 40),
  AdminCourse(id: 'c2', name: 'Physics Advanced',  teacherId: null, teacherName: null, studentIds: ['s2'], description: 'Advanced physics topics', maxStudents: 25),
  AdminCourse(id: 'c3', name: 'English Literature', teacherId: 't3', teacherName: 'Dr. Emily Parker', studentIds: [], description: 'Classic literature analysis', maxStudents: 30),
];

final _mockAdminPosts = [
  AdminPost(id: 'p1', title: 'Welcome to new semester', content: 'Classes start tomorrow at 8 AM sharp.', authorName: 'Dr. Sarah Johnson', type: 'announcement', createdAt: DateTime.now().subtract(const Duration(hours: 3)), courseName: 'General'),
  AdminPost(id: 'p2', title: 'Midterm schedule released', content: 'Please check the portal for your individual midterm schedule.', authorName: 'Prof. Michael Chen', type: 'announcement', createdAt: DateTime.now().subtract(const Duration(days: 1)), courseName: 'Physics Advanced'),
];

// ── AdminScreen ───────────────────────────────────────────────────────────────

class AdminScreen extends StatefulWidget {
  final UserModel? user;
  const AdminScreen({Key? key, this.user}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  List<AdminCourse> _courses  = [];
  List<AdminUser>   _teachers = [];
  List<AdminUser>   _students = [];
  List<AdminPost>   _posts    = [];
  List<CourseRequest> _requests = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 5, vsync: this);
    _tabCtrl.addListener(() { if (mounted) setState(() {}); });
    _load();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _courses  = List.from(_mockAdminCourses);
        _teachers = List.from(_mockTeachers);
        _students = List.from(_mockStudents);
        _posts    = List.from(_mockAdminPosts);
        _requests = List.from(mockCourseRequests);
        _loading  = false;
      });
    }
  }

  // ── User management ───────────────────────────────────────────────────────

  Future<void> _approveUser(AdminUser user) async {
    setState(() {
      final ti = _teachers.indexWhere((u) => u.id == user.id);
      if (ti >= 0) _teachers[ti] = AdminUser(id: user.id, name: user.name, email: user.email, role: user.role, approved: true);
      final si = _students.indexWhere((u) => u.id == user.id);
      if (si >= 0) _students[si] = AdminUser(id: user.id, name: user.name, email: user.email, role: user.role, approved: true);
    });
    _snack('${user.name} approved successfully ✓', Colors.green);
  }

  Future<void> _deleteUser(AdminUser user) async {
    final confirmed = await _confirmDialog(
      title: 'Remove Account',
      message: 'Are you sure you want to permanently remove ${user.name}?',
      confirmLabel: 'Remove',
      confirmColor: Colors.red,
    );
    if (confirmed != true) return;
    setState(() {
      _teachers.removeWhere((u) => u.id == user.id);
      _students.removeWhere((u) => u.id == user.id);
    });
    _snack('${user.name} removed', Colors.red);
  }

  // ── Course request approval ───────────────────────────────────────────────

  void _approveRequest(CourseRequest req) {
    // Create an AdminCourse from the request
    final newCourse = AdminCourse(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      name: req.title,
      teacherId: req.teacherId,
      teacherName: req.teacherName,
      studentIds: [],
      description: req.description,
      maxStudents: req.studentCount,
    );

    setState(() {
      _courses.add(newCourse);
      _requests.removeWhere((r) => r.id == req.id);
      mockCourseRequests.removeWhere((r) => r.id == req.id);
    });

    _snack('Course "${req.title}" approved and created ✓', Colors.green);
  }

  void _rejectRequest(CourseRequest req) {
    setState(() {
      _requests.removeWhere((r) => r.id == req.id);
      mockCourseRequests.removeWhere((r) => r.id == req.id);
    });
    _snack('Request "${req.title}" rejected', Colors.red);
  }

  // ── Course management ─────────────────────────────────────────────────────

  void _showAssignTeacher(AdminCourse course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AssignTeacherSheet(
        course: course,
        teachers: _teachers.where((t) => t.approved).toList(),
        onAssign: (teacher) {
          setState(() {
            course.teacherId   = teacher.id;
            course.teacherName = teacher.name;
          });
          _snack('${teacher.name} assigned to ${course.name}', Colors.green);
        },
      ),
    );
  }

  void _showCreateCourse() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final maxCtrl  = TextEditingController();
    AdminUser? selectedTeacher;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDS) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.violet.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.add_box_rounded, color: AppColors.violet, size: 22),
            ),
            const SizedBox(width: 12),
            const Text('Create Course', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
          content: SizedBox(
            width: 360,
            child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
              _TextField(controller: nameCtrl, label: 'Course Name', hint: 'e.g. Mathematics 101'),
              const SizedBox(height: 12),
              _TextField(controller: descCtrl, label: 'Description', hint: 'Brief course description', maxLines: 2),
              const SizedBox(height: 12),
              _TextField(controller: maxCtrl, label: 'Max Students', hint: 'e.g. 30', keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              DropdownButtonFormField<AdminUser>(
                decoration: InputDecoration(
                  labelText: 'Assign Teacher (Optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                value: selectedTeacher,
                items: [
                  const DropdownMenuItem<AdminUser>(value: null, child: Text('No Teacher')),
                  ..._teachers.where((t) => t.approved).map((t) => DropdownMenuItem(value: t, child: Text(t.name))),
                ],
                onChanged: (val) => setDS(() => selectedTeacher = val),
              ),
            ])),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.violet,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                final newCourse = AdminCourse(
                  id: 'c_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text.trim(),
                  description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
                  maxStudents: int.tryParse(maxCtrl.text),
                  teacherId:   selectedTeacher?.id,
                  teacherName: selectedTeacher?.name,
                );
                setState(() => _courses.add(newCourse));
                Navigator.pop(ctx);
                _snack('Course "${newCourse.name}" created ✓', Colors.green);
              },
              child: const Text('Create', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _snack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  Future<bool?> _confirmDialog({
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
  }) => showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message, style: const TextStyle(height: 1.5, color: AppColors.textSecondary)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel, style: TextStyle(color: confirmColor, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final pendingRequests = _requests.length;
    final pendingTeachers = _teachers.where((u) => !u.approved).length;
    final pendingStudents = _students.where((u) => !u.approved).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: _tabCtrl.index == 0
          ? FloatingActionButton.extended(
              onPressed: _showCreateCourse,
              backgroundColor: AppColors.violet,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('New Course', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
      body: SafeArea(
        child: Column(children: [
          // ── Header ──────────────────────────────────────────────────────
          GradientHeader(
            gradient: AppGradients.primary,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Admin Panel', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(
                      widget.user?.name.isNotEmpty == true ? 'Signed in as ${widget.user!.name}' : 'System Administrator',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                    ),
                  ])),
                  GestureDetector(
                    onTap: _load,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                if (!_loading)
                  // Overflow-safe stat row using Expanded inside Row
                  Row(children: [
                    Expanded(child: _AdminStat(label: 'Courses',  value: '${_courses.length}',  icon: Icons.menu_book_rounded)),
                    const SizedBox(width: 8),
                    Expanded(child: _AdminStat(label: 'Teachers', value: '${_teachers.length}', icon: Icons.school_rounded)),
                    const SizedBox(width: 8),
                    Expanded(child: _AdminStat(label: 'Students', value: '${_students.length}', icon: Icons.people_rounded)),
                    const SizedBox(width: 8),
                    Expanded(child: _AdminStat(
                      label: 'Requests',
                      value: '$pendingRequests',
                      icon: Icons.pending_actions_rounded,
                      highlight: pendingRequests > 0,
                    )),
                  ]),
              ]),
            ),
          ),

          // ── Tab Bar ──────────────────────────────────────────────────────
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabCtrl,
              labelColor: AppColors.violet,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              indicatorColor: AppColors.violet,
              indicatorWeight: 3,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(text: 'Courses (${_courses.length})'),
                _BadgeTab(text: 'Teachers', count: _teachers.length, pending: pendingTeachers),
                _BadgeTab(text: 'Students', count: _students.length, pending: pendingStudents),
                Tab(text: 'Posts (${_posts.length})'),
                _BadgeTab(text: 'Requests', count: _requests.length, pending: pendingRequests, badgeColor: AppColors.orange),
              ],
            ),
          ),

          // ── Tab Content ───────────────────────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(controller: _tabCtrl, children: [
                    _CoursesTab(
                      courses: _courses,
                      students: _students,
                      onAssignTeacher: _showAssignTeacher,
                    ),
                    _UsersTab(users: _teachers, role: 'teacher', onApprove: _approveUser, onDelete: _deleteUser),
                    _UsersTab(users: _students, role: 'student', onApprove: _approveUser, onDelete: _deleteUser),
                    _PostsTab(posts: _posts),
                    _RequestsTab(
                      requests: _requests,
                      onApprove: _approveRequest,
                      onReject:  _rejectRequest,
                    ),
                  ]),
          ),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// HEADER SUBWIDGETS
// ══════════════════════════════════════════════════════════════════════════════

class _AdminStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final bool highlight;

  const _AdminStat({required this.label, required this.value, required this.icon, this.highlight = false});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
    decoration: BoxDecoration(
      color: highlight ? AppColors.orange.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: highlight ? AppColors.orange.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.25)),
    ),
    child: Column(children: [
      Icon(icon, color: Colors.white, size: 18),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 2),
      Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 9), textAlign: TextAlign.center),
    ]),
  );
}

class _BadgeTab extends StatelessWidget {
  final String text;
  final int count, pending;
  final Color badgeColor;

  const _BadgeTab({required this.text, required this.count, required this.pending, this.badgeColor = Colors.red});

  @override
  Widget build(BuildContext context) => Tab(
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text('$text ($count)'),
      if (pending > 0) ...[
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(10)),
          child: Text('$pending', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    ]),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// COURSES TAB
// ══════════════════════════════════════════════════════════════════════════════

class _CoursesTab extends StatelessWidget {
  final List<AdminCourse> courses;
  final List<AdminUser>   students;
  final void Function(AdminCourse) onAssignTeacher;

  const _CoursesTab({required this.courses, required this.students, required this.onAssignTeacher});

  static const _grads = [AppGradients.cyan, AppGradients.emerald, AppGradients.purple, AppGradients.orange];

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) return const _EmptyState(icon: Icons.menu_book_rounded, label: 'No courses yet');
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final c = courses[i];
        final grad = _grads[c.id.hashCode.abs() % _grads.length];
        final hasTeacher = c.teacherId != null;
        final enrolled = students.where((s) => c.studentIds.contains(s.id)).toList();

        return GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Top row: icon + name + student count
            Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  gradient: grad, borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: grad.colors.first.withValues(alpha: 0.3), blurRadius: 8)],
                ),
                child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                if (c.description?.isNotEmpty == true) ...[
                  const SizedBox(height: 2),
                  Text(c.description!, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
                const SizedBox(height: 4),
                Text('${c.studentIds.length}${c.maxStudents != null ? '/${c.maxStudents}' : ''} students',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              ])),
            ]),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),
            // Teacher row
            Row(children: [
              const Icon(Icons.school_rounded, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(child: hasTeacher
                  ? Text(c.teacherName!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))
                  : Text('No teacher assigned', style: TextStyle(fontSize: 13, color: Colors.orange.shade700, fontStyle: FontStyle.italic))),
              _ActionChip(
                label: hasTeacher ? 'Change' : 'Assign',
                icon: Icons.person_add_rounded,
                color: hasTeacher ? AppColors.violet : AppColors.orange,
                onTap: () => onAssignTeacher(c),
              ),
            ]),
            if (enrolled.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(children: [
                const Icon(Icons.people_rounded, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                ...enrolled.take(4).map((s) => Container(
                  width: 26, height: 26, margin: const EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    gradient: _grads[s.id.hashCode.abs() % _grads.length],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Center(child: Text(s.initials, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
                )),
                if (enrolled.length > 4)
                  Container(
                    width: 26, height: 26,
                    decoration: BoxDecoration(color: AppColors.border, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                    child: Center(child: Text('+${enrolled.length - 4}', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
                  ),
              ]),
            ],
          ]),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// USERS TAB
// ══════════════════════════════════════════════════════════════════════════════

class _UsersTab extends StatelessWidget {
  final List<AdminUser> users;
  final String role;
  final Future<void> Function(AdminUser) onApprove;
  final Future<void> Function(AdminUser) onDelete;

  const _UsersTab({required this.users, required this.role, required this.onApprove, required this.onDelete});

  static const _grads = [AppGradients.cyan, AppGradients.emerald, AppGradients.purple, AppGradients.orange];

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return _EmptyState(icon: role == 'teacher' ? Icons.school_rounded : Icons.people_rounded, label: 'No ${role}s yet');

    final pending   = users.where((u) => !u.approved).toList();
    final approved  = users.where((u) => u.approved).toList();

    return ListView(padding: const EdgeInsets.all(16), children: [
      if (pending.isNotEmpty) ...[
        const Text('Pending Approval', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.orange)),
        const SizedBox(height: 8),
        ...pending.map((u) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _UserCard(user: u, grad: _grads[u.id.hashCode.abs() % _grads.length], onApprove: onApprove, onDelete: onDelete),
        )),
        const SizedBox(height: 16),
        const Divider(color: AppColors.border),
        const SizedBox(height: 12),
      ],
      if (approved.isNotEmpty) ...[
        Text('Active ${role == 'teacher' ? 'Teachers' : 'Students'} (${approved.length})',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        ...approved.map((u) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _UserCard(user: u, grad: _grads[u.id.hashCode.abs() % _grads.length], onApprove: onApprove, onDelete: onDelete),
        )),
      ],
    ]);
  }
}

class _UserCard extends StatelessWidget {
  final AdminUser user;
  final LinearGradient grad;
  final Future<void> Function(AdminUser) onApprove;
  final Future<void> Function(AdminUser) onDelete;

  const _UserCard({required this.user, required this.grad, required this.onApprove, required this.onDelete});

  @override
  Widget build(BuildContext context) => GlassCard(
    padding: const EdgeInsets.all(14),
    child: Row(children: [
      Container(
        width: 44, height: 44,
        decoration: BoxDecoration(gradient: grad, shape: BoxShape.circle),
        child: Center(child: Text(user.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
        const SizedBox(height: 2),
        Text(user.email, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        if (!user.approved) ...[
          const SizedBox(height: 4),
          InfoChip(label: 'Pending approval', color: AppColors.orange),
        ],
      ])),
      if (!user.approved)
        _ActionChip(label: 'Approve', icon: Icons.check_rounded, color: AppColors.emerald, onTap: () => onApprove(user))
      else
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
          onPressed: () => onDelete(user),
        ),
    ]),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// POSTS TAB
// ══════════════════════════════════════════════════════════════════════════════

class _PostsTab extends StatelessWidget {
  final List<AdminPost> posts;
  const _PostsTab({required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) return const _EmptyState(icon: Icons.article_rounded, label: 'No posts yet');
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final p = posts[i];
        final isAnn = p.type == 'announcement';
        return GlassCard(
          padding: const EdgeInsets.all(14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (isAnn ? AppColors.violet : AppColors.orange).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(isAnn ? Icons.campaign_rounded : Icons.quiz_rounded,
                  color: isAnn ? AppColors.violet : AppColors.orange, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
              const SizedBox(height: 3),
              Text(p.content, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
              const SizedBox(height: 6),
              Row(children: [
                Text(p.authorName, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                const Text(' · ', style: TextStyle(color: AppColors.textSecondary)),
                Text(p.courseName, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ]),
            ])),
          ]),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// REQUESTS TAB  ← the new Teacher→Admin workflow
// ══════════════════════════════════════════════════════════════════════════════

class _RequestsTab extends StatelessWidget {
  final List<CourseRequest> requests;
  final void Function(CourseRequest) onApprove;
  final void Function(CourseRequest) onReject;

  const _RequestsTab({required this.requests, required this.onApprove, required this.onReject});

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const _EmptyState(
        icon: Icons.inbox_rounded,
        label: 'No pending course requests',
        subtitle: 'Teachers can submit requests from their dashboard',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _RequestCard(request: requests[i], onApprove: onApprove, onReject: onReject),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final CourseRequest request;
  final void Function(CourseRequest) onApprove;
  final void Function(CourseRequest) onReject;

  const _RequestCard({required this.request, required this.onApprove, required this.onReject});

  @override
  Widget build(BuildContext context) {
    final hoursAgo = DateTime.now().difference(request.createdAt).inHours;
    final timeLabel = hoursAgo == 0 ? 'Just now' : '${hoursAgo}h ago';

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Pending badge + timestamp
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Pending Review', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.orange)),
          ),
          const Spacer(),
          Text(timeLabel, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ]),
        const SizedBox(height: 12),

        // Course title
        Text(request.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textPrimary)),
        const SizedBox(height: 6),

        // Description
        if (request.description.isNotEmpty) ...[
          Text(request.description,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
          const SizedBox(height: 12),
        ],

        // Meta info row
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(children: [
            const Icon(Icons.school_rounded, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Expanded(child: Text(request.teacherName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
            const Icon(Icons.people_rounded, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text('${request.studentCount} students', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ]),
        ),
        const SizedBox(height: 14),

        // Action buttons
        Row(children: [
          Expanded(child: OutlinedButton.icon(
            onPressed: () => onReject(request),
            icon: const Icon(Icons.close_rounded, size: 16, color: Colors.red),
            label: const Text('Reject', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          )),
          const SizedBox(width: 10),
          Expanded(child: ElevatedButton.icon(
            onPressed: () => onApprove(request),
            icon: const Icon(Icons.check_rounded, size: 16, color: Colors.white),
            label: const Text('Approve', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emerald,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          )),
        ]),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// ASSIGN TEACHER SHEET
// ══════════════════════════════════════════════════════════════════════════════

class _AssignTeacherSheet extends StatelessWidget {
  final AdminCourse course;
  final List<AdminUser> teachers;
  final void Function(AdminUser) onAssign;

  const _AssignTeacherSheet({required this.course, required this.teachers, required this.onAssign});

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    padding: const EdgeInsets.all(24),
    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Assign Teacher to "${course.name}"', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      const SizedBox(height: 16),
      if (teachers.isEmpty)
        const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Text('No approved teachers available', style: TextStyle(color: AppColors.textSecondary))),
        )
      else
        ...teachers.map((t) => ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.violet.withValues(alpha: 0.12),
            child: Text(t.initials, style: const TextStyle(color: AppColors.violet, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          title: Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(t.email),
          trailing: t.id == course.teacherId
              ? const Icon(Icons.check_circle_rounded, color: AppColors.emerald)
              : null,
          onTap: () {
            onAssign(t);
            Navigator.pop(context);
          },
        )),
    ]),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// SHARED HELPER WIDGETS
// ══════════════════════════════════════════════════════════════════════════════

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
      ]),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;

  const _EmptyState({required this.icon, required this.label, this.subtitle});

  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.violet.withValues(alpha: 0.08), shape: BoxShape.circle),
      child: Icon(icon, color: AppColors.violet, size: 40),
    ),
    const SizedBox(height: 16),
    Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
    if (subtitle != null) ...[
      const SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(subtitle!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
      ),
    ],
  ]));
}

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String label, hint;
  final int maxLines;
  final TextInputType? keyboardType;

  const _TextField({required this.controller, required this.label, required this.hint, this.maxLines = 1, this.keyboardType});

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    maxLines: maxLines,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: label, hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
