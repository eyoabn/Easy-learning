import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

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
  final List<String> targetClasses;

  AdminCourse({
    required this.id,
    required this.name,
    this.teacherId,
    this.teacherName,
    List<String>? studentIds,
    List<String>? targetClasses,
  }) : studentIds = studentIds ?? [],
       targetClasses = targetClasses ?? [];
}

class AdminPost {
  final String id;
  final String title;
  final String content;
  final String authorName;
  final String type; // 'announcement' or 'question'
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

// ── Mock data ────────────────────────────────────────────────────────
final _mockTeachers = [
  AdminUser(id: 't1', name: 'Dr. Sarah Johnson',  email: 'sarah.j@school.edu',   role: 'teacher', approved: true),
  AdminUser(id: 't2', name: 'Prof. Michael Chen', email: 'michael.c@school.edu', role: 'teacher', approved: false),
];

final _mockStudents = [
  AdminUser(id: 's1', name: 'Alice Johnson',  email: 'alice.j@school.edu',  role: 'student', approved: true),
  AdminUser(id: 's2', name: 'Bob Smith',      email: 'bob.s@school.edu',    role: 'student', approved: false),
];

final _mockCourses = [
  AdminCourse(id: 'c1', name: 'Mathematics 101',  teacherId: 't1', teacherName: 'Dr. Sarah Johnson',  studentIds: ['s1', 's2']),
  AdminCourse(id: 'c2', name: 'Physics Advanced',  teacherId: 't2', teacherName: 'Prof. Michael Chen', studentIds: ['s2']),
  AdminCourse(id: 'c3', name: 'English Literature', teacherId: null, teacherName: null,                 studentIds: []),
];

final _mockPosts = [
  AdminPost(id: 'p1', title: 'Welcome to new semester', content: 'Classes start tomorrow.', authorName: 'Dr. Sarah Johnson', type: 'announcement', createdAt: DateTime.now(), courseName: 'General'),
];

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  List<AdminCourse> _courses  = [];
  List<AdminUser>   _teachers = [];
  List<AdminUser>   _students = [];
  List<AdminPost>   _posts    = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _tabCtrl.addListener(() {
      if (mounted) setState(() {});
    });
    _load();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate load
    if (mounted) {
      setState(() {
        _courses  = List.from(_mockCourses);
        _teachers = List.from(_mockTeachers);
        _students = List.from(_mockStudents);
        _posts    = List.from(_mockPosts);
        _loading  = false;
      });
    }
  }

  Future<void> _approveUser(AdminUser user) async {
    setState(() {
      final tIndex = _teachers.indexWhere((u) => u.id == user.id);
      if (tIndex >= 0) {
        _teachers[tIndex] = AdminUser(id: user.id, name: user.name, email: user.email, role: user.role, approved: true);
      }
      final sIndex = _students.indexWhere((u) => u.id == user.id);
      if (sIndex >= 0) {
        _students[sIndex] = AdminUser(id: user.id, name: user.name, email: user.email, role: user.role, approved: true);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user.name} approved successfully'), backgroundColor: Colors.green));
  }

  Future<void> _deleteUser(AdminUser user) async {
    setState(() {
      _teachers.removeWhere((u) => u.id == user.id);
      _students.removeWhere((u) => u.id == user.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user.name} removed successfully'), backgroundColor: Colors.red));
  }

  void _showAssignTeacher(AdminCourse course) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assign teacher mock.')));
  }

  void _showAssignStudents(AdminCourse course) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Assign students mock.')));
  }

  void _showCreateCourse() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create course mock.')));
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          children: [
            // Header and Tab bar (not scrollable)
            GradientHeader(
              gradient: AppGradients.primary,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Admin Panel',
                          style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text('System Administrator',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13)),
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
                  const SizedBox(height: 18),
                  if (!_loading) _StatRow(
                    courses:  _courses.length,
                    teachers: _teachers.length,
                    students: _students.length,
                    unassigned: _courses.where((c) => c.teacherId == null).length,
                  ),
                ]),
              ),
            ),
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabCtrl,
                labelColor: AppColors.violet,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                indicatorColor: AppColors.violet,
                indicatorWeight: 3,
                isScrollable: true,
                tabs: [
                  Tab(text: 'Courses (${_courses.length})'),
                  Tab(child: _TabLabel(
                    text: 'Teachers',
                    count: _teachers.length,
                    pending: _teachers.where((u) => !u.approved).length,
                  )),
                  Tab(child: _TabLabel(
                    text: 'Students',
                    count: _students.length,
                    pending: _students.where((u) => !u.approved).length,
                  )),
                  Tab(text: 'Posts (${_posts.length})'),
                ],
              ),
            ),
            // Content area
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(controller: _tabCtrl, children: [
                      _CourseTab(
                        courses: _courses,
                        students: _students,
                        onAssignTeacher:  _showAssignTeacher,
                        onAssignStudents: _showAssignStudents,
                      ),
                      _UserTab(users: _teachers, role: 'teacher', onApprove: _approveUser, onDelete: _deleteUser),
                      _UserTab(users: _students, role: 'student', onApprove: _approveUser, onDelete: _deleteUser),
                      const Center(child: Text("Posts Tab")),
                    ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final int courses, teachers, students, unassigned;
  const _StatRow({required this.courses, required this.teachers, required this.students, required this.unassigned});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('Courses', courses.toString()),
          _buildStat('Teachers', teachers.toString()),
          _buildStat('Students', students.toString()),
          _buildStat('Pending', unassigned.toString(), color: Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String val, {Color? color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(val, style: TextStyle(color: color ?? Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10)),
      ],
    );
  }
}

class _TabLabel extends StatelessWidget {
  final String text;
  final int count;
  final int pending;
  const _TabLabel({required this.text, required this.count, required this.pending});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$text ($count)'),
        if (pending > 0) ...[
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
            child: Text('$pending', style: const TextStyle(color: Colors.white, fontSize: 10)),
          ),
        ],
      ],
    );
  }
}

class _CourseTab extends StatelessWidget {
  final List<AdminCourse> courses;
  final List<AdminUser> students;
  final Function(AdminCourse) onAssignTeacher;
  final Function(AdminCourse) onAssignStudents;

  const _CourseTab({required this.courses, required this.students, required this.onAssignTeacher, required this.onAssignStudents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: courses.length,
      itemBuilder: (ctx, i) {
        final c = courses[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(c.teacherName ?? 'No teacher assigned'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => onAssignTeacher(c),
          ),
        );
      },
    );
  }
}

class _UserTab extends StatelessWidget {
  final List<AdminUser> users;
  final String role;
  final Function(AdminUser) onApprove;
  final Function(AdminUser) onDelete;

  const _UserTab({required this.users, required this.role, required this.onApprove, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (ctx, i) {
        final u = users[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: CircleAvatar(child: Text(u.initials)),
            title: Text(u.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(u.email),
            trailing: u.approved
                ? IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => onDelete(u))
                : ElevatedButton(onPressed: () => onApprove(u), child: const Text('Approve')),
          ),
        );
      },
    );
  }
}
