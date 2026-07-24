import 'package:flutter/material.dart';
import 'models/user_role.dart';
import 'theme/app_theme.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/teacher_portal_screen.dart';
import 'screens/student_dashboard_screen.dart';
import 'widgets/ai_assistant_dialog.dart';

void main() {
  runApp(const LearnSpaceLmsApp());
}

class LearnSpaceLmsApp extends StatelessWidget {
  const LearnSpaceLmsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnSpace Enterprise LMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainLmsShell(),
    );
  }
}

class MainLmsShell extends StatefulWidget {
  const MainLmsShell({Key? key}) : super(key: key);

  @override
  State<MainLmsShell> createState() => _MainLmsShellState();
}

class _MainLmsShellState extends State<MainLmsShell> {
  UserRole _currentRole = UserRole.student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('L', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            const SizedBox(width: 8),
            const Text('LearnSpace', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('v2.4', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        actions: [
          // AI Features button
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: AppTheme.accentColor),
            tooltip: 'AI Suite',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const AIAssistantDialog(),
              );
            },
          ),

          // Role Switcher Dropdown
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<UserRole>(
                value: _currentRole,
                dropdownColor: AppTheme.darkCardColor,
                icon: const Icon(Icons.swap_horiz, color: AppTheme.textMuted, size: 18),
                onChanged: (UserRole? newRole) {
                  if (newRole != null) {
                    setState(() => _currentRole = newRole);
                  }
                },
                items: UserRole.values.map((role) {
                  return DropdownMenuItem<UserRole>(
                    value: role,
                    child: Text(
                      role.displayName,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppTheme.darkCardColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.darkSurfaceColor),
              accountName: Text(
                _currentRole == UserRole.admin
                    ? 'System Administrator'
                    : _currentRole == UserRole.teacher
                        ? 'Dr. Elena Vasquez'
                        : 'Amara Diallo',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                'Role: ${_currentRole.displayName}',
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.3),
                child: Text(_currentRole.initials, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: AppTheme.primaryColor),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.class_, color: AppTheme.accentColor),
              title: const Text('My Courses'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.video_call, color: Colors.orange),
              title: const Text('Live Classrooms'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome, color: Colors.purpleAccent),
              title: const Text('AI Learning Suite'),
              onTap: () {
                Navigator.pop(context);
                showDialog(context: context, builder: (_) => const AIAssistantDialog());
              },
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildRoleScreen(),
      ),
    );
  }

  Widget _buildRoleScreen() {
    switch (_currentRole) {
      case UserRole.admin:
        return const AdminDashboardScreen(key: ValueKey('admin'));
      case UserRole.teacher:
        return const TeacherPortalScreen(key: ValueKey('teacher'));
      case UserRole.student:
        return const StudentDashboardScreen(key: ValueKey('student'));
    }
  }
}
