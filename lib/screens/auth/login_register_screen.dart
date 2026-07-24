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
        // Mock Login as Admin or pre-existing user
        final email = _emailController.text.trim().toLowerCase();
        UserModel loggedInUser;
        if (email.contains('admin')) {
          loggedInUser = UserModel(
            id: 'ADM-001',
            name: 'System Administrator',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            maxWidth: 440,
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppTheme.darkCardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.darkBorderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
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
                  // Logo Banner
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
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LearnSpace LMS', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('Enterprise Education Platform', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Mode Toggle Header
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
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (_isRegisterMode) ...[
                    // Role Selector
                    const Text('Register as:', style: TextStyle(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Teacher Application'),
                            selected: _selectedRole == UserRole.teacher,
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedRole = UserRole.teacher);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Student Registration'),
                            selected: _selectedRole == UserRole.student,
                            onSelected: (selected) {
                              if (selected) setState(() => _selectedRole = UserRole.student);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name', hintText: 'Dr. Jane Doe'),
                      validator: (val) => val == null || val.isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _deptController,
                      decoration: const InputDecoration(labelText: 'Department', hintText: 'Computer Science'),
                      validator: (val) => val == null || val.isEmpty ? 'Please enter your department' : null,
                    ),
                    const SizedBox(height: 12),
                  ],

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: _isRegisterMode ? 'user@university.edu' : 'admin@learnspace.edu / teacher@uni.edu',
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Please enter a valid email' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password', hintText: '••••••••'),
                    validator: (val) => val == null || val.length < 4 ? 'Password must be at least 4 chars' : null,
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(_isRegisterMode ? 'Submit Registration Application' : 'Sign In to Portal'),
                    ),
                  ),

                  if (!_isRegisterMode) ...[
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'Demo Quick Logins: admin@... / teacher@... / student@...',
                        style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
