import 'package:flutter/material.dart';
import 'models/user_role.dart';
import 'models/user_model.dart';
import 'models/lms_data.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_register_screen.dart';
import 'screens/auth/pending_approval_screen.dart';
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
  UserModel? _currentUser;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    // Default demo user: Approved Student
    _currentUser = UserModel(
      id: 'STD-201',
      name: 'Amara Diallo',
      email: 'a.diallo@student.edu',
      role: UserRole.student,
      department: 'Computer Science',
      accountStatus: AccountStatus.approved,
      registeredAt: '2026-03-15',
    );
    _isAuthenticated = true;
  }

  void _handleAuthSuccess(UserModel user) {
    setState(() {
      _currentUser = user;
      _isAuthenticated = true;
    });
  }

  void _handleRegisterSubmitted(UserModel newUser) {
    setState(() {
      LmsDataMock.pendingRegistrations.add(newUser);
      _currentUser = newUser;
      _isAuthenticated = true;
    });
  }

  void _signOut() {
    setState(() {
      _currentUser = null;
      _isAuthenticated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated || _currentUser == null) {
      return LoginRegisterScreen(
        onAuthSuccess: _handleAuthSuccess,
        onRegisterSubmitted: _handleRegisterSubmitted,
      );
    }

    if (_currentUser!.accountStatus == AccountStatus.pendingAdmin) {
      return PendingApprovalScreen(
        user: _currentUser!,
        onCheckStatus: () {
          setState(() {});
          if (_currentUser!.accountStatus == AccountStatus.approved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account approved! Portal unlocked.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Status: Still waiting for System Admin verification.')),
            );
          }
        },
        onSignOut: _signOut,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryGradientStart, AppTheme.primaryGradientEnd],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('L', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            const SizedBox(width: 10),
            const Text('LearnSpace', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
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

          // Role Switcher Dropdown for testing
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<UserRole>(
                value: _currentUser!.role,
                dropdownColor: AppTheme.darkCardColor,
                icon: const Icon(Icons.swap_horiz, color: AppTheme.textMuted, size: 18),
                onChanged: (UserRole? newRole) {
                  if (newRole != null) {
                    setState(() {
                      if (newRole == UserRole.admin) {
                        _currentUser = UserModel(
                          id: 'ADM-001',
                          name: 'System Administrator',
                          email: 'admin@learnspace.edu',
                          role: UserRole.admin,
                          department: 'Governance',
                          accountStatus: AccountStatus.approved,
                          registeredAt: '2026-01-01',
                        );
                      } else if (newRole == UserRole.teacher) {
                        _currentUser = UserModel(
                          id: 'TCH-101',
                          name: 'Dr. Elena Vasquez',
                          email: 'e.vasquez@uni.edu',
                          role: UserRole.teacher,
                          department: 'Computer Science',
                          accountStatus: AccountStatus.approved,
                          registeredAt: '2026-02-10',
                        );
                      } else {
                        _currentUser = UserModel(
                          id: 'STD-201',
                          name: 'Amara Diallo',
                          email: 'a.diallo@student.edu',
                          role: UserRole.student,
                          department: 'Computer Science',
                          accountStatus: AccountStatus.approved,
                          registeredAt: '2026-03-15',
                        );
                      }
                    });
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

          // Sign Out Button
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.textMuted, size: 20),
            tooltip: 'Sign Out',
            onPressed: _signOut,
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
                _currentUser!.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                'Role: ${_currentUser!.role.displayName} · ${_currentUser!.department}',
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.3),
                child: Text(_currentUser!.role.initials, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
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
              leading: const Icon(Icons.video_call, color: AppTheme.warningColor),
              title: const Text('Live Classrooms (LiveKit)'),
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
            const Divider(color: AppTheme.darkBorderColor),
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.alertRed),
              title: const Text('Sign Out', style: TextStyle(color: AppTheme.alertRed)),
              onTap: () {
                Navigator.pop(context);
                _signOut();
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
    switch (_currentUser!.role) {
      case UserRole.admin:
        return const AdminDashboardScreen(key: ValueKey('admin'));
      case UserRole.teacher:
        return const TeacherPortalScreen(key: ValueKey('teacher'));
      case UserRole.student:
        return const StudentDashboardScreen(key: ValueKey('student'));
    }
  }
}
