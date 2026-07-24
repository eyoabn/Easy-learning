import 'package:flutter/material.dart';
import '../../models/user_role.dart';
import '../../models/user_model.dart';
import '../../theme/app_theme.dart';

class LoginRegisterScreen extends StatefulWidget {
  final Function(UserModel user) onAuthSuccess;
  final Function(UserModel newUser) onRegisterSubmitted;

  const LoginRegisterScreen({
    Key? key,
    required this.onAuthSuccess,
    required this.onRegisterSubmitted,
  }) : super(key: key);

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  bool _isRegisterMode = false;
  UserRole _selectedRole = UserRole.student;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _deptController = TextEditingController(text: 'Computer Science');

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_isRegisterMode) {
        final newUser = UserModel(
          id: 'USR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          role: _selectedRole,
          department: _deptController.text.trim(),
          accountStatus: AccountStatus.pendingAdmin,
          registeredAt: 'Just now',
        );
        widget.onRegisterSubmitted(newUser);
      } else {
        final email = _emailController.text.trim().toLowerCase();
        UserModel loggedInUser;
        if (email.contains('admin') || email.contains('manager')) {
          loggedInUser = UserModel(
            id: 'ADM-001',
            name: 'System Administrator (Manager)',
            email: 'admin@learnspace.edu',
            role: UserRole.admin,
            department: 'Institutional Governance',
            accountStatus: AccountStatus.approved,
            registeredAt: '2026-01-01',
          );
        } else if (email.contains('teacher') || email.contains('vasquez')) {
          loggedInUser = UserModel(
            id: 'TCH-101',
            name: 'Dr. Elena Vasquez',
            email: 'e.vasquez@uni.edu',
            role: UserRole.teacher,
            department: 'Computer Science',
            accountStatus: AccountStatus.approved,
            registeredAt: '2026-02-10',
          );
        } else {
          loggedInUser = UserModel(
            id: 'STD-201',
            name: 'Amara Diallo',
            email: 'a.diallo@student.edu',
            role: UserRole.student,
            department: 'Computer Science',
            accountStatus: AccountStatus.approved,
            registeredAt: '2026-03-15',
          );
        }
        widget.onAuthSuccess(loggedInUser);
      }
    }
  }

  void _quickLogin(UserRole role) {
    UserModel loggedInUser;
    switch (role) {
      case UserRole.admin:
        loggedInUser = UserModel(
          id: 'ADM-001',
          name: 'System Administrator (Manager)',
          email: 'admin@learnspace.edu',
          role: UserRole.admin,
          department: 'Institutional Governance',
          accountStatus: AccountStatus.approved,
          registeredAt: '2026-01-01',
        );
        break;
      case UserRole.teacher:
        loggedInUser = UserModel(
          id: 'TCH-101',
          name: 'Dr. Elena Vasquez',
          email: 'e.vasquez@uni.edu',
          role: UserRole.teacher,
          department: 'Computer Science',
          accountStatus: AccountStatus.approved,
          registeredAt: '2026-02-10',
        );
        break;
      case UserRole.student:
        loggedInUser = UserModel(
          id: 'STD-201',
          name: 'Amara Diallo',
          email: 'a.diallo@student.edu',
          role: UserRole.student,
          department: 'Computer Science',
          accountStatus: AccountStatus.approved,
          registeredAt: '2026-03-15',
        );
        break;
    }
    widget.onAuthSuccess(loggedInUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.darkCardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.darkBorderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Logo Banner (Expanded to prevent overflow)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppTheme.primaryGradientStart, AppTheme.primaryGradientEnd],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('L', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'LearnSpace LMS',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Enterprise Education Platform',
                                  style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Sign In / Register Switcher
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isRegisterMode = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: !_isRegisterMode ? AppTheme.primaryColor : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: !_isRegisterMode ? AppTheme.primaryColor : AppTheme.textMuted,
                                    fontWeight: !_isRegisterMode ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isRegisterMode = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _isRegisterMode ? AppTheme.primaryColor : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Register Account',
                                  style: TextStyle(
                                    color: _isRegisterMode ? AppTheme.primaryColor : AppTheme.textMuted,
                                    fontWeight: _isRegisterMode ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      if (_isRegisterMode) ...[
                        const Text('Select Role:', style: TextStyle(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                label: const Text('Teacher', style: TextStyle(fontSize: 12)),
                                selected: _selectedRole == UserRole.teacher,
                                onSelected: (selected) {
                                  if (selected) setState(() => _selectedRole = UserRole.teacher);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ChoiceChip(
                                label: const Text('Student', style: TextStyle(fontSize: 12)),
                                selected: _selectedRole == UserRole.student,
                                onSelected: (selected) {
                                  if (selected) setState(() => _selectedRole = UserRole.student);
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(fontSize: 13, color: Colors.white),
                          decoration: const InputDecoration(labelText: 'Full Name', hintText: 'Dr. Jane Doe'),
                          validator: (val) => val == null || val.isEmpty ? 'Please enter your name' : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _deptController,
                          style: const TextStyle(fontSize: 13, color: Colors.white),
                          decoration: const InputDecoration(labelText: 'Department', hintText: 'Computer Science'),
                          validator: (val) => val == null || val.isEmpty ? 'Please enter your department' : null,
                        ),
                        const SizedBox(height: 10),
                      ],

                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          hintText: _isRegisterMode ? 'user@university.edu' : 'admin@learnspace.edu',
                        ),
                        validator: (val) => val == null || val.isEmpty ? 'Please enter a valid email' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: const TextStyle(fontSize: 13, color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Password', hintText: '••••••••'),
                        validator: (val) => val == null || val.length < 4 ? 'Password must be at least 4 chars' : null,
                      ),
                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            _isRegisterMode ? 'Submit Registration for Approval' : 'Sign In to Portal',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Quick Actor Direct Login (Responsive Wrap)
                      const Text(
                        'Direct Role Login (Testing & Demo):',
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          ActionChip(
                            avatar: const Icon(Icons.security, size: 14, color: AppTheme.warningColor),
                            label: const Text('Admin (Manager)', style: TextStyle(fontSize: 11, color: Colors.white)),
                            backgroundColor: AppTheme.darkSurfaceColor,
                            side: const BorderSide(color: AppTheme.darkBorderColor),
                            onPressed: () => _quickLogin(UserRole.admin),
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.school, size: 14, color: AppTheme.primaryColor),
                            label: const Text('Teacher Portal', style: TextStyle(fontSize: 11, color: Colors.white)),
                            backgroundColor: AppTheme.darkSurfaceColor,
                            side: const BorderSide(color: AppTheme.darkBorderColor),
                            onPressed: () => _quickLogin(UserRole.teacher),
                          ),
                          ActionChip(
                            avatar: const Icon(Icons.person, size: 14, color: AppTheme.accentColor),
                            label: const Text('Student Dashboard', style: TextStyle(fontSize: 11, color: Colors.white)),
                            backgroundColor: AppTheme.darkSurfaceColor,
                            side: const BorderSide(color: AppTheme.darkBorderColor),
                            onPressed: () => _quickLogin(UserRole.student),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
