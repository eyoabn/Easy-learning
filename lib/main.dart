import 'package:flutter/material.dart';
import 'models/user_role.dart';
import 'models/user_model.dart';
import 'models/lms_data.dart';
import 'theme/app_theme.dart';
import 'screens/auth/login_register_screen.dart';
import 'screens/auth/pending_approval_screen.dart';
import 'screens/layout_screen.dart';

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
      theme: AppTheme.theme, // Use the new theme from AppTheme
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
    // Default initial user for development
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
              const SnackBar(content: Text('Account approved by Manager! Portal unlocked.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Status: Still pending System Admin (Manager) verification.')),
            );
          }
        },
        onSignOut: _signOut,
      );
    }

    return LayoutScreen(
      user: _currentUser!,
      onLogout: _signOut,
    );
  }
}
